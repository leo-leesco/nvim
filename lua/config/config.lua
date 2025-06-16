-- vim.o.<option> = <value> is exactly like :set <option>=<value>
-- vim.opt.<option> = {<value1>,<value3>,…} is exactly like :set <option> = <value1>,<value2>,…
--
-- using the second form is more convenient because it allows to mimic :set+= :set^= and :set-= with
-- vim.opt.<option>:append vim.opt.<option>:prepend and vim.opt.<option>:remove
--
-- note that vim.opt comes in two flavours : vim.opt_local and vim.opt_global

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- modeline : starts with vim: and a series of options to be set
-- vim: tabstop=2 softtabstop=2 shiftwidth=2 expandtab
