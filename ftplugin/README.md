# `ftplugin`s

`ftplugin/<filetype>.[vim|lua]` is loaded on [filetype detection](../README.md#ftdetect), given that `filetype=<filetype>`.

These files are reserved for per-filetype buffer settings that are **not** LSP-related (e.g. `makeprg`, `formatprg`, `suffixesadd`).

## LSP

LSP activation is no longer handled here. Every config in [`lsp/`](../lsp/README.md) is picked up automatically by `init.lua` and enabled via `vim.lsp.enable`, which installs a `FileType` autocmd that starts/attaches the client on matching buffers.

To add a new language server, drop a new file under `lsp/<name>.lua` — no ftplugin wiring needed.
