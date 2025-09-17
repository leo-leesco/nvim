return {
	'tomtomjhj/vscoq.nvim',
	-- ft = { 'coq', 'v' },
	dependencies = {
		'whonore/Coqtail',
		init = function()
			vim.g.loaded_coqtail = 1
			vim.g["coqtail#supported"] = 0
		end,
	},
	opts = {
		vscoq = {
			completion = {
				enable = true,
			},
		},
		-- lsp = {
		-- 	on_attach = function(client, bufnr)
		-- 		local opts = { buffer = bufnr }
		-- 		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		-- 		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		--
		-- 		if client.server_capabilities.documentFormattingProvider then
		-- 			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
		-- 		end
		-- 	end,
		-- },
	},
}
