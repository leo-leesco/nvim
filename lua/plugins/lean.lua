return {
	"Julian/lean.nvim",
	event = { "BufReadPre *.lean", "BufNewFile *.lean" },

	dependencies = {
		"nvim-lua/plenary.nvim",

		-- optional dependencies:

		-- a completion engine
		--    hrsh7th/nvim-cmp or Saghen/blink.cmp are popular choices

		-- 'nvim-telescope/telescope.nvim', -- for 2 Lean-specific pickers
		-- 'andymass/vim-matchup',          -- for enhanced % motion behavior
		-- 'andrewradev/switch.vim',        -- for switch support
		-- 'tomtom/tcomment_vim',           -- for commenting
	},

	---@type lean.Config
	opts = { -- see below for full configuration options
		mappings = true,
		infoview = {
			width = 1 / 4,
			height = 1 / 4,
			orientation = "auto",
		},
	},

	config = function(_, opts)
		require("lean").setup(opts)

		local group = vim.api.nvim_create_augroup("LeanInfoviewAutoClose", { clear = true })

		local function count_lean_windows()
			local n = 0
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "lean" then
					n = n + 1
				end
			end
			return n
		end

		vim.api.nvim_create_autocmd("QuitPre", {
			group = group,
			callback = function(args)
				if vim.bo[args.buf].filetype == "lean" and count_lean_windows() <= 1 then
					pcall(require("lean.infoview").close_all)
				end
			end,
		})

		vim.api.nvim_create_autocmd({ "BufWinLeave", "BufUnload" }, {
			group = group,
			callback = function(args)
				if vim.bo[args.buf].filetype ~= "lean" then
					return
				end
				vim.schedule(function()
					if count_lean_windows() == 0 then
						pcall(require("lean.infoview").close_all)
					end
				end)
			end,
		})
	end,
}
