--
-- folding
--
local ts = vim.treesitter

local spaces_for_tabs = string.rep(" ", vim.o.tabstop)

-- Performance cache for expensive computations
local folding_cache = {
	parsers = {}, -- Cache parsers
	queries = {}, -- Cache queries
	fold_text = {}, -- Cache fold text results
	highlight_groups = {}, -- Cache highlight groups
}

-- Cache cleanup on buffer changes
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
	callback = function(event)
		local bufnr = event.buf
		-- Clean up buffer-specific cache
		folding_cache.parsers[bufnr] = nil
		folding_cache.fold_text[bufnr] = nil
	end,
})

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
	local bufnr = vim.api.nvim_get_current_buf()
	local foldstart = vim.v.foldstart
	local cache_key = bufnr .. ":" .. foldstart

	-- Check cache first
	if folding_cache.fold_text[cache_key] then
		return folding_cache.fold_text[cache_key]
	end

	local lang = ts.language.get_lang(vim.bo.filetype)
	if lang == nil then
		return nil
	end

	-- Use cached parser or create new one
	if not folding_cache.parsers[bufnr] then
		folding_cache.parsers[bufnr] = {}
	end

	local parser = ts.get_parser(bufnr, lang)
	if parser == nil then
		return nil
	end

	-- Use cached query or create new one
	if not folding_cache.queries[lang] then
		folding_cache.queries[lang] = ts.query.get(parser:lang(), "highlights")
	end
	local query = folding_cache.queries[lang]

	if query == nil then
		return vim.fn.foldtext()
	end

	local result = {}
	local prefix = fold_start_prefix()
	table.insert(result, { prefix, "Folded" })

	local processed_nodes = {}
	local prev_col = #prefix
	local prev_row = foldstart

	local tree = parser:parse({ foldstart - 1, foldstart })[1]
	local start_node = get_last_node_at_line(tree:root(), foldstart)

	if start_node:type() == "comment" then
		local first_line = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, false)[1]
		return { { first_line, "" } }
	end

	local next_break = false

	for id, node, _ in query:iter_captures(tree:root(), 0, foldstart - 1, -1) do
		local text = T(node)
		local name = query.captures[id]
		local start_row, start_col, end_row, end_col = node:range()

		-- stop on start of body statements
		if node:type() == "{" or node:type() == ":" then
			-- result[#result] = { text, "@" .. name .. "" }
			break
		end

		if start_row + 1 >= vim.v.foldend then
			break
		end

		-- pointers are recursive nodes, skip pointer subtree root
		if node:type() == "pointer_declarator" or node:type() == "field_expression" then
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
			result[#result] = { text, "@" .. name .. "" }
		else
			table.insert(result, { text, "@" .. name .. "" })
			processed_nodes[node:id()] = true
		end

		if next_break then
			break
		end

		if
			name == "constant.macro"
			or name == "constant.macro.cpp"
			or name == "keyword.directive"
			or name == "keyword.directive.cpp"
		then
			next_break = true
		end

		::continue::
	end

	-- Cache the result for future use
	folding_cache.fold_text[cache_key] = result

	return result
end

function FoldtextDefault()
	local pos = vim.v.foldstart
	local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]
	local lang = ts.language.get_lang(vim.bo.filetype)
	local parser = ts.get_parser(0, lang)
	if parser == nil then
		return vim.fn.foldtext()
	end

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

function M.CreateFoldGroups(groups)
	-- Schedule highlight group creation to avoid blocking
	vim.schedule(function()
		-- Remove italic from the Folded highlight group
		local folded_hl = vim.api.nvim_get_hl(0, { name = "Folded" })
		folded_hl.italic = false
		vim.api.nvim_set_hl(0, "Folded", folded_hl)

		-- Helper function to get highlight group details
		local function get_highlight(group)
			local id = vim.api.nvim_get_hl_id_by_name(group)
			local hl = vim.api.nvim_get_hl(0, { id = id })

			if hl ~= nil and hl.link ~= nil and hl.link ~= group then
				return get_highlight(hl.link)
			end

			return hl
		end

		-- Batch highlight group creation for better performance
		local highlight_batch = {}

		for _, group in ipairs(groups) do
			-- Use cached highlight if available
			if not folding_cache.highlight_groups[group] then
				folding_cache.highlight_groups[group] = get_highlight(group)
			end

			local hl = folding_cache.highlight_groups[group]
			if hl then
				highlight_batch[group .. ".folded"] = {
					fg = hl.fg,
					bg = "#51576d",
					underline = false,
				}
			end
		end

		-- Apply all highlights in a batch
		for group_name, opts in pairs(highlight_batch) do
			vim.api.nvim_set_hl(0, group_name, opts)
		end
	end)
end

-- Function to get all highlight groups
local function get_all_highlight_groups()
	local groups = {
		"@attribute",
		"@attribute.builtin",
		"@boolean",
		"@character",
		"@character.special",
		"@comment",
		"@comment.error",
		"@comment.note",
		"@comment.todo",
		"@comment.warning",
		"@constant",
		"@constant.macro",
		"@constant.macro.cpp",
		"@constant.builtin",
		"@constructor",
		"@constructor.lua",
		"@diff.delta",
		"@diff.minus",
		"@diff.plus",
		"@function",
		"@function.builtin",
		"@function.call",
		"@keyword",
		"@keyword.conditional",
		"@keyword.directive",
		"@keyword.directive.cpp",
		"@keyword.exception",
		"@keyword.function",
		"@keyword.function.rust",
		"@keyword.import",
		"@keyword.luap",
		"@keyword.modifier",
		"@keyword.modifier.rust",
		"@keyword.operator",
		"@keyword.repeat",
		"@keyword.repeat.c",
		"@keyword.return",
		"@keyword.type",
		"@keyword.type.rust",
		"@keyword.rust",
		"@label",
		"@lsp.mod.defaultLibrary.c",
		"@lsp.mod.deprecated",
		"@lsp.mod.readonly",
		"@lsp.mod.typeHint",
		"@lsp.type.bitwise",
		"@lsp.type.builtinConstant",
		"@lsp.type.class",
		"@lsp.type.class.c",
		"@lsp.type.comment",
		"@lsp.type.comparison",
		"@lsp.type.const",
		"@lsp.type.decorator",
		"@lsp.type.decorator.rust",
		"@lsp.type.enum",
		"@lsp.type.enumMember",
		"@lsp.type.event",
		"@lsp.type.function",
		"@lsp.type.function.c",
		"@lsp.type.interface",
		"@lsp.type.keyword",
		"@lsp.type.lifetime",
		"@lsp.type.macro",
		"@lsp.type.magicFunction",
		"@lsp.type.method",
		"@lsp.type.modifier",
		"@lsp.type.namespace",
		"@lsp.type.number",
		"@lsp.type.operator",
		"@lsp.type.parameter",
		"@lsp.type.property",
		"@lsp.type.punctuation",
		"@lsp.type.regexp",
		"@lsp.type.selfParameter",
		"@lsp.type.string",
		"@lsp.type.struct",
		"@lsp.type.type",
		"@lsp.type.typeParameter",
		"@lsp.type.variable",
		"@lsp.type.variable.c",
		"@lsp.typemod.function.builtin",
		"@lsp.typemod.function.defaultLibrary",
		"@lsp.typemod.function.readonly",
		"@lsp.typemod.keyword.documentation",
		"@lsp.typemod.method.defaultLibrary",
		"@lsp.typemod.operator.controlFlow",
		"@lsp.typemod.variable.defaultLibrary",
		"@lsp.typemod.variable.global",
		"@lsp.typemod.variable.injected",
		"@lsp.typemod.variable.static",
		"@markup",
		"@markup.environment",
		"@markup.heading",
		"@markup.italic",
		"@markup.link",
		"@markup.link.url",
		"@markup.math",
		"@markup.quote",
		"@markup.raw",
		"@markup.strikethrough",
		"@markup.strong",
		"@markup.underline",
		"@module",
		"@module.builtin",
		"@number",
		"@number.float",
		"@operator",
		"@property",
		"@punctuation",
		"@punctuation.bracket",
		"@punctuation.delimiter",
		"@punctuation.special",
		"@string",
		"@string.escape",
		"@string.regexp",
		"@string.special",
		"@string.special.symbol",
		"@string.special.url",
		"@tag",
		"@tag.attribute",
		"@tag.builtin",
		"@tag.delimiter",
		"@type",
		"@type.builtin",
		"@type.builtin.c",
		"@type.builtin.cpp",
		"@variable",
		"@variable.builtin",
		"@variable.c",
		"@variable.member",
		"@variable.parameter",
		"@variable.parameter.builtin",
		"Boolean",
		"Changed",
		"Character",
		"Comment",
		"Conceal",
		"Conditional",
		"Constant",
		"CurSearch",
		"DapStoppedLine",
		"Define",
		"Delimiter",
		"DiffAdd",
		"DiffChange",
		"DiffDelete",
		"DiffText",
		"Directory",
		"Error",
		"ErrorMsg",
		"Exception",
		"FoldColumn",
		"Folded",
		"Function",
		"Identifier",
		"Ignore",
		"IncSearch",
		"Include",
		"Keyword",
		"Label",
		"LazyProgressTodo",
		"LineNr",
		"LspCodeLens",
		"LspCodeLensSeparator",
		"LspReferenceRead",
		"LspReferenceText",
		"LspReferenceWrite",
		"LspSignatureActiveParameter",
		"Macro",
		"MatchParen",
		"MsgArea",
		"NonText",
		"Normal",
		"NormalNC",
		"Number",
		"Operator",
		"PreCondit",
		"PreProc",
		"SignColumn",
		"Statement",
		"Structure",
		"Substitute",
		"Tag",
		"Type",
		"Typedef",
	}

	return groups
end

function M.init()
	vim.opt.foldlevel = 99
	vim.opt.foldenable = false
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	-- vim.opt.foldtext = [[luaeval('FoldtextDefault')()]]
	vim.opt.fillchars:append({ fold = " " })

	-- vim.api.nvim_create_autocmd('LspAttach', {
	-- 	callback = function(args)
	-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
	--         if client:supports_method('textDocument/foldingRange') then
	-- 			local win = vim.api.nvim_get_current_win()
	-- 			vim.wo[win][0].foldmethod = 'expr'
	-- 			vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
	-- 		end
	-- 	end,
	-- })

	-- Create an autocommand group for better management
	local group = vim.api.nvim_create_augroup("CppPostInit", { clear = true })

	-- Define an autocommand for when color scheme and Tree-sitter are ready
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = group,
		pattern = { "c", "cpp", "rust", "python" },
		callback = function()
			-- Ensure Tree-sitter and color scheme are ready
			vim.schedule(function()
				if vim.treesitter.language.get_lang("cpp") then
					local highlight_groups = get_all_highlight_groups()
					M.CreateFoldGroups(highlight_groups)
					vim.opt.foldtext = [[luaeval('FoldtextCoding')()]]
				end
			end)
		end,
		desc = "Run custom logic for C++ files after color scheme and Tree-sitter initialization",
	})

	-- vim.api.nvim_create_autocmd("FileType", {
	-- 	pattern = { "c", "cpp", "rust" },
	-- 	callback = function()
	-- 		local highlight_groups = get_all_highlight_groups()
	-- 		M.CreateFoldGroups(highlight_groups)
	-- 		vim.opt.foldtext = [[luaeval('FoldtextCoding')()]]
	-- 	end,
	-- })
end

M.init()
