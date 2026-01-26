if winwidth(0) < &textwidth * (winnr('$') + 1)
	wincmd L
else
	wincmd J
endif

set nowrapscan

" make }{ work even on commented paragraphs
map g} <Cmd>normal! 0<Bar>call search('\v^"?[^"]', 'cW')<Bar>call search('\v(^"?$\|%$)', 'W')<CR>
map g{ <Cmd>normal! 0<Bar>call search('\v^"?[^"]', 'bcW')<Bar>call search('\v(^"?$\|%^)', 'bW')<CR>
