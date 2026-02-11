if winwidth(0) < &textwidth * (winnr('$') + 1)
	wincmd L
else
	wincmd J
endif

augroup HelpWrapScan
  autocmd! * <buffer>
  autocmd BufEnter,WinEnter <buffer> set nowrapscan

  autocmd BufLeave,WinLeave <buffer> set wrapscan
augroup END
