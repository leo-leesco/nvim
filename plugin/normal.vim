" disable highlight when pressing <Esc>
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

" guardrails again CAPSLOCK
nnoremap U :echohl ErrorMsg <Bar> echo "===== C H E C K   C A P S   L O C K ====="<CR>
command! W write | echohl ErrorMsg | echo " < < ===== C H E C K   C A P S   L O C K ===== > > "
