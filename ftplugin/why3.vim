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

" vim: ft=vim.concealescape
