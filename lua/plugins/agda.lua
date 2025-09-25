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
				vmap <leader><space> <Plug>(EasyAlign)

			let g:easy_align_delimiters = {
				\ 'r': { 'pattern': '[≤≡≈∎]', 'left_margin': 2, 'right_margin': 0 },
				\ }
				]]
			end
		}
	},
	version = '*',
	config = function()
		vim.cmd [[
		function! AgdaFiletype()
			nnoremap <buffer> <leader>l :CornelisLoad<CR>
			nnoremap <buffer> <leader>r :CornelisRefine<CR>
			nnoremap <buffer> <leader>d :CornelisMakeCase<CR>
			nnoremap <buffer> <leader>, :CornelisTypeContext<CR>
			nnoremap <buffer> <leader>. :CornelisTypeContextInfer<CR>
			nnoremap <buffer> <leader>n :CornelisSolve<CR>
			nnoremap <buffer> <leader>a :CornelisAuto<CR>
			nnoremap <buffer> gd        :CornelisGoToDefinition<CR>
			nnoremap <buffer> [/        :CornelisPrevGoal<CR>
			nnoremap <buffer> ]/        :CornelisNextGoal<CR>
			nnoremap <buffer> <C-A>     :CornelisInc<CR>
			nnoremap <buffer> <C-X>     :CornelisDec<CR>
		endfunction

		au BufRead,BufNewFile *.agda call AgdaFiletype()
		au QuitPre *.agda :CornelisCloseInfoWindows
		au BufWritePost *.agda execute "normal! :CornelisLoad\<CR>"

		function! CornelisLoadWrapper()
		  if exists(":CornelisLoad") ==# 2
			CornelisLoad
		  endif
		endfunction

		au BufReadPre *.agda call CornelisLoadWrapper()
		au BufReadPre *.lagda* call CornelisLoadWrapper()
		]]
	end,
	keys = {
		{ "<leader>l", "CornelisLoad<CR>" },
		{ "<leader>r", "CornelisRefine<CR>" },
		{ "<leader>d", "CornelisMakeCase<CR>" },
		{ "<leader>,", "CornelisTypeContext<CR>" },
		{ "<leader>.", "CornelisTypeContextInfer<CR>" },
		{ "<leader>n", "CornelisSolve<CR>" },
		{ "<leader>a", "CornelisAuto<CR>" },
		{ "gd",        "CornelisGoToDefinition<CR>" },
		{ "<leader>[", "CornelisPrevGoal<CR>" },
		{ "<leader>]", "CornelisNextGoal<CR>" },
		{ "<C-A>",     "CornelisInc<CR>" },
		{ "<C-X>",     "CornelisDec<CR>" },
	}
}
