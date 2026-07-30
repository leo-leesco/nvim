-- vsRocq: proof environment for Rocq (formerly Coq/VsCoq).
-- Server install: `opam install rocq-prover vsrocq-language-server`
--
-- setup() registers the LSP client itself (as "vscoqtop", its legacy name):
-- goals and stepping are custom `prover/*` protocol extensions it implements,
-- so the client config must stay in `opts.lsp` below — a file in `lsp/` would
-- be shadowed by setup() and make plugin/lsp.lua start a second, bare client.

-- Jump to the next incomplete proof, in tiers: a hanging proof (a `Proof`
-- never closed by Qed/Defined/Admitted/Abort — i.e. work in progress) first,
-- then Admitted/admit/give_up placeholders, then deliberate `Abort`s.
-- A plain text scan (skipping comments and strings) rather than asking the
-- server: in Manual mode the server only knows the region up to the last
-- interpreted point. Proofs written without the `Proof` keyword are missed.
local kw = [[\v<(Proof|Qed|Defined|Admitted|Abort|Save|admit|give_up)>]]

local function incomplete_positions()
	-- Coqtail bounds syntax syncing to 500 lines; comment blocks longer than
	-- that get misclassified, breaking the comment check below
	if not vim.b.rocq_sync_fromstart then
		vim.b.rocq_sync_fromstart = true
		vim.cmd("syntax sync fromstart")
	end
	local view = vim.fn.winsaveview()
	vim.fn.cursor(1, 1)
	local hanging, admitted, aborted = {}, {}, {}
	local open
	local flags = "cW"
	while true do
		local lnum, col = unpack(vim.fn.searchpos(kw, flags))
		flags = "W"
		if lnum == 0 then
			break
		end
		local syn = vim.fn.synIDattr(vim.fn.synID(lnum, col, false), "name"):lower()
		if not (syn:find("comment") or syn:find("string")) then
			local word = vim.fn.expand("<cword>")
			if word == "Proof" then
				if open then
					table.insert(hanging, open)
				end
				open = { lnum, col }
			elseif word == "admit" or word == "give_up" then
				table.insert(admitted, { lnum, col })
			elseif word == "Admitted" then
				open = nil
				table.insert(admitted, { lnum, col })
			elseif word == "Abort" then
				open = nil
				table.insert(aborted, { lnum, col })
			else -- Qed, Defined, Save
				open = nil
			end
		end
	end
	if open then
		table.insert(hanging, open)
	end
	vim.fn.winrestview(view)
	return #hanging > 0 and hanging or #admitted > 0 and admitted or aborted
end

local function jump_admitted(backward)
	local list = incomplete_positions()
	if #list == 0 then
		return vim.notify("no incomplete proof found")
	end
	local cl, cc = vim.fn.line("."), vim.fn.col(".")
	local target, wrapped
	if backward then
		for i = #list, 1, -1 do
			if list[i][1] < cl or (list[i][1] == cl and list[i][2] < cc) then
				target = list[i]
				break
			end
		end
		if not target then
			target, wrapped = list[#list], true
		end
	else
		for _, m in ipairs(list) do
			if m[1] > cl or (m[1] == cl and m[2] > cc) then
				target = m
				break
			end
		end
		if not target then
			target, wrapped = list[1], true
		end
	end
	vim.cmd("normal! m'") -- keep <C-o> working, like `n`
	vim.fn.cursor(target[1], target[2])
	if wrapped then
		vim.api.nvim_echo({ {
			backward and "search hit TOP, continuing at BOTTOM"
			or "search hit BOTTOM, continuing at TOP",
			"WarningMsg",
		} }, false, {})
	end
end

return {
	"tomtomjhj/vsrocq.nvim",
	ft = "coq",

	keys = {
		{ "]a", function() jump_admitted(false) end, ft = "coq", desc = "next incomplete proof" },
		{ "[a", function() jump_admitted(true) end,  ft = "coq", desc = "previous incomplete proof" },
	},

	dependencies = {
		{
			-- syntax/ftplugin only (no usable treesitter parser for Rocq)
			"whonore/Coqtail",
			init = function()
				vim.g.loaded_coqtail = 1
				-- read unguarded by the ftplugin (E121) but normally set by
				-- plugin/coqtail.vim, which loaded_coqtail suppresses;
				-- 0 would echo a Python warning on every buffer
				vim.g.coqtail_supported = 1
				vim.g.coqtail_nomap = 1
				vim.g.coqtail_tagfunc = 0
			end,
		},
	},

	init = function()
		-- *.v is heuristically Verilog / V-lang / Coq; empty files fall
		-- back to V-lang
		vim.g.filetype_v = "coq"

		-- default checked-region colors are garish; colorschemes `hi clear`
		-- (and the day/night switch reloads them), hence the autocmd
		local function checked_hl()
			vim.api.nvim_set_hl(0, "CoqtailChecked", { link = "DiffAdd" })
			vim.api.nvim_set_hl(0, "CoqtailSent", { link = "DiffChange" })
		end
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("RocqCheckedHighlight", { clear = true }),
			callback = checked_hl,
		})
		checked_hl()

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "coq",
			once = true,
			callback = function()
				require "ensure_installed" ("vsrocqtop", { "opam install", "rocq-prover vsrocq-language-server", "-y" })
			end,
		})

	end,

	opts = {
		-- server settings go here, never in lsp.settings/init_options:
		-- setup() asserts so and translates these to the wire format
		vsrocq = {
			proof = {
				-- "Continuous" checks the whole file; "Manual" checks nothing
				-- until asked — the CursorMoved autocmd below asks on every move
				mode = "Manual",

				-- in Manual mode the server sends prover/moveCursor whenever
				-- execution blocks on an error, pointing at the last checked
				-- sentence; sticky=true (default) would yank the cursor there
				-- on every move past an error
				cursor = { sticky = false },
			},
		},

		lsp = {
			-- binary and libraries must come from the project's opam switch,
			-- which opam resolves from its cwd; nvim ≤ 0.12 would spawn the
			-- server in nvim's cwd
			cmd = function(dispatchers, config)
				return vim.lsp.rpc.start(
					{ "opam", "exec", "--", "vsrocqtop" },
					dispatchers,
					{ cwd = config.root_dir }
				)
			end,
			on_attach = function(_, bufnr)
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					group = vim.api.nvim_create_augroup("RocqInterpretToPoint" .. bufnr, { clear = true }),
					buffer = bufnr,
					callback = function()
						vim.cmd("VsRocq interpretToPoint")
					end,
				})
			end,
		},
	},

	config = function(_, opts)
		require("vsrocq").setup(opts)

		local group = vim.api.nvim_create_augroup("RocqPanelAutoClose", { clear = true })

		local function count_coq_windows()
			local n = 0
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "coq" then
					n = n + 1
				end
			end
			return n
		end

		local function close_panels()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
				if ft == "coq-goals" or ft == "coq-infos" then
					pcall(vim.api.nvim_win_close, win, true)
				end
			end
		end

		vim.api.nvim_create_autocmd("QuitPre", {
			group = group,
			callback = function(args)
				if vim.bo[args.buf].filetype == "coq" and count_coq_windows() <= 1 then
					close_panels()
				end
			end,
		})

		vim.api.nvim_create_autocmd({ "BufWinLeave", "BufUnload" }, {
			group = group,
			callback = function(args)
				if vim.bo[args.buf].filetype ~= "coq" then
					return
				end
				vim.schedule(function()
					if count_coq_windows() == 0 then
						close_panels()
					end
				end)
			end,
		})
	end,
}
