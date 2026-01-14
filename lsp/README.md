# `LSP` configuration

Each file of `lsp/` is a [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig)-type configuration file.

In this regard, they return a configuration table at the top-level :
- `cmd` is a table in the style of `vim.system` (all strings are concatenated into a single CLI prompt)
- `filetypes` enables the `LSP` on `filetype` in `filetypes` (note that the `ftplugin` [`lsp` configuration](../ftplugin/README.md) should be redundant thanks to that, but for some reason it is still necessary…)
- [`root_markers` or `root_dir`](#root-detection) launches the `LSP` in the appropriate location to take into account the entire codebase
- [`settings`](#settings) is the `JSON`-like configuration scheme of the `LSP`
- in some cases, `init_options`, `before_init` and the like are required for setting up the `LSP` : refer to the [general settings configuration](#settings) in this case

## Settings

Given that the config key is of the form `<category>.<option>`, there are two main ways to toggle options for the `LSP` :

```lua
settings = {
    <category> = {
        <option> = { … }
    }
}
```

```lua
settings = {
    ['<category>.<option>'] = { … }
}
```

## Root detection

When using `root_markers`, specify exactly the files or folders to look for, **wildcards are not allowed**.

Otherwise use `root_dir` and a appropriate function that returns the path to `root_dir`.

