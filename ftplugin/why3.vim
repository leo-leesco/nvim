setlocal makeprg=why3\ prove\ %
setlocal errorformat=Warning\\,\ file\ \"%f\"\\,\ line\ %l\\,\ characters\ %c-%k:\ %m

au QuickFixCmdPost make call setqflist(filter(getqflist(), 'v:val.valid == 1'),'r') "clean up invalid error lines from the qflist
au QuickFixCmdPost make call s:FixColumnOffset()
function s:FixColumnOffset()
	let l:list = getqflist()
	for l:item in l:list
		let l:item.col += 1
	endfor
	call setqflist(l:list, 'r')
endfunction

" comments
setlocal comments=sr:(**,mb:\ *,ex:\ *),sr:(*\ ,mb:\ ,ex:*)
setlocal commentstring=(*\ %s\ *)

" documentation
function! s:Why3DocFunc(keyword)
	let l:basename = expand('%:t:r')

	let l:out_dir = '/tmp/why3'
	call mkdir(l:out_dir, 'p')

	let l:cmd = 'why3 doc -o ' . l:out_dir . ' ' . shellescape(expand('%'))
	call system(l:cmd)

	let l:target_html = l:out_dir . '/'.l:basename . '.html'

	if has('macunix')
		call system('open ' . shellescape(l:target_html))
	elseif has('unix')
		call system('xdg-open ' . shellescape(l:target_html))
	else
		echo "Don't know how to open browser on this system."
	endif
endfunction

" -nargs=1 allows it to accept the keyword passed by K
command! -nargs=1 Why3Doc call s:Why3DocFunc(<f-args>)

setlocal keywordprg=:Why3Doc
" vim: ft=vim.concealescape
