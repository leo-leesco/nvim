--#region `makeprg` options
local dune_markers = { "dune-project", "dune" }

local found = vim.fs.find(dune_markers, {
	upward = true,
	-- stop = vim.env.HOME, -- Stop searching at home to avoid slow disks
	path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	limit = 1, -- We only need to know if ONE exists
})

if #found > 0 then
	vim.bo.makeprg = "dune $*"
else
	vim.bo.makeprg = "ocamlopt % -o %:r"
end
--#endregion

vim.opt_local.suffixesadd:append { ".ml" }
