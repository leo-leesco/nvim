function mini_plugins_from_list(tbl)
	local result = {}
	for i, v in ipairs(tbl) do
		result[i] = {
			'echasnovski/mini.' .. v,
			version = '*',
			config = function()
				require('mini.' .. v).setup()
			end
		}
	end
	return result
end

local plugins = { "pairs", "align", "completion", "comment", "snippets", }

return mini_plugins_from_list(plugins)
