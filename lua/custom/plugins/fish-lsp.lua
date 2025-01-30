return {
	'ndonfris/fish-lsp',
	config = function()
		vim.api.nvim_create_autocmd('FileType', {
			pattern = 'fish',
			callback = function()
				vim.lsp.start({
					name = 'fish-lsp',
					cmd = { 'fish-lsp', 'start' },
					cmd_env = { fish_lsp_show_client_popups = false },
				})
			end,
		})

		local lspconfig = require('lspconfig')

		-- Define the autocommands using the nvim API
		local group = vim.api.nvim_create_augroup('FishLSP', { clear = true })

		vim.api.nvim_create_autocmd({ 'BufWritePre', 'BufEnter' }, {
			group = group,
			pattern = '*.fish',
			callback = function()
				lspconfig.fish_lsp.setup({
					cmd = { 'fish-lsp', 'start' },
					filetypes = { 'fish' },
				})
			end,
		})

		vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
			group = group,
			buffer = vim.api.nvim_get_current_buf(),
			callback = function()
				vim.lsp.buf.document_highlight()
			end,
		})

		vim.api.nvim_create_autocmd('CursorMoved', {
			group = group,
			buffer = vim.api.nvim_get_current_buf(),
			callback = function()
				vim.lsp.buf.clear_references()
			end,
		})
	end,
}
