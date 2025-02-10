return {
	'ndonfris/fish-lsp',
	config = function()
		-- Start FishLSP on FileType event for fish files
		vim.api.nvim_create_autocmd('FileType', {
			pattern = 'fish',
			callback = function()
				require('lspconfig').fish_lsp.setup({
					cmd = { 'fish-lsp', 'start' },
					filetypes = { 'fish' },
					cmd_env = { fish_lsp_show_client_popups = false },
				})
			end,
		})

		-- Create a group for FishLSP autocommands
		local fish_group = vim.api.nvim_create_augroup('FishLSP', { clear = true })

		-- Document highlighting on CursorHold events
		vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
			group = fish_group,
			pattern = '*.fish',
			callback = function()
				vim.lsp.buf.document_highlight()
			end,
		})

		-- Clear references on CursorMoved for fish files
		vim.api.nvim_create_autocmd('CursorMoved', {
			group = fish_group,
			pattern = '*.fish',
			callback = function()
				vim.lsp.buf.clear_references()
			end,
		})
	end,
}
