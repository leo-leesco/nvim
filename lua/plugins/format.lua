function install(package_manager, package, flags)
	local sh_cmd = "!" .. package_manager .. " install " .. " " .. (flags or "") .. " " .. package
	vim.cmd(sh_cmd)
end

-- The formatter should be the first package of the dependency list
formatters = {
	lua = { deps = { "stylua" }, package_manager = "brew" },
	html = {
		deps = { "prettier" },
		package_manager = "bun",
		flags = "-g",
	},
	css = {
		deps = { "prettier" },
		package_manager = "bun",
		flags = "-g",
	},
	javascript = {
		deps = { "prettier" },
		package_manager = "bun",
		flags = "-g",
	},
	typescript = {
		deps = { "prettier" },
		package_manager = "bun",
		flags = "-g",
	},
	markdown = {
		deps = { "prettier" },
		package_manager = "bun",
		flags = "-g",
	},
	python = {
		deps = { "yapf" },
		package_manager = "pip3",
		flags = "--break-system-packages",
	},
	ocaml = {
		deps = { "ocamlformat" },
		package_manager = "opam",
		flags = "--yes",
	},
	tex = {
		deps = { "latexindent" },
		package_manager = "brew",
	},
	-- typst = {
	-- 	formatter = "tinymist",
	-- 	deps = { "https://github.com/Myriad-Dreamin/tinymist" },
	-- 	package_manager = "cargo",
	-- 	flags = "--locked tinymist-cli --git",
	-- },
}

formatters_by_ft = {}
for lang, install_spec in pairs(formatters) do
	if install_spec["formatter"] == nil then
		if formatters_by_ft[lang] == nil then
			formatters_by_ft[lang] = { install_spec["deps"][1] }
		else
			formatters_by_ft[lang].insert(install_spec["deps"][1])
		end
	else
		formatters_by_ft[lang] = { install_spec["formatter"] }
	end
	-- print(lang .. ":" .. install_spec["deps"][1])
end

-- CUSTOM COMMANDS
vim.api.nvim_create_user_command("FormatterInstallAll", function()
	for _, install_spec in pairs(formatters) do
		for _, package in ipairs(install_spec.deps) do
			install(install_spec.package_manager, package, install_spec.flags)
		end
	end
end, {})

vim.api.nvim_create_user_command("FormatterInstall", function(args)
	local formatter = formatters[args.args]
	if formatter ~= nil then
		for _, package in ipairs(formatter.deps) do
			install(formatter.package_manager, package, formatter.flags)
		end
	else
		print("available formatters :")
		for lang, formatter in pairs(formatters) do
			print(lang .. " : " .. formatter)
		end
	end
end, { nargs = "?" })

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = formatters_by_ft,
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_on_save = { timeout_ms = 500 },
		-- Customize formatters
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
