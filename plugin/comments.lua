vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		local escaped_comment_string = vim.fn.escape(vim.bo.commentstring:gsub("%%s", ""):gsub("%s+$", ""), "\\\\/*^$.~[]")

		vim.keymap.set({ "n", "v" }, "}", function()
			vim.cmd.normal { bang = true, "0" }
			vim.fn.search("\\v^(" .. escaped_comment_string .. ")?[^" .. escaped_comment_string:sub(1, 1) .. "]", "cW")
			vim.fn.search("\\v(^(" .. escaped_comment_string .. ")?$|%$)", "W")
		end
		)

		vim.keymap.set({ "n", "v" }, "{", function()
			vim.cmd.normal { bang = true, "0" }
			vim.fn.search("\\v^(" .. escaped_comment_string .. ")?[^" .. escaped_comment_string:sub(1, 1) .. "]", "bcW")
			vim.fn.search("\\v(^(" .. escaped_comment_string .. ")?$|%$)", "bW")
		end
		)
	end
})
