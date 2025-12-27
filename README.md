# `neovim` config

I restarted (yet again) my config in order to leverage as much as possible the built-in features of `vim` as I feel that those features are both more idiomatic (in a `vim` way) and extremely powerful. Here is a list of features that I want to leverage rather than rely on plugins :
- LSP (`neovim` feature)
- syntax highlighting through `treesitter` (`neovim` feature)
- `make`
- tags and marks
- folds

Other features can be supplied through plugins, but I really strive to first make use of the built-in functionnalities in order to have a streamlined workflow across languages.

The features loaded by `vim` are loaded by default from those folders :
	  filetype.lua	filetypes
	  autoload/	automatically loaded scripts
	  colors/	color scheme files
	  compiler/	compiler files
	  doc/		documentation
	  ftplugin/	filetype plugins
	  indent/	indent scripts
	  keymap/	key mapping files
	  lang/		menu translations
	  lsp/		LSP client configurations
	  lua/		|Lua| plugins
	  menu.vim	GUI menus
	  pack/		packages
	  parser/	|treesitter| syntax parsers
	  plugin/	plugin scripts
	  queries/	|treesitter| queries
	  rplugin/	|remote-plugin| scripts
	  spell/	spell checking files
	  syntax/	syntax files
	  tutor/	tutorial files


## LSP

I will be using `nvim-lspconfig` to configure various `lsp`s. The config files will be stored in `lsp/`
