" make increment/decrement more intuitive on a list: renumber the selected
" lines as one sequence starting from the first number ± [count], stepping
" in the same direction — <C-a>: 1 1 1 -> 2 3 4, 1 2 3 -> 2 3 4;
" <C-x>: 5 5 5 -> 4 3 2. plain per-line behaviour is moved to g<C-A/X>
function! s:Renumber(delta) abort
	let l:pat = '-\?\d\+'
	let l:step = a:delta < 0 ? -1 : 1
	let l:found = 0
	let l:next = 0
	for l:lnum in range(line("'<"), line("'>"))
		let l:line = getline(l:lnum)
		if l:line !~# l:pat
			continue
		endif
		if !l:found
			let l:next = str2nr(matchstr(l:line, l:pat)) + a:delta
			let l:found = 1
		endif
		call setline(l:lnum, substitute(l:line, l:pat, l:next, ''))
		let l:next += l:step
	endfor
endfunction

vnoremap <silent> <C-a> :<C-u>call <SID>Renumber(v:count1)<CR>
vnoremap <silent> <C-x> :<C-u>call <SID>Renumber(-v:count1)<CR>
vnoremap g<C-a> <C-a>
vnoremap g<C-x> <C-x>
