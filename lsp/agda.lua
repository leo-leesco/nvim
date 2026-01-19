---@brief
---
--- https://github.com/agda/agda-language-server
---
--- Language Server for Agda.

---@type vim.lsp.Config
return {
	cmd = { 'als' },
	filetypes = { 'agda' },
	root_markers = { '.git' },
}
