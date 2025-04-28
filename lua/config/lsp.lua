function install(package_manager, package, flags)
	local sh_cmd = "!" .. package_manager .. " install " .. " " .. (flags or "") .. " " .. package
	vim.cmd(sh_cmd)
end

lsp_clients = {
	lua_ls = { deps = { "lua-language-server" }, package_manager = "brew" },
	marksman = { deps = { "marksman" }, package_manager = "brew" },
	rust_analyzer = { deps = { "rust-analyzer" }, package_manager = "brew" },
	ocamllsp = { deps = { "ocaml-lsp-server" }, package_manager = "opam", flags = "--yes" },
	coq_lsp = { deps = { "coq-lsp" }, package_manager = "opam", flags = "--yes" },
	astro = {
		deps = {
			"typescript-language-server",
			"typescript",
			"prettier",
			"prettier-plugin-astro",
			"@astrojs/language-server",
			"@astrojs/ts-plugin",
		},
		package_manager = "bun",
		flags = "-g",
	},
	-- agda-ls is not yet compatible with Adga 2.7
	-- adga_ls = { deps = { "agda-language-server" }, package_manager = "stack", flags = "--allow-newer" }
	clangd = { deps = { "llvm" }, package_manager = "brew" },
}

for k in pairs(lsp_clients) do
	vim.lsp.enable(k)
end

-- LANGUAGE SPECIFIC
-- OCaml
vim.opt.rtp:prepend("~/.opam/default/share/ocp-indent/vim")

-- CUSTOM COMMANDS
vim.api.nvim_create_user_command("LspInstallAll", function()
	for _, lsp in pairs(lsp_clients) do
		for _, package in ipairs(lsp.deps) do
			install(lsp.package_manager, package, lsp.flags)
		end
	end
end, {})

vim.api.nvim_create_user_command("LspInstall", function(args)
	local lsp = lsp_clients[args.args]
	if lsp ~= nil then
		for _, package in ipairs(lsp.deps) do
			install(lsp.package_manager, package, lsp.flags)
		end
	else
		print("available lsp_clients :")
		for ls, _ in pairs(lsp_clients) do
			print(ls)
		end
	end
end, { nargs = 1 })

-- CUSTOM KEYBINDINGS
vim.keymap.set("n", "gk", function()
	vim.diagnostic.open_float()
end, { noremap = true })
-- toggle phantom diagnostics
vim.keymap.set("n", "<leader>k", function()
	if vim.diagnostic.is_enabled() then
		vim.diagnostic.hide()
	else
		vim.diagnostic.show()
	end
end)
