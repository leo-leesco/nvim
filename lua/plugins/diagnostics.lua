vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("TroubleAutoClose", { clear = true }),
	callback = function()
		local wins = vim.api.nvim_list_wins()

		if #wins == 1 then
			local buf = vim.api.nvim_win_get_buf(wins[1])
			if vim.bo[buf].filetype == "trouble" then
				vim.cmd.quit()
			end
		end
	end,
})

return {
	"folke/trouble.nvim",
	event = "LspAttach",
	opts = {
		modes = {
			diagnostics = {
				auto_close = true,
				auto_open = true,
				-- LaTeX errors are surfaced through vimtex's quickfix list and
				-- Rocq errors through vsrocq's panels, so exclude those buffers
				-- here to avoid a redundant Trouble window.
				-- The filter runs before the count that gates auto_open/auto_close,
				-- so Trouble simply never auto-opens *for* tex diagnostics (it still
				-- opens for other filetypes, even with a .tex buffer also open).
				filter = {
					["not"] = { ft = { "tex", "plaintex", "coq" } },
				},
			}
		}
	},
}
