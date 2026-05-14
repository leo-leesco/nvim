-- Enable every config in `lsp/` automatically.
-- `vim.lsp.enable` installs a FileType autocmd per server that starts/attaches
-- the client on matching buffers using its `filetypes` + `root_markers`/`root_dir`.
local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
local servers = {}
for _, f in ipairs(vim.fn.readdir(lsp_dir)) do
	local name = f:match("^(.+)%.lua$")
	if name then table.insert(servers, name) end
end

-- Wire blink.cmp's extended capabilities into every server.
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})
vim.lsp.enable(servers)
