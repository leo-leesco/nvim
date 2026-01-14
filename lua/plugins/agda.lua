return {
	'isovector/cornelis',
	name = 'cornelis',
	ft = 'agda',
	build = 'stack install',
	dependencies = {
		'neovimhaskell/nvim-hs.vim',
		'kana/vim-textobj-user',
		{
			'junegunn/vim-easy-align',
			config = function()
				vim.cmd [[
				vmap <leader> <Plug>(EasyAlign)

				let g:easy_align_delimiters = {
					\ '=': { 'pattern': '[≤≡≈∎]', 'left_margin': 2, 'right_margin': 0 },
					\ }
				]]
			end
		}
	},
	version = '*',

	config = function()
		vim.cmd [[
		au QuitPre *.agda :CornelisCloseInfoWindows
		au BufWritePost *.agda :CornelisLoad
		au BufReadPost *.agda,*.lagda* :CornelisLoad

		let g:cornelis_split_location = 'bottom'
		]]

		vim.o.expandtab = true
		vim.o.tabstop = 1
		vim.o.softtabstop = 1
		vim.o.shiftwidth = 1
	end,
	keys = {
		{ "<leader>r",        ":CornelisRefine<CR>",           ft = "agda" },
		{ "<leader>c",        ":CornelisMakeCase<CR>",         ft = "agda" },
		{ "<leader>a",        ":CornelisAuto<CR>",             ft = "agda" },
		{ "<leader>,",        ":CornelisTypeContext<CR>",      ft = "agda" },
		{ "<leader>d",        ":CornelisTypeInfer<CR>",        ft = "agda" },
		{ "<leader>;",        ":CornelisTypeContextInfer<CR>", ft = "agda" },
		{ "<leader>s",        ":CornelisSolve<CR>",            ft = "agda" },
		{ "<leader>e",        ":CornelisElaborate<CR>",        ft = "agda" },
		{ "gd",               ":CornelisGoToDefinition<CR>",   ft = "agda" },
		{ "[d",               ":CornelisPrevGoal<CR>",         ft = "agda" },
		{ "]d",               ":CornelisNextGoal<CR>",         ft = "agda" },
		{ "<C-A>",            ":CornelisInc<CR>",              ft = "agda" },
		{ "<C-X>",            ":CornelisDec<CR>",              ft = "agda" },
		{ "<leader><leader>", ":CornelisQuestionToMeta<CR>",   ft = "agda" },
	}
}
