--
-- folding
--

local M = {}

function Custom_foldtext()
	local fs = vim.v.foldstart

	while vim.fn.getline(fs):match("^%s*$") do
		fs = vim.fn.nextnonblank(fs + 1)
	end

	local line
	if fs > vim.v.foldend then
		line = vim.fn.getline(vim.v.foldstart)
	else
		line = vim.fn.getline(fs):gsub("\t", string.rep(" ", vim.o.tabstop))
	end

	local foldSize = 1 + vim.v.foldend - vim.v.foldstart
	local foldSizeStr = " " .. foldSize .. " lines "
	local expansionString = string.rep(" ", vim.api.nvim_win_get_width(0) - #line - #foldSizeStr - 4)
	return line .. expansionString .. foldSizeStr
end

function M.init()
	vim.opt.foldmethod = "expr"
	vim.opt.foldenable = false
	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.opt.foldlevel = 99
	vim.opt.foldtext = "v:lua.Custom_foldtext()"
end

return M
