return {
	'isovector/cornelis',
	ft = { 'agda' },
	build = 'stack build',
	dependencies = {
		'kana/vim-textobj-user',
		'neovimhaskell/nvim-hs.vim',
	},
	init = function()
		vim.g.cornelis_agda_prefix = '\\'
		vim.cmd [[
au BufRead,BufNewFile *.agda call AgdaFiletype()
au QuitPre *.agda :CornelisCloseInfoWindows

function! AgdaFiletype()
    nnoremap <buffer> <leader>l    :CornelisLoad<CR> :CornelisQuestionToMeta<CR>
    nnoremap <buffer> <leader>q    :CornelisQuestionToMeta<CR>
    nnoremap <buffer> <leader>r    :CornelisRefine<CR>
    nnoremap <buffer> <leader>d    :CornelisMakeCase<CR>
    nnoremap <buffer> <leader>p    :CornelisPrevGoal<CR>
    nnoremap <buffer> <leader>n    :CornelisNextGoal<CR>
    nnoremap <buffer> <leader>,    :CornelisTypeContextInfer<CR>
    nnoremap <buffer> gd           :CornelisGoToDefinition<CR>
    nnoremap <buffer> <leader><CR> :CornelisNormalize<CR>
    nnoremap <buffer> <leader>a    :CornelisAuto<CR>
    nnoremap <buffer> <C-C>        :CornelisAbort<CR> :CornelisRestart<CR>
endfunction

au BufWritePost *.agda execute "normal! :CornelisLoad\<CR>"
      function! CornelisLoadWrapper()
  if exists(":CornelisLoad") ==# 2
    CornelisLoad
  endif
endfunction

au BufReadPre *.agda call CornelisLoadWrapper()
au BufReadPre *.lagda* call CornelisLoadWrapper()
]]

		vim.g.cornelis_split_location = 'bottom'
		-- require 'config.cornelis' -- this could be re-enabled when I'll have understood how relative imports work
	end,
}
