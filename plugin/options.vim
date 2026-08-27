set number
set relativenumber
set cursorline

set showmatch " shows corresponding bracket
set matchtime=3

set termguicolors

set mouse=a

set ignorecase
set smartcase

set list
set listchars=tab:→\ ,trail:∙,nbsp:⋅

set completeopt=fuzzy,menu,popup,noselect

set wrap
set linebreak
set breakindent
set scrolloff=5

set splitbelow

set gdefault ":s replaces all occurences on whole lines, use :s//g to turn off

" restore cursor to last position when the file was closed
augroup RestoreCursor
	autocmd!
	autocmd BufReadPre * autocmd FileType <buffer> ++once
				\ let s:line = line("'\"")
				\ | if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit'
				\      && index(['xxd', 'gitrebase'], &filetype) == -1
				\      && !&diff
				\ |   execute "normal! g`\""
				\ | endif
augroup END

" vim: ft=vim.concealescape
