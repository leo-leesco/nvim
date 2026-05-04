local function navigate(direction, tmux_direction)
	local winnr = vim.fn.winnr()
	vim.cmd("wincmd " .. direction)
	if vim.fn.winnr() == winnr then
		vim.fn.system("tmux select-pane -" .. tmux_direction)
	end
end

vim.keymap.set("n", "<C-h>", function() navigate("h", "L") end)
vim.keymap.set("n", "<C-j>", function() navigate("j", "D") end)
vim.keymap.set("n", "<C-k>", function() navigate("k", "U") end)
vim.keymap.set("n", "<C-l>", function() navigate("l", "R") end)

local au = vim.api.nvim_create_augroup("NvimTmuxNav", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
	group = au,
	callback = function() vim.fn.system("tmux set-option -p @is_vim on") end,
})
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
	group = au,
	callback = function() vim.fn.system("tmux set-option -p @is_vim off") end,
})
