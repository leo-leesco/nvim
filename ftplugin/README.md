# `ftplugin`s

`ftplugin/<filetype>.[vim|lua]` is loaded on [filetype detection](../README.md#ftdetect), given that `filetype=<filetype>`.

My `ftplugin`s enable the following features :
- [`LSP`](#lsp)

## LSP

LSP activation is done in `ftplugin`s because `LSP`s are not available for every fietype, and should only be loaded when applicable. Generically, `LSP` activation has the following shape :
```lua
vim.lsp.enable(<filetype>)
vim.lsp.start(vim.lsp.config.<filetype>)
```

Note : `vim.lsp.config` is the table that contains the enabled configs
