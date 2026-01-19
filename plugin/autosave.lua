local format_sync_grp = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_sync_grp,
	pattern = "*",
	callback = function(args)
		if not vim.bo[args.buf].modifiable or vim.bo[args.buf].readonly then
			return
		end

		local clients = vim.lsp.get_clients({ bufnr = args.buf })

		for _, client in ipairs(clients) do
			if client:supports_method("textDocument/formatting") then
				vim.lsp.buf.format({
					bufnr = args.buf,
					id = client.id,
					async = false,
				})
				return
			end
		end

		-- fallback
		if vim.bo[args.buf].formatprg ~= "" then
			local view = vim.fn.winsaveview()
			vim.cmd("normal! gggqG")
			vim.fn.winrestview(view) -- restore cursor position
		end
	end,
})

vim.opt.formatoptions = "jcqrn"
