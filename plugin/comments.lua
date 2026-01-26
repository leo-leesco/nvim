local escaped_comment_string = vim.fn.escape(
	vim.bo.commentstring:gsub("%%s", ""):gsub("%s+$", ""),
	"\\\\/*^$.~[]"
)

vim.keymap.set({ "n", "v" }, "}", function()
	vim.cmd.normal { bang = true, "0" }
	vim.fn.search('\\v^(' .. escaped_comment_string .. ')@!', "cW")
	vim.fn.search('\\v(^' .. escaped_comment_string .. '$|%$)', "W")
end
)

vim.keymap.set({ "n", "v" }, "{", function()
	vim.cmd.normal { bang = true, "0" }
	vim.fn.search("\\v^\"?[^\"]", "bcW")
	vim.fn.search("\\v(^\"?$|%^)", "bW")
end
)
