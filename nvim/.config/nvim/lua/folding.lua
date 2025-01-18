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

local function get_last_node_at_line(root, line)
	return root:descendant_for_range(line, 0, line, 1)
end

function FoldtextCoding()
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
	local start_node = get_last_node_at_line(tree:root(), vim.v.foldstart)

	if start_node:type() == "comment" then
		local first_line = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, false)[1]
		return { { first_line, "" } }
	end

	for id, node, _ in query:iter_captures(tree:root(), 0, foldstart - 1, -1) do
		local text = T(node)
		local name = query.captures[id]
		local start_row, start_col, end_row, end_col = node:range()

		-- stop on start of body statements
		if node:type() == "{" then
			break
		end

		if start_row + 1 >= vim.v.foldend then
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

function FoldtextDefault()
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
	vim.opt.foldtext = [[luaeval('FoldtextDefault')()]]

	vim.opt.fillchars:append({ fold = " " })

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "c", "cpp", "rust" },
		callback = function()
			vim.opt.foldtext = [[luaeval('FoldtextCoding')()]]
		end,
	})
end

M.init()
