local function install(package_manager, package, flags)
	local sh_cmd = "!" .. package_manager .. " install " .. (flags or "") .. " " .. package
	vim.cmd(sh_cmd)
end

local lsp_clients = {
	lua_ls = { deps = { "lua-language-server" }, package_manager = "brew" },
	rust_analyzer = { deps = { "rust-analyzer" }, package_manager = "brew" },
	pyright = { deps = { "pyright" }, package_manager = "pip3", flags = "--break-system-packages" },
	ocamllsp = { deps = { "ocaml-lsp-server" }, package_manager = "opam", flags = "--yes" },
	coq_lsp = { deps = { "coq-lsp" }, package_manager = "opam", flags = "--yes" },
	clangd = { deps = { "llvm" }, package_manager = "brew" },
	fish_lsp = { deps = { "fish-lsp" }, package_manager = "brew" },
	taplo = { deps = { "taplo-cli" }, package_manager = "cargo", flags = "--locked" },
	hls = { deps = { "haskell-language-server" }, package_manager = "brew" },
	marksman = { deps = { "marksman" }, package_manager = "brew" },
	emmet_language_server = {
		deps = { "@olrtg/emmet-language-server" },
		package_manager = "bun",
		flags = "-g",
	},
	ts_ls = {
		deps = {
			"typescript-language-server",
			"typescript",
		},
		package_manager = "bun",
		flags = "-g",
	},
	astro = {
		deps = {
			"typescript-language-server",
			"typescript",
			"prettier",
			"prettier-plugin-astro",
			"@astrojs/language-server",
			"@astrojs/ts-plugin",
		},
		package_manager = "bun",
		flags = "-g",
	},
	texlab = {
		deps = { "https://github.com/latex-lsp/texlab" },
		package_manager = "cargo",
		flags = "--locked --tag v5.23.1 --git",
	},
	ltex_plus = {
		deps = { "ltex-ls-plus" },
		package_manager = "brew",
	},
	tinymist = {
		deps = { "https://github.com/Myriad-Dreamin/tinymist" },
		package_manager = "cargo",
		flags = "--locked tinymist-cli --git",
	},
	vimls = {
		deps = { "vim-language-server" },
		package_manager = "npm",
		flags = "-g",
	},
	phpactor = {
		deps = { "phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar && chmod a+x phpactor.phar && mv phpactor.phar ~/.local/bin/phpactor" },
		package_manager = "curl",
		flags = "-Lo",
	},
}

-- CUSTOM COMMANDS
vim.api.nvim_create_user_command("LspInstallAll", function()
	for _, lsp in pairs(lsp_clients) do
		for _, package in ipairs(lsp.deps) do
			install(lsp.package_manager, package, lsp.flags)
		end
	end
end, {})

vim.api.nvim_create_user_command("LspInstall", function(args)
	local lsp = lsp_clients[args.args]
	if lsp ~= nil then
		for _, package in ipairs(lsp.deps) do
			install(lsp.package_manager, package, lsp.flags)
		end
	else
		print("available lsp_clients :")
		for ls, _ in pairs(lsp_clients) do
			print(ls)
		end
	end
end, { nargs = "?" })

-- enable formatting for typst source files
vim.lsp.config("tinymist", { settings = { formatterMode = "typstyle" } })

-- PHP specific
-- Allow 'gf' to work on lines like: require $root . '/path/file.php';
vim.api.nvim_create_autocmd("FileType", {
	pattern = "php",
	callback = function()
		-- 1. Find the project root directory (looks for .git, composer.json, or specific markers)
		-- 'vim.fs.find' scans upward from the current file
		local root_files = function(marker)
			return vim.fs.find(marker,
				{ path = vim.api.nvim_buf_get_name(0), upward = true, stop = vim.env.HOME, limit = 1 })
		end

		for _, marker in ipairs({ ".gitmodules", ".git", "composer.json", "index.php", "index.html" }) do
			local root = root_files(marker)
			if root and #root > 0 then
				-- 2. Extract the directory path from the result
				local project_root = vim.fs.dirname(root[1])

				-- 3. Append it to the 'path' option
				-- Now 'gf' will look for files relative to this folder
				vim.opt_local.path:append(project_root)

				-- Debug: verify it found the right root (uncomment to test)
				-- vim.notify(marker .. " -> Added to path: " .. project_root)
			end
		end
	end
})

-- Activate LSPs
for server in pairs(lsp_clients) do
	vim.lsp.config(server, { capabilities = require("blink.cmp").get_lsp_capabilities() })
	vim.lsp.enable(server)
