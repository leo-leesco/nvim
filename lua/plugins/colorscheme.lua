local appearance_file = vim.fn.expand("~/.cache/wezterm_appearance")
local set_background = function()
	local appearance = vim.fn.filereadable(appearance_file) == 1 and vim.fn.readfile(appearance_file)[1] or "dark"
	local bg = appearance == "Light" and "light" or "dark"

	-- OptionSet fires on any :set, even without a value change; guard so a
	-- spurious fs_event doesn't reload the colorscheme (wiping highlight
	-- groups other plugins defined)
	if vim.o.background ~= bg then
		vim.o.background = bg
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
			-- without nested, the colorscheme reload below fires no ColorScheme
			-- event, so groups that plugins re-define on ColorScheme stay wiped
			nested = true,
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
