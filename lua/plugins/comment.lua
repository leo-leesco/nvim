return {
	{
		-- keeps builtin gc/gcc behaviour, adds gb/gbc to wrap the target in a
		-- single block comment (/* ... */, <!-- ... -->, --[[ ... ]], ...)
		"numToStr/Comment.nvim",
		opts = {
			-- on nvim 0.11+ vim.treesitter.get_parser() returns nil instead of
			-- erroring when the buffer has no parser; Comment.nvim's treesitter
			-- lookup (ft.calculate) indexes that nil and dies before ever
			-- falling back to the buffer's 'commentstring' (e.g. tex, where
			-- vimtex sets it). Short-circuit the lookup when there is no parser.
			pre_hook = function(ctx)
				local ok, parser = pcall(vim.treesitter.get_parser, 0)
				if ok and parser then
					return -- parser available: normal treesitter lookup
				end
				local cstr = require("Comment.ft").get(vim.bo.filetype, ctx.ctype)
				assert(cstr or ctx.ctype ~= require("Comment.utils").ctype.blockwise,
					{ msg = vim.bo.filetype .. " doesn't support block comments!" })
				return cstr or vim.bo.commentstring
			end,
		},
	},
}
