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
		]]
		vim.o.expandtab = true
		vim.o.tabstop = 2
		vim.o.softtabstop = 2
		vim.o.shiftwidth = 2
	end,
	keys = {
		{ "<leader>l", ":CornelisLoad<CR>" },
		{ "<leader>r", ":CornelisRefine<CR>" },
		{ "<leader>d", ":CornelisMakeCase<CR>" },
		{ "<leader>,", ":CornelisTypeContext<CR>" },
		{ "<leader>.", ":CornelisTypeContextInfer<CR>" },
		{ "<leader>n", ":CornelisSolve<CR>" },
		{ "<leader>a", ":CornelisAuto<CR>" },
		{ "gd",        ":CornelisGoToDefinition<CR>" },
		{ "[<leader>", ":CornelisPrevGoal<CR>" },
		{ "]<leader>", ":CornelisNextGoal<CR>" },
		{ "<C-A>",     ":CornelisInc<CR>" },
		{ "<C-X>",     ":CornelisDec<CR>" },
		{ "<leader>?", ":CornelisQuestionToMeta<CR>" },
	}
}
