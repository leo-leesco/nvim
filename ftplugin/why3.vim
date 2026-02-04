" makeprg + errorformat
setlocal makeprg=why3\ prove\ -L\ .\ %
setlocal errorformat=Warning\\,\ file\ \"%f\"\\,\ line\ %l\\,\ characters\ %c-%k:\ %m
setlocal errorformat+=File\ \"%f\"\\,\ line\ %l\\,\ characters\ %c-%k:\ %m
setlocal errorformat+=%EFile\ \"%f\"\\,\ line\ %l\\,\ characters\ %c-%k:
setlocal errorformat+=%Z%m

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
function! s:Why3DocFunc(_keyword)
	let l:raw_word = expand('<cWORD>')
	let l:clean_word = substitute(l:raw_word, "^['(\[\{]*\\|['(\[\{,.)]*$", "", "g")
	let l:root_module = split(l:clean_word, '\.')[0]
	let l:target = shellescape('https://www.why3.org/stdlib/'. l:root_module .'.html')
	echo l:target

	if has('macunix')
		call system('open ' . l:target)
	elseif has('unix')
		call system('xdg-open ' . l:target)
	else
		echo "Don't know how to open browser on this system."
	endif
endfunction

" -nargs=1 allows it to accept the keyword passed by K
command! -nargs=1 Why3Doc call s:Why3DocFunc(<f-args>)

setlocal keywordprg=:Why3Doc
" vim: ft=vim.concealescape
