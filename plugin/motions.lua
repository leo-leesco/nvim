vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		local escaped_commentstring = vim.fn.escape(vim.bo.commentstring:gsub("%%s", ""):gsub("%s+$", ""), "\\\\/*^$.~[]")

		vim.keymap.set({ "n", "v" }, "}", function()
			vim.cmd.normal { bang = true, "0" }
			vim.fn.search("\\v^(" .. escaped_commentstring .. ")?[^" .. escaped_commentstring:sub(1, 1) .. "]", "cW")
			vim.fn.search("\\v(^(" .. escaped_commentstring .. ")?$|%$)", "W")
		end
		)

		vim.keymap.set({ "n", "v" }, "{", function()
			vim.cmd.normal { bang = true, "0" }
			vim.fn.search("\\v^(" .. escaped_commentstring .. ")?[^" .. escaped_commentstring:sub(1, 1) .. "]", "bcW")
			vim.fn.search("\\v(^(" .. escaped_commentstring .. ")?$|%$)", "bW")
		end
		)
	end
})
