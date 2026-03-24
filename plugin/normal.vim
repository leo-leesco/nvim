" disable highlight when pressing <Esc>
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

" guardrails again CAPSLOCK
nnoremap U :echohl ErrorMsg <Bar> echo "===== C H E C K   C A P S   L O C K ====="<CR>
command! W write | echohl ErrorMsg | echo " < < ===== C H E C K   C A P S   L O C K ===== > > "

" Open command-line history window with CTRL-W: and disable q:
nnoremap <C-W>: q:
nnoremap q: <Nop>

" Open forward search history window with CTRL-W/ and disable q/
nnoremap <C-W>/ q/
nnoremap q/ <Nop>

" Open backward search history window with CTRL-W? and disable q?
nnoremap <C-W>? q?
nnoremap q? <Nop>
