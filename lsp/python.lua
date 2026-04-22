---@brief
---
--- https://github.com/python-lsp/python-lsp-server
---
--- A Python 3.6+ implementation of the Language Server Protocol.
---
--- See the [project's README](https://github.com/python-lsp/python-lsp-server) for installation instructions.
---
--- Configuration options are documented [here](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md).
--- In order to configure an option, it must be translated to a nested Lua table and included in the `settings` argument to the `config('pylsp', {})` function.
--- For example, in order to set the `pylsp.plugins.pycodestyle.ignore` option:
--- ```lua
--- vim.lsp.config('pylsp', {
---   settings = {
---     pylsp = {
---       plugins = {
---         pycodestyle = {
---           ignore = {'W391'},
---           maxLineLength = 100
---         }
---       }
---     }
---   }
--- })
--- ```
---
--- Note: This is a community fork of `pyls`.

---@type vim.lsp.Config
return {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	before_init = function(_, config)
		local venv = (config.root_dir or "") .. "/.venv"
		if vim.uv.fs_stat(venv) then
			config.cmd = { venv .. "/bin/pylsp" }
			config.settings.pylsp.plugins.yapf.enabled =
					vim.uv.fs_stat(venv .. "/bin/yapf") ~= nil
		end
	end,
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = { enabled = false },
				autopep8    = { enabled = false },
				yapf        = { enabled = false }, -- overridden in before_init if in venv
			},
		},
	},
}
