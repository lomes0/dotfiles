--
-- folding
--
local ts = vim.treesitter

local spaces_for_tabs = string.rep(" ", vim.o.tabstop)

local M = {}

function T(node)
	return ts.get_node_text(node, 0)
end

local function fold_start_raw_string()
	local bufnr = vim.api.nvim_get_current_buf()
	return vim.api.nvim_buf_get_text(bufnr, vim.v.foldstart - 1, 0, vim.v.foldstart, -1, {})[1] or ""
end

local function fold_start_prefix()
	local line_raw = fold_start_raw_string()
	local line_prefix = line_raw:match("^%s*")
	return line_prefix:gsub("\t", spaces_for_tabs)
end

-- local function fold_function_definition(root)
-- 	local query_string = [[
--     type: _ @type
-- 	(function_definition
-- 		declarator: (function_declarator
-- 			declarator: (identifier) @name
--     	    parameters: (parameter_list) @params))
-- ]]
--
-- 	local query = ts.query.parse("c", query_string)
--
-- 	local line = ""
-- 	for id, capture, _ in query:iter_captures(root, 0, 0, -1) do
-- 		local key = query.captures[id]
--
-- 		if key == "name" or key == "type" then
-- 			line = line .. T(capture) .. " "
-- 		end
--
-- 		if key == "params" then
-- 			line = line .. "()"
-- 			break
-- 		end
-- 	end
--
-- 	return line
-- end

-- local function fold_for_statement(root)
-- 	local query_string = [[
--     type: _ @type
-- 	(for_statement
-- 		condition: (binary_expression)@cond)
-- ]]
-- 	local query = ts.query.parse("c", query_string)
--
-- 	local line = "for ("
-- 	for id, capture, _ in query:iter_captures(root, 0, 0, -1) do
-- 		local key = query.captures[id]
--
-- 		if key == "cond" then
-- 			line = line .. T(capture)
-- 		end
-- 	end
--
-- 	return line .. ")"
-- end

-- local function fold_comment(_)
-- 	return "..."
-- end

-- local folds = {
-- 	["function_definition"] = nil,
-- 	["for_statement"] = nil,
-- 	["comment"] = nil,
-- }

-- local function get_last_node_at_line(root)
-- 	local line = vim.v.foldstart
-- 	return root:descendant_for_range(line, 0, line, 1)
-- end
--
-- local function fold_root_node()
-- 	local parsers = require("nvim-treesitter.parsers")
-- 	local parser = parsers.get_parser()
-- 	local tree = parser:parse()[1]
-- 	local root = tree:root()
-- 	local node = get_last_node_at_line(root)
--
-- 	while node:parent() ~= nil and node:parent():type() ~= root:type() do
-- 		local psr, _ = node:parent():start()
--
-- 		if (psr + 1) < vim.v.foldstart then
-- 			return node
-- 		end
--
-- 		node = node:parent()
-- 	end
--
-- 	return node
-- end

-- local function DefaultFold()
-- 	return fold_start_raw_string():gsub("^%s+", "")
-- end

-- local function calc_foldend(root)
-- 	local node = get_last_node_at_line(root)
-- 	local parent = node:parent()
-- 	return vim.v.foldstart + 1
-- 	if parent:type() == "function_declarator" then
--
-- 	end
-- 	if node:parent():type())
-- end

function CppFold()
	local lang = ts.language.get_lang(vim.bo.filetype)
	local parser = ts.get_parser(0, lang)
	local query = ts.query.get(parser:lang(), "highlights")
	if query == nil then
		return vim.fn.foldtext()
	end

	local result = {}
	local prefix = fold_start_prefix()
	table.insert(result, { prefix, "Folded" })

	local processed_nodes = {}
	local prev_col = #prefix
	local prev_row = vim.v.foldstart
	local foldstart = vim.v.foldstart

	local tree = parser:parse({ foldstart - 1, foldstart })[1]
	for id, node, _ in query:iter_captures(tree:root(), 0, foldstart - 1, -1) do
		local text = T(node)
		local name = query.captures[id]
		local start_row, start_col, end_row, end_col = node:range()

		-- stop on start of body statements
		if node:type() == "{" then
			break
		end

		-- pointers are recursive nodes, skip pointer subtree root
		if node:type() == "pointer_declarator" then
			goto continue
		end

		if start_col > prev_col then
			table.insert(result, { " ", "Folded" })
		end
		prev_col = end_col

		if start_row > prev_row then
			table.insert(result, { " ", "Folded" })
		end
		prev_row = end_row

		if processed_nodes[node:id()] then
			result[#result] = { text, "@" .. name }
		else
			table.insert(result, { text, "@" .. name })
			processed_nodes[node:id()] = true
		end

		::continue::
	end

	return result
end

function HighlightedFoldtext()
	local pos = vim.v.foldstart
	local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]
	local lang = ts.language.get_lang(vim.bo.filetype)
	local parser = ts.get_parser(0, lang)
	local query = ts.query.get(parser:lang(), "highlights")

	if query == nil then
		return vim.fn.foldtext()
	end

	local tree = parser:parse({ pos - 1, pos })[1]
	local result = {}

	local line_pos = 0

	local prev_range = nil

	for id, node, _ in query:iter_captures(tree:root(), 0, pos - 1, pos) do
		local name = query.captures[id]
		local start_row, start_col, end_row, end_col = node:range()
		if start_row == pos - 1 and end_row == pos - 1 then
			local range = { start_col, end_col }
			if start_col > line_pos then
				table.insert(result, { line:sub(line_pos + 1, start_col), "Folded" })
			end
			line_pos = end_col
			local text = T(node)
			if prev_range ~= nil and range[1] == prev_range[1] and range[2] == prev_range[2] then
				result[#result] = { text, "@" .. name }
			else
				table.insert(result, { text, "@" .. name })
			end
			prev_range = range
		end
	end

	return result
end

function M.init()
	vim.opt.foldlevel = 99
	vim.opt.foldenable = false
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.opt.foldtext = [[luaeval('HighlightedFoldtext')()]]

	vim.opt.fillchars:append({ fold = " " })

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "c", "cpp", "rust" },
		callback = function()
			vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
			vim.opt.foldtext = [[luaeval('CppFold')()]]
		end,
	})
end

M.init()
