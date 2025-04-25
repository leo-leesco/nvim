function install(package_manager, package, flags)
	local sh_cmd = "silent !" .. package_manager .. " install " .. " " .. (flags or "") .. " " .. package
	print(sh_cmd .. " > /dev/null &")
	vim.cmd(sh_cmd .. " > /dev/null &")
end

lsp_clients = {
	lua_ls = { deps = { "lua-language-server" }, package_manager = "brew" },
	marksman = { deps = { "marksman" }, package_manager = "brew" },
	rust_analyzer = { deps = { "rust-analyzer" }, package_manager = "brew" },
	ocamllsp = { deps = { "ocaml-lsp-server" }, package_manager = "opam" },
	coq_lsp = { deps = { "coq-lsp" }, package_manager = "opam" },
	astro =
	{
		deps = { "typescript-language-server", "typescript", "prettier", "prettier-plugin-astro", "@astrojs/language-server", "@astrojs/ts-plugin", },
		package_manager = "bun",
		flags = "-g"
	},
	-- agda-ls is not yet compatible with Adga 2.7
	-- adga_ls = { deps = { "agda-language-server" }, package_manager = "stack", flags = "--allow-newer" }
}

vim.api.nvim_create_user_command('LspInstallAll', function()
	for _, lsp in pairs(lsp_clients) do
		for _, package in ipairs(lsp.deps) do
			install(lsp.package_manager, package, lsp.flags)
		end
	end
end, {})

vim.api.nvim_create_user_command('LspInstall', function(args)
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

for k in pairs(lsp_clients) do
	vim.lsp.enable(k)
end
