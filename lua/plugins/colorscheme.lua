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
	priority = 1000,
	config = function()
		local apply = function()
			if vim.o.background == "light" then
				vim.cmd.colorscheme("dayfox")
			else
				vim.cmd.colorscheme("nightfox")
			end
		end

		-- react to later light/dark switches while nvim is running
		vim.api.nvim_create_autocmd("OptionSet", {
			pattern = "background",
			callback = function()
				require "log" ("Background changed to: " .. vim.o.background)
				apply()
			end,
		})

		-- the fs_event above only fires on *changes*, so read the file
		-- and apply the matching colorscheme once at startup
		set_background()
		apply()
	end,
}
