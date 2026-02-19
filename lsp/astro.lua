---@brief
---
--- https://github.com/withastro/language-tools/tree/main/packages/language-server
---
--- `astro-ls` can be installed via `npm`:
--- ```sh
--- npm install -g @astrojs/language-server
--- ```

local util = require("lspconfig.util")

require "ensure_installed" ("bun", { "brew tap oven-sh/bun", "brew install bun" })

local server = "astro-ls"
require "ensure_installed" (server, { "bun install", "-g", server })

local formatter = "prettier"
require "ensure_installed" (formatter, { "bun install", "-g", formatter })

---@type vim.lsp.Config
return {
	cmd = { server, "--stdio" },
	filetypes = { "astro" },
	root_markers = {
		"astro.config.mjs",
		"astro.config.ts",
		"astro.config.js",
		"astro.config.js",
		"package.json",
		"tsconfig.json",
		"jsconfig.json",
		".git",
	},

	init_options = {
		typescript = {},
	},

	before_init = function(_, config)
		if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
			config.init_options.typescript.tsdk = util.get_typescript_server_path(config.root_dir)
		end
	end,
}
