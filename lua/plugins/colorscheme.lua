local appearance_file = vim.fn.expand("~/.cache/wezterm_appearance")
local set_background = function()
	local appearance = vim.fn.filereadable(appearance_file) == 1 and vim.fn.readfile(appearance_file)[1] or "dark"

	if appearance == "Light" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end

local fd = vim.loop.new_fs_event()
fd:start(appearance_file, {}, vim.schedule_wrap(set_background))

return {
	"EdenEast/nightfox.nvim",
	config = function()
		vim.api.nvim_create_autocmd("OptionSet", {
			pattern = "background",
			callback = function()
				local bg = vim.o.background
				vim.notify("Background changed to: " .. bg)
				if bg == "light" then
					vim.cmd.colorscheme("dayfox")
				else
					vim.cmd.colorscheme("nightfox")
				end
			end,
		})
	end,
}
