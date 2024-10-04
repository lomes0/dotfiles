--
-- folding
--
local ts = vim.treesitter

local M = {}

local query_string = [[
    type: _ @type
	declarator: (function_declarator 
		declarator: (identifier) @name
        parameters: (parameter_list) @params)
]]

function T(node)
	return ts.get_node_text(node, 0)
end

local function fold_function_definition(root)
	local query = vim.treesitter.query.parse("c", query_string)

	local line = ""
	for id, capture, _ in query:iter_captures(root, 0, 0, -1) do
		local key = query.captures[id]

		if key == "name" or key == "type" then
			line = line .. T(capture) .. " "
		end

		if key == "params" then
			line = line .. "()"
			break
		end
	end

	return line
end

local folds = {
	["function_definition"] = fold_function_definition,
}

local function prev_named_sibling(node)
	while node:prev_named_sibling() ~= nil do
		node = node:prev_named_sibling()
	end
	return node
end

---@param root TSNode
---@param lnum integer
---@param col integer
local function get_last_node_at_line(root, lnum, col)
	return root:descendant_for_range(lnum - 1, col, lnum - 1, col + 1)
end

local function fold_root_node()
	local parsers = require("nvim-treesitter.parsers")
	local parser = parsers.get_parser()
	local tree = parser:parse()[1]
	local root = tree:root()
	local node = get_last_node_at_line(root, vim.v.foldstart, 0)
	node = prev_named_sibling(node)

	while node:parent() ~= nil and node:parent():type() ~= root:type() do
		local psr, _ = node:parent():start()

		if (psr + 1) < vim.v.foldstart then
			return node
		end

		node = node:parent()
	end

	return node
end

local function default_fold(_)
	local fs = vim.v.foldstart

	while vim.fn.getline(fs):match("^%s*$") do
		fs = vim.fn.nextnonblank(fs + 1)
	end

	if fs > vim.v.foldend then
		return vim.fn.getline(vim.v.foldstart)
	else
		return vim.fn.getline(fs):gsub("\t", string.rep(" ", vim.o.tabstop))
	end
end

function CppFold()
	local function cpp_fold_str()
		local root = fold_root_node()
		local fold_func = default_fold

		if root ~= nil then
			fold_func = folds[root:type()] or default_fold
		end

		return fold_func(root)
	end
	local line = cpp_fold_str()
	local foldSize = 1 + vim.v.foldend - vim.v.foldstart
	local foldSizeStr = " " .. foldSize .. " lines "
	local expansionString = string.rep(" ", vim.api.nvim_win_get_width(0) - #line - #foldSizeStr - 4)
	return line .. expansionString .. foldSizeStr
end

function M.init()
	vim.opt.foldlevel = 99
	vim.opt.foldenable = false
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "c", "cpp" },
		callback = function()
			vim.opt.foldtext = "v:lua.CppFold()"
		end,
	})

	-- vim.api.nvim_create_autocmd("FileType", {
	-- 	pattern = { "markdown", "text" },
	-- 	callback = function()
	-- 		-- Set foldmethod to 'manual' for markdown and text files
	-- 		vim.opt_local.foldmethod = "manual"
	-- 		vim.opt_local.foldlevel = 99 -- Open all folds by default
	-- 	end,
	-- })
end

return M
