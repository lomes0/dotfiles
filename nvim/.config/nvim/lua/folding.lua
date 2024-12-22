--
-- folding
--
local ts = vim.treesitter

local spaces_for_tabs = string.rep(" ", vim.o.tabstop)

local M = {}

-- local function prev_named_sibling(node)
-- 	while node:prev_named_sibling() ~= nil do
-- 		node = node:prev_named_sibling()
-- 	end
-- 	return node
-- end

function T(node)
	return ts.get_node_text(node, 0)
end

local function fold_function_definition(root)
	local query_string = [[
    type: _ @type
	declarator: (function_declarator 
		declarator: (identifier) @name
        parameters: (parameter_list) @params)
]]

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

local function fold_start_raw_string()
	local bufnr = vim.api.nvim_get_current_buf()
	return vim.api.nvim_buf_get_text(bufnr, vim.v.foldstart - 1, 0, vim.v.foldstart, -1, {})[1] or ""
end

local function fold_comment(_)
	local line_str = fold_start_raw_string():match("^%s*")
	return line_str:gsub("\t", spaces_for_tabs) .. "..."
end

local folds = {
	["function_definition"] = fold_function_definition,
	["comment"] = fold_comment,
}

---@param root TSNode
---@param lnum integer
---@param col integer
local function get_last_node_at_line(root)
	local line = vim.v.foldstart
	return root:descendant_for_range(line, 0, line, 1)
end

local function fold_root_node()
	local parsers = require("nvim-treesitter.parsers")
	local parser = parsers.get_parser()
	local tree = parser:parse()[1]
	local root = tree:root()
	local node = get_last_node_at_line(root)

	while node:parent() ~= nil and node:parent():type() ~= root:type() do
		local psr, _ = node:parent():start()

		if (psr + 1) < vim.v.foldstart then
			return node
		end

		node = node:parent()
	end

	return node
end

function DefaultFold()
	local line_str = fold_start_raw_string()
	return line_str:gsub("\t", spaces_for_tabs)
end

function CppFold()
	local function cpp_fold_str()
		local root = fold_root_node()
		local fold_func = DefaultFold

		if root ~= nil then
			fold_func = folds[root:type()] or DefaultFold
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
	vim.opt.foldtext = "v:lua.DefaultFold()"
	vim.opt.fillchars = { fold = " " }

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "c", "cpp" },
		callback = function()
			vim.opt.foldtext = "v:lua.CppFold()"
		end,
	})
end

M.init()
