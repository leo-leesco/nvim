vim.cmd([[
"" digraphs
digraph! bN 8469
digraph! bZ 8484
digraph! bQ 8474
digraph! bR 8477
digraph! bC 8450
digraph! bP 8473

"" easier navigation between vim panes
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

"" move panes
nmap <C-W>h <C-W>H
nmap <C-W>j <C-W>J
nmap <C-W>k <C-W>K
nmap <C-W>l <C-W>L

"" copy paste from system clipboard
nmap <leader>y "+y
nmap <leader>p "+p
vmap <leader>y "+y
vmap <leader>p "+p

"" disable highlight when pressing <Esc>
nnoremap <silent> <Esc> :noh<CR><Esc>

"" terminal mode commands
tnoremap <Esc><Esc> <C-\><C-n>

"" guardrails again CAPSLOCK
nnoremap U :echo " < < ===== C H E C K   C A P S   L O C K ===== > > "<CR>
]])

vim.api.nvim_create_user_command("W", function()
	vim.cmd("write")
	vim.notify("<< ===== C H E C K   C A P S   L O C K ===== >>", vim.log.levels.WARN)
end, {})
