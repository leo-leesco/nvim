-- Enable every config in `lsp/` automatically.
-- `vim.lsp.enable` installs a FileType autocmd per server that starts/attaches
-- the client on matching buffers using its `filetypes` + `root_markers`/`root_dir`.
local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
local servers = {}
for _, f in ipairs(vim.fn.readdir(lsp_dir)) do
	local name = f:match("^(.+)%.lua$")
	if name then table.insert(servers, name) end
end

-- Wire blink.cmp's extended capabilities into every server. Guarded so a
-- broken blink.cmp costs completion capabilities, not the `vim.lsp.enable`
-- below (i.e. all LSP).
local ok, blink = pcall(require, "blink.cmp")
if ok then
	vim.lsp.config("*", {
		capabilities = blink.get_lsp_capabilities(),
	})
else
	vim.notify("blink.cmp failed to load — LSP running with default capabilities", vim.log.levels.WARN)
end
vim.lsp.enable(servers)

-- Nvim 0.11+ ships defaults for grn/gra/grr/gri/grt/gO/K/<C-s>, but not `gd`
-- (it preserves vim's built-in local-definition search). Bind it per-buffer.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	end,
})
