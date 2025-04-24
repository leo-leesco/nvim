# `nvim` configuration

The need for fine-grained configuration for `nvim` has led me to restart from scratch so as to not have any parasitic keybindings and solely what I need to work.

I use [`Lazy`](https://github.com/folke/lazy.nvim) as package manager and [`lsp-config`](https://github.com/neovim/nvim-lspconfig) to configure lsp servers, without relying on [`Mason`](https://github.com/williamboman/mason.nvim) which I sadly cannot get to work reliably on niche programming languages that are part of my everyday life (`OCaml` notably, and the whole integration with `opam` which seems to be faulty for some reason).

_I might move back to `Mason` if I understand how to properly write configuration for its registry._