end

-- CUSTOM KEYBINDINGS

-- show diagnostics
vim.keymap.set("n", "gk", function()
	vim.diagnostic.open_float()
end, { noremap = true })

-- go to definition
vim.keymap.set("n", "gd", function()
	vim.lsp.buf.definition()
end, { noremap = true })

-- toggle phantom diagnostics
vim.keymap.set("n", "<leader>k", function()
	if vim.diagnostic.is_enabled() then
		vim.diagnostic.hide()
	else
		vim.diagnostic.show()
	end
end)

-- from kickstart.nvim
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
-- 	callback = function(event)
-- 		-- NOTE: Remember that Lua is a real programming language, and as such it is possible
-- 		-- to define small helper and utility functions so you don't have to repeat yourself.
-- 		--
-- 		-- In this case, we create a function that lets us more easily define mappings specific
-- 		-- for LSP related items. It sets the mode, buffer and description for us each time.
-- 		local map = function(keys, func, desc, mode)
-- 			mode = mode or "n"
-- 			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
-- 		end
--
-- 		-- Rename the variable under your cursor.
-- 		--  Most Language Servers support renaming across files, etc.
-- 		map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
--
-- 		-- Execute a code action, usually your cursor needs to be on top of an error
-- 		-- or a suggestion from your LSP for this to activate.
-- 		map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
--
-- 		-- Find references for the word under your cursor.
-- 		map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
--
-- 		-- Jump to the implementation of the word under your cursor.
-- 		--  Useful when your language has ways of declaring types without an actual implementation.
-- 		map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
--
-- 		-- Jump to the definition of the word under your cursor.
-- 		--  This is where a variable was first declared, or where a function is defined, etc.
-- 		--  To jump back, press <C-t>.
-- 		map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
--
-- 		-- WARN: This is not Goto Definition, this is Goto Declaration.
-- 		--  For example, in C this would take you to the header.
-- 		map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
--
-- 		-- Fuzzy find all the symbols in your current document.
-- 		--  Symbols are things like variables, functions, types, etc.
-- 		map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
--
-- 		-- Fuzzy find all the symbols in your current workspace.
-- 		--  Similar to document symbols, except searches over your entire project.
-- 		map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
--
-- 		-- Jump to the type of the word under your cursor.
-- 		--  Useful when you're not sure what type a variable is and you want to see
-- 		--  the definition of its *type*, not where it was *defined*.
-- 		map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
--
-- 		-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
-- 		---@param client vim.lsp.Client
-- 		---@param method vim.lsp.protocol.Method
-- 		---@param bufnr? integer some lsp support methods only in specific files
-- 		---@return boolean
-- 		local function client_supports_method(client, method, bufnr)
-- 			if vim.fn.has("nvim-0.11") == 1 then
-- 				return client:supports_method(method, bufnr)
-- 			else
-- 				return client.supports_method(method, { bufnr = bufnr })
-- 			end
-- 		end
--
-- 		-- The following two autocommands are used to highlight references of the
-- 		-- word under your cursor when your cursor rests there for a little while.
-- 		--    See `:help CursorHold` for information about when this is executed
-- 		--
-- 		-- When you move your cursor, the highlights will be cleared (the second autocommand).
-- 		local client = vim.lsp.get_client_by_id(event.data.client_id)
-- 		if
-- 		    client
-- 		    and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
-- 		then
-- 			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight",
-- 				{ clear = false })
-- 			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
-- 				buffer = event.buf,
-- 				group = highlight_augroup,
-- 				callback = vim.lsp.buf.document_highlight,
-- 			})
--
-- 			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
-- 				buffer = event.buf,
-- 				group = highlight_augroup,
-- 				callback = vim.lsp.buf.clear_references,
-- 			})
--
-- 			vim.api.nvim_create_autocmd("LspDetach", {
-- 				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
-- 				callback = function(event2)
-- 					vim.lsp.buf.clear_references()
-- 					vim.api.nvim_clear_autocmds({
-- 						group = "kickstart-lsp-highlight",
-- 						buffer = event2
-- 						    .buf
-- 					})
-- 				end,
-- 			})
-- 		end
--
-- 		-- The following code creates a keymap to toggle inlay hints in your
-- 		-- code, if the language server you are using supports them
-- 		--
-- 		-- This may be unwanted, since they displace some of your code
-- 		if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
-- 			map("<leader>th", function()
-- 				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
-- 			end, "[T]oggle Inlay [H]ints")
-- 		end
-- 	end,
-- })

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
})
