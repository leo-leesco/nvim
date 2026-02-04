if winwidth(0) < &textwidth * (winnr('$') + 1)
	wincmd L
else
	wincmd J
endif

setlocal nowrapscan
