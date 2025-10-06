-- SmartW - Tree-sitter based smart word navigation
-- Provides intelligent cursor movement that understands code semantics

local M = {}

-- Configuration
local config = {
	-- Node types to treat as navigation targets
	target_nodes = {
		"identifier",
		"function_definition",
		"function_declaration",
		"function", -- function keyword
		"call_expression",
		"method_invocation",
		"string_literal",
		"string",
		"template_string",
		"number",
		"integer_literal",
		"float_literal",
		"boolean",
		"true",
		"false",
		"nil",
		"variable_declaration",
		"assignment_statement",
		"if_statement",
		"for_statement",
		"while_statement",
		"table_constructor",
		"array",
		"field",
		"property",
		"member_expression",
		"field_expression",
		"dot_index_expression",
		"index_expression",
		"bracket_index_expression",
		"property_identifier",
		"binary_expression",
		"unary_expression",
		"return_statement",
		"break_statement",
		"continue_statement",
	},

	-- Container nodes that we navigate into
	container_nodes = {
		"arguments",
		"parameters",
		"parameter_list",
		"table_constructor",
		"array",
		"block",
		"chunk",
		"do_statement",
		"function_body",
		"if_statement",
		"for_statement",
		"while_statement",
	},

	-- Separator nodes
	separator_nodes = {
		",",
		";",
		".",
		":",
		"=",
		"==",
		"!=",
		"<",
		">",
		"<=",
		">=",
		"+",
		"-",
		"*",
		"/",
		"%",
		"^",
		"and",
		"or",
		"not",
	},

	-- Enable debug output
	debug = false,
}

-- Cache for parsers and queries
local cache = {
	parsers = {},
	queries = {},
	last_update = {},
}

-- Utility functions
local utils = {}

function utils.debug_log(msg)
	if config.debug then
		vim.notify("[SmartW] " .. tostring(msg), vim.log.levels.DEBUG)
	end
end

function utils.get_cursor_pos()
	local cursor = vim.api.nvim_win_get_cursor(0)
	return cursor[1] - 1, cursor[2] -- Convert to 0-indexed
end

function utils.set_cursor_pos(row, col)
	vim.api.nvim_win_set_cursor(0, { row + 1, col }) -- Convert from 0-indexed
end

function utils.get_buffer_text(bufnr)
	bufnr = bufnr or 0
	return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
end

function utils.pos_to_byte(lines, row, col)
	local byte_offset = 0
	for i = 1, row do
		if lines[i] then
			byte_offset = byte_offset + #lines[i] + 1 -- +1 for newline
		end
	end
	return byte_offset + col
end

function utils.byte_to_pos(lines, byte_offset)
	local current_offset = 0
	for row, line in ipairs(lines) do
		local line_length = #line + 1 -- +1 for newline
		if current_offset + line_length > byte_offset then
			return row - 1, byte_offset - current_offset
		end
		current_offset = current_offset + line_length
	end
	return #lines - 1, 0
end

function utils.skip_leading_whitespace(bufnr, row, col)
	local lines = utils.get_buffer_text(bufnr)
	local line = lines[row + 1] -- Convert to 1-indexed

	if not line then
		return row, col
	end

	-- If we're at the beginning of a line with leading whitespace,
	-- move to the first non-whitespace character
	if col == 0 then
		local first_non_ws = line:match("^%s*()")
		if first_non_ws and first_non_ws > 1 then
			-- found leading whitespace, move to first non-whitespace char
			local new_col = first_non_ws - 1 -- Convert to 0-indexed
			utils.debug_log("Skipping leading whitespace: moving from col " .. col .. " to col " .. new_col)
			return row, new_col
		end
	end

	return row, col
end

-- Tree-sitter integration
local ts = {}

function ts.get_parser(bufnr, lang)
	bufnr = bufnr or 0
	lang = lang or vim.bo[bufnr].filetype

	local key = bufnr .. ":" .. lang
	if not cache.parsers[key] then
		local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
		if not ok then
			utils.debug_log("Failed to get parser for " .. lang .. ": " .. tostring(parser))
			return nil
		end
		cache.parsers[key] = parser
	end

	return cache.parsers[key]
end

function ts.get_root(bufnr)
	local parser = ts.get_parser(bufnr)
	if not parser then
		return nil
	end

	local trees = parser:parse()
	return trees[1] and trees[1]:root()
end

function ts.get_node_at_cursor(bufnr, row, col)
	local root = ts.get_root(bufnr)
	if not root then
		return nil
	end

	return root:descendant_for_range(row, col, row, col)
end

function ts.node_text(node, bufnr)
	if not node then
		return ""
	end
	bufnr = bufnr or 0
	return vim.treesitter.get_node_text(node, bufnr)
end

-- Navigation context detection
local contexts = {}

function contexts.is_in_function_call(node)
	while node do
		if node:type() == "call_expression" or node:type() == "method_invocation" or node:type() == "function_call" then
			return node
		end
		node = node:parent()
	end
	return nil
end

function contexts.is_in_string(node)
	while node do
		local node_type = node:type()
		if node_type:match("string") or node_type == "template_string" or node_type == "string_literal" then
			return node
		end
		node = node:parent()
	end
	return nil
end

function contexts.is_in_container(node)
	while node do
		local node_type = node:type()
		for _, container_type in ipairs(config.container_nodes) do
			if node_type == container_type then
				return node
			end
		end
		node = node:parent()
	end
	return nil
end

function contexts.is_in_parameters(node)
	while node do
		local node_type = node:type()
		if
			node_type == "parameters"
			or node_type == "parameter_list"
			or node_type == "arguments"
			or node_type == "argument_list"
		then
			return node
		end
		node = node:parent()
	end
	return nil
end

function contexts.is_in_table_constructor(node)
	while node do
		local node_type = node:type()
		if node_type == "table_constructor" then
			return node
		end
		node = node:parent()
	end
	return nil
end

function contexts.is_in_member_expression(node)
	-- Walk up to find if we're part of a member expression chain
	local current = node
	while current do
		local node_type = current:type()
		if
			node_type == "member_expression"
			or node_type == "field_expression"
			or node_type == "index_expression"
			or node_type == "property_identifier"
			or node_type == "dot_index_expression"
		then
			-- Find the root of the chain by walking up
			local root = current
			while root:parent() do
				local parent_type = root:parent():type()
				if
					parent_type == "member_expression"
					or parent_type == "field_expression"
					or parent_type == "dot_index_expression"
				then
					root = root:parent()
				else
					break
				end
			end
			return root
		end
		current = current:parent()
	end
	return nil
end

-- Node traversal utilities
local traversal = {}

function traversal.get_next_sibling_target(node)
	if not node then
		return nil
	end

	local sibling = node:next_sibling()
	while sibling do
		if traversal.is_target_node(sibling) then
			return sibling
		end
		-- Check children of non-target siblings
		local child_target = traversal.get_first_child_target(sibling)
		if child_target then
			return child_target
		end
		sibling = sibling:next_sibling()
	end
	return nil
end

function traversal.get_prev_sibling_target(node)
	if not node then
		return nil
	end

	local sibling = node:prev_sibling()
	while sibling do
		if traversal.is_target_node(sibling) then
			return sibling
		end
		-- Check children of non-target siblings
		local child_target = traversal.get_last_child_target(sibling)
		if child_target then
			return child_target
		end
		sibling = sibling:prev_sibling()
	end
	return nil
end

function traversal.get_first_child_target(node)
	if not node then
		return nil
	end

	-- Check if we're inside a parameter/argument container
	local is_param_container = false
	if
		node:type() == "arguments"
		or node:type() == "argument_list"
		or node:type() == "parameters"
		or node:type() == "parameter_list"
	then
		is_param_container = true
		utils.debug_log("In parameter container: " .. node:type())
	end

	for child in node:iter_children() do
		local child_type = child:type()

		-- If in parameter container, skip punctuation
		if is_param_container then
			utils.debug_log("  Checking child: " .. child_type)
			-- Skip opening/closing brackets and separators
			if
				child_type == "("
				or child_type == ")"
				or child_type == ","
				or child_type == ";"
				or child_type == "lparen"
				or child_type == "rparen"
				or child_type == "comma"
			then
				utils.debug_log("    Skipping punctuation: " .. child_type)
				goto continue
			end
		end

		if traversal.is_target_node(child) then
			utils.debug_log("  Found target child: " .. child_type)
			return child
		end

		local nested_target = traversal.get_first_child_target(child)
		if nested_target then
			return nested_target
		end

		::continue::
	end
	return nil
end

function traversal.get_last_child_target(node)
	if not node then
		return nil
	end

	-- Check if we're inside a parameter/argument container
	local is_param_container = false
	if
		node:type() == "arguments"
		or node:type() == "argument_list"
		or node:type() == "parameters"
		or node:type() == "parameter_list"
	then
		is_param_container = true
	end

	local children = {}
	for child in node:iter_children() do
		table.insert(children, child)
	end

	for i = #children, 1, -1 do
		local child = children[i]
		local child_type = child:type()

		-- If in parameter container, skip punctuation
		if is_param_container then
			-- Skip opening/closing brackets and separators
			if
				child_type == "("
				or child_type == ")"
				or child_type == ","
				or child_type == ";"
				or child_type == "lparen"
				or child_type == "rparen"
				or child_type == "comma"
			then
				goto continue
			end
		end

		if traversal.is_target_node(child) then
			return child
		end

		local nested_target = traversal.get_last_child_target(child)
		if nested_target then
			return nested_target
		end

		::continue::
	end
	return nil
end

function traversal.is_target_node(node)
	if not node then
		return false
	end

	local node_type = node:type()

	-- Special handling: if this node is a child of a member expression,
	-- don't treat it as an independent target (except the root member expression itself)
	local parent = node:parent()
	if parent then
		local parent_type = parent:type()
		if
			(
				parent_type == "member_expression"
				or parent_type == "field_expression"
				or parent_type == "dot_index_expression"
			)
			and node_type ~= "arguments"
			and node_type ~= "argument_list"
		then
			-- This is part of a member expression chain, not a standalone target
			return false
		end
	end

	-- Member expressions themselves are valid targets
	if node_type == "member_expression" or node_type == "field_expression" or node_type == "dot_index_expression" then
		return true
	end

	-- Check if it's in our target nodes list
	for _, target_type in ipairs(config.target_nodes) do
		if node_type == target_type then
			return true
		end
	end

	-- Additional checks for specific contexts
	if node_type == "identifier" and node:parent() then
		local parent_type = node:parent():type()
		-- Don't treat identifiers in function definitions as regular targets
		if parent_type == "function_definition" or parent_type == "function_declaration" then
			return false
		end
	end

	return false
end

-- Smart movement implementation
local movement = {}

function movement.find_next_target(bufnr, row, col, direction)
	direction = direction or 1 -- 1 for forward, -1 for backward

	local current_node = ts.get_node_at_cursor(bufnr, row, col)
	if not current_node then
		return movement.fallback_movement(bufnr, row, col, direction)
	end

	utils.debug_log("Current node: " .. current_node:type() .. " at (" .. row .. "," .. col .. ")")

	-- Debug: show node range to understand position relationship
	local node_start_row, node_start_col = current_node:start()
	local node_end_row, node_end_col = current_node:end_()
	utils.debug_log(
		"Node range: ("
			.. node_start_row
			.. ","
			.. node_start_col
			.. ") to ("
			.. node_end_row
			.. ","
			.. node_end_col
			.. ")"
	)

	-- Special handling for punctuation nodes (prevent getting stuck on brackets/braces)
	local node_type = current_node:type()
	if
		node_type == "{"
		or node_type == "}"
		or node_type == "("
		or node_type == ")"
		or node_type == "["
		or node_type == "]"
		or node_type == ","
		or node_type == ";"
	then
		local parent = current_node:parent()
		if parent then
			if parent:type() == "table_constructor" or parent:type() == "arguments" then
				-- Direction-aware punctuation handling
				if direction > 0 then
					-- Moving forward: go into container (first child)
					if node_type == "{" or node_type == "(" or node_type == "[" then
						local first_child = traversal.get_first_child_target(parent)
						if first_child then
							local child_row, child_col = first_child:start()
							-- Ensure we're actually moving to prevent loops
							if child_row ~= row or child_col ~= col then
								utils.debug_log(
									"Opening punctuation -> first child at (" .. child_row .. "," .. child_col .. ")"
								)
								return child_row, child_col
							end
						end
					elseif node_type == "}" or node_type == ")" or node_type == "]" then
						-- Closing brace: exit container and find next target
						utils.debug_log("Closing punctuation: exiting container")
						local next_target = traversal.get_next_sibling_target(parent)
						if next_target then
							local target_row, target_col = next_target:start()
							return target_row, target_col
						end
						-- Use parent as current node for general navigation
						current_node = parent
					else
						-- Separator (comma, semicolon): find next item in container
						utils.debug_log("Separator: finding next item in container")
						local next_target = traversal.get_next_sibling_target(current_node)
						if next_target then
							local target_row, target_col = next_target:start()
							return target_row, target_col
						end
					end
				else
					-- Moving backward: different logic
					if node_type == "}" or node_type == ")" or node_type == "]" then
						-- Closing brace: go to last child in container
						local last_child = traversal.get_last_child_target(parent)
						if last_child then
							local child_row, child_col = last_child:start()
							if child_row ~= row or child_col ~= col then
								utils.debug_log(
									"Closing punctuation backward -> last child at ("
										.. child_row
										.. ","
										.. child_col
										.. ")"
								)
								return child_row, child_col
							end
						end
					elseif node_type == "{" or node_type == "(" or node_type == "[" then
						-- Opening brace: exit container and find previous target
						utils.debug_log("Opening punctuation backward: exiting container")
						local prev_target = traversal.get_prev_sibling_target(parent)
						if prev_target then
							local target_row, target_col = prev_target:start()
							return target_row, target_col
						end
						-- Use parent as current node for general navigation
						current_node = parent
					else
						-- Separator: find previous item in container
						utils.debug_log("Separator backward: finding previous item in container")
						local prev_target = traversal.get_prev_sibling_target(current_node)
						if prev_target then
							local target_row, target_col = prev_target:start()
							return target_row, target_col
						end
					end
				end
			end
		end
	end

	-- Special handling for field navigation (only if NOT inside table constructor)
	if node_type == "identifier" then
		utils.debug_log("Identifier found, checking if in field")
		local parent = current_node:parent()
		if parent and parent:type() == "field" then
			utils.debug_log("In field, checking table constructor")
			-- Check if we're inside a table constructor - if so, let table navigation handle it
			local table_constructor = contexts.is_in_table_constructor(current_node)
			utils.debug_log("Field -> table constructor check: " .. (table_constructor and "found" or "not found"))
			if not table_constructor then
				utils.debug_log("Not in table constructor, using field navigation")
				if direction > 0 then
					-- Moving forward: field name -> field value -> next field/exit
					-- First, try to find the value if we're on the name
					local field_children = {}
					for child in parent:iter_children() do
						if traversal.is_target_node(child) then
							table.insert(field_children, child)
						end
					end

					-- If we have both name and value, and we're on the first (name)
					if #field_children >= 2 and current_node == field_children[1] then
						local value_row, value_col = field_children[2]:start()
						utils.debug_log("Field name -> field value at (" .. value_row .. "," .. value_col .. ")")
						return value_row, value_col
					else
						-- We're on field value or only child, exit field and find next target
						utils.debug_log("Exiting field, looking for next target outside field")
						local field_target = traversal.get_next_sibling_target(parent)
						if field_target then
							local target_row, target_col = field_target:start()
							utils.debug_log(
								"Found next target after field at (" .. target_row .. "," .. target_col .. ")"
							)
							return target_row, target_col
						end
						-- Continue with general navigation using the field parent as current node
						current_node = parent
					end
				else
					-- Moving backward: field value -> field name -> previous field
					local field_children = {}
					for child in parent:iter_children() do
						if traversal.is_target_node(child) then
							table.insert(field_children, child)
						end
					end

					-- If we have both name and value, and we're on the second (value)
					if #field_children >= 2 and current_node == field_children[2] then
						local name_row, name_col = field_children[1]:start()
						utils.debug_log("Field value -> field name at (" .. name_row .. "," .. name_col .. ")")
						return name_row, name_col
					else
						-- We're on field name or only child, exit field and find previous target
						utils.debug_log("Exiting field backward, looking for previous target")
						local field_target = traversal.get_prev_sibling_target(parent)
						if field_target then
							local target_row, target_col = field_target:start()
							utils.debug_log(
								"Found previous target before field at (" .. target_row .. "," .. target_col .. ")"
							)
							return target_row, target_col
						end
						-- Continue with general navigation using the field parent as current node
						current_node = parent
					end
				end
			end
		end
	end

	-- Special handling for table constructors (highest priority for table context)
	local table_constructor = contexts.is_in_table_constructor(current_node)
	utils.debug_log("Table constructor check: " .. (table_constructor and "found" or "not found"))
	if table_constructor then
		utils.debug_log("In table constructor, calling navigate_table_constructor")
		local target = movement.navigate_table_constructor(table_constructor, current_node, direction)
		if target then
			local start_row, start_col = target:start()
			-- Validate position change to prevent loops
			if start_row ~= row or start_col ~= col then
				utils.debug_log("Table constructor navigation: moving to (" .. start_row .. "," .. start_col .. ")")
				return start_row, start_col
			else
				utils.debug_log("Table constructor returned same position, skipping")
			end
		else
			-- Reached end of table, exit the container and continue navigation
			utils.debug_log("Exiting table constructor, continuing general navigation")
			-- Use the table constructor itself to find next target outside of it
			current_node = table_constructor
			-- Fall through to general navigation
		end
	end

	-- Special handling for function calls (only if NOT in table constructor)
	local param_container = nil
	if not table_constructor then
		local func_call = contexts.is_in_function_call(current_node)
		utils.debug_log("Function call check: " .. (func_call and "found" or "not found"))
		if func_call then
			utils.debug_log("In function call, calling navigate_function_call")
			local target = movement.navigate_function_call(func_call, current_node, direction)
			if target then
				local start_row, start_col = target:start()
				-- Validate position change to prevent loops
				if start_row ~= row or start_col ~= col then
					utils.debug_log("Function call navigation: moving to (" .. start_row .. "," .. start_col .. ")")
					return start_row, start_col
				else
					utils.debug_log("Function call returned same position, skipping")
				end
			else
				utils.debug_log("Function call navigation returned nil")
			end
		end

		-- Special handling for parameter lists (only if NOT in table constructor)
		param_container = contexts.is_in_parameters(current_node)
		utils.debug_log("Parameter container check: " .. (param_container and "found" or "not found"))
		if param_container then
			utils.debug_log("In parameters, calling navigate_parameters")
			local target = movement.navigate_parameters(param_container, current_node, direction)
			if target then
				local start_row, start_col = target:start()
				-- Validate position change to prevent loops
				if start_row ~= row or start_col ~= col then
					utils.debug_log("Parameter navigation: moving to (" .. start_row .. "," .. start_col .. ")")
					return start_row, start_col
				else
					utils.debug_log("Parameter navigation returned same position, skipping")
				end
			else
				-- Reached end of parameter list, exit the container and continue navigation
				utils.debug_log("Exiting parameter list, continuing general navigation")
				-- Use the parameter container itself to find next target outside of it
				current_node = param_container
				-- Fall through to general navigation
			end
		end
	end

	-- Special handling for member expressions (only if NOT in parameters/table to avoid conflicts)
	if not param_container then
		table_constructor = contexts.is_in_table_constructor(current_node)
		if not table_constructor then
			local member_expr = contexts.is_in_member_expression(current_node)
			if member_expr then
				local target_row, target_col = movement.navigate_member_expression(member_expr, current_node, direction)
				-- Validate position change to prevent loops
				if target_row and target_col and (target_row ~= row or target_col ~= col) then
					return target_row, target_col
				end
			end
		end
	end

	-- Special handling for container nodes - look for children first
	local current_node_type = current_node:type()
	for _, container_type in ipairs(config.container_nodes) do
		if current_node_type == container_type then
			utils.debug_log("Current node is container type: " .. current_node_type)
			-- Find children within this container that come after our current position
			local target_child = nil

			-- Recursively search for target nodes within the container
			local function find_targets_after_position(node, after_row, after_col, dir)
				for child in node:iter_children() do
					if traversal.is_target_node(child) then
						local child_row, child_col = child:start()
						utils.debug_log(
							"  Checking target child: "
								.. child:type()
								.. " at ("
								.. child_row
								.. ","
								.. child_col
								.. ")"
						)

						if dir > 0 then
							-- Forward: find first child after current position
							if child_row > after_row or (child_row == after_row and child_col > after_col) then
								return child
							end
						else
							-- Backward: find last child before current position
							if child_row < after_row or (child_row == after_row and child_col < after_col) then
								target_child = child -- Keep updating to get the last one
							else
								break -- We've passed our position
							end
						end
					else
						-- Recursively search in non-target children
						local nested_target = find_targets_after_position(child, after_row, after_col, dir)
						if nested_target then
							if dir > 0 then
								return nested_target -- Return immediately for forward search
							else
								target_child = nested_target -- Keep updating for backward search
							end
						end
					end
				end
				return target_child
			end

			target_child = find_targets_after_position(current_node, row, col, direction)

			if target_child then
				local child_row, child_col = target_child:start()
				utils.debug_log(
					"Found child target in container: "
						.. target_child:type()
						.. " at ("
						.. child_row
						.. ","
						.. child_col
						.. ")"
				)
				return child_row, child_col
			else
				utils.debug_log("No suitable child target found in container after current position")
			end
			break
		end
	end

	-- General navigation
	local target_node
	if direction > 0 then
		target_node = movement.find_next_forward(current_node)
	else
		target_node = movement.find_next_backward(current_node)
	end

	if target_node then
		local start_row, start_col = target_node:start()
		utils.debug_log("Found target: " .. target_node:type() .. " at (" .. start_row .. "," .. start_col .. ")")
		return start_row, start_col
	end

	-- Fallback to regex-based navigation
	return movement.fallback_movement(bufnr, row, col, direction)
end

function movement.navigate_parameters(param_container, current_node, direction)
	utils.debug_log("navigate_parameters: current_node type = " .. current_node:type())

	-- Find all parameter/argument nodes
	local params = {}
	for child in param_container:iter_children() do
		utils.debug_log(
			"navigate_parameters: param child type = "
				.. child:type()
				.. ", is_target = "
				.. (traversal.is_target_node(child) and "true" or "false")
		)
		if traversal.is_target_node(child) then
			table.insert(params, child)
		end
	end
	utils.debug_log("navigate_parameters: found " .. #params .. " parameters")

	if #params == 0 then
		utils.debug_log("navigate_parameters: no parameters found")
		return nil
	end

	-- Find current position in parameter list
	local current_idx = nil
	local current_start_row, current_start_col = current_node:start()
	utils.debug_log("navigate_parameters: current node at (" .. current_start_row .. "," .. current_start_col .. ")")

	for i, param in ipairs(params) do
		local param_start_row, param_start_col = param:start()
		utils.debug_log(
			"navigate_parameters: param "
				.. i
				.. " ("
				.. param:type()
				.. ") at ("
				.. param_start_row
				.. ","
				.. param_start_col
				.. ")"
		)
		if param_start_row == current_start_row and param_start_col == current_start_col then
			current_idx = i
			utils.debug_log("navigate_parameters: found current param at index " .. i)
			break
		end
	end

	if not current_idx then
		utils.debug_log("navigate_parameters: current node not found in params, going to first/last")
		-- Not exactly on a parameter, find closest one
		if direction > 0 then
			return params[1] -- Go to first parameter
		else
			return params[#params] -- Go to last parameter
		end
	end

	-- Navigate to next/previous parameter
	local target_idx = current_idx + direction
	utils.debug_log("navigate_parameters: trying to go to param " .. target_idx .. " (direction=" .. direction .. ")")
	if target_idx >= 1 and target_idx <= #params then
		utils.debug_log("navigate_parameters: returning param " .. target_idx)
		return params[target_idx]
	end

	utils.debug_log("navigate_parameters: target index out of bounds, returning nil")
	return nil
end

function movement.navigate_table_constructor(table_node, current_node, direction)
	utils.debug_log("navigate_table_constructor: current_node type = " .. current_node:type())

	-- Find all field nodes
	local fields = {}
	for child in table_node:iter_children() do
		if child:type() == "field" then
			table.insert(fields, child)
		end
	end
	utils.debug_log("navigate_table_constructor: found " .. #fields .. " fields")

	if #fields == 0 then
		utils.debug_log("navigate_table_constructor: no fields found")
		return nil
	end

	-- Find which field we're currently in
	local current_field = nil
	local current_field_idx = nil

	-- Walk up to find the field we're in
	local temp_node = current_node
	while temp_node do
		utils.debug_log("navigate_table_constructor: checking parent node type = " .. temp_node:type())
		if temp_node:type() == "field" then
			current_field = temp_node
			utils.debug_log("navigate_table_constructor: found current field")
			break
		end
		temp_node = temp_node:parent()
	end

	if current_field then
		-- Find the index of current field
		for i, field in ipairs(fields) do
			if field == current_field then
				current_field_idx = i
				utils.debug_log("navigate_table_constructor: current field index = " .. i)
				break
			end
		end
	end

	if not current_field_idx then
		utils.debug_log("navigate_table_constructor: not in a field, going to first/last")
		-- Not in a field, go to first/last field
		if direction > 0 then
			local first_field = fields[1]
			return traversal.get_first_child_target(first_field)
		else
			local last_field = fields[#fields]
			return traversal.get_last_child_target(last_field)
		end
	end

	-- We're in a field, check if we should move within field or to next field
	local field_children = {}
	if current_field == nil then
		return nil
	end
	for child in current_field:iter_children() do
		utils.debug_log(
			"navigate_table_constructor: field child type = "
				.. child:type()
				.. ", is_target = "
				.. (traversal.is_target_node(child) and "true" or "false")
		)
		if traversal.is_target_node(child) then
			table.insert(field_children, child)
		end
	end
	utils.debug_log("navigate_table_constructor: field has " .. #field_children .. " target children")

	-- Find current position within field
	local current_field_pos = nil
	for i, child in ipairs(field_children) do
		utils.debug_log(
			"navigate_table_constructor: comparing child "
				.. i
				.. " ("
				.. child:type()
				.. ") with current_node ("
				.. current_node:type()
				.. ")"
		)
		if child == current_node then
			current_field_pos = i
			utils.debug_log("navigate_table_constructor: current position in field = " .. i)
			break
		end

		-- Also check if current_node is a descendant of this field child
		temp_node = current_node
		while temp_node do
			if temp_node == child then
				current_field_pos = i
				utils.debug_log("navigate_table_constructor: current node is descendant of field child " .. i)
				break
			end
			temp_node = temp_node:parent()
			-- Stop if we reach the field level to avoid going too far up
			if temp_node and temp_node:type() == "field" then
				break
			end
		end

		if current_field_pos then
			break
		end
	end

	if current_field_pos then
		if direction > 0 then
			-- Try to move to next element in same field
			if current_field_pos < #field_children then
				utils.debug_log("navigate_table_constructor: moving to next element in same field")
				return field_children[current_field_pos + 1]
			else
				-- Move to next field
				local next_field_idx = current_field_idx + 1
				if next_field_idx <= #fields then
					utils.debug_log("navigate_table_constructor: moving to next field " .. next_field_idx)
					return traversal.get_first_child_target(fields[next_field_idx])
				else
					utils.debug_log("navigate_table_constructor: reached end of fields")
				end
			end
		else
			-- Try to move to previous element in same field
			if current_field_pos > 1 then
				utils.debug_log("navigate_table_constructor: moving to previous element in same field")
				return field_children[current_field_pos - 1]
			else
				-- Move to previous field
				local prev_field_idx = current_field_idx - 1
				if prev_field_idx >= 1 then
					utils.debug_log("navigate_table_constructor: moving to previous field " .. prev_field_idx)
					return traversal.get_last_child_target(fields[prev_field_idx])
				else
					utils.debug_log("navigate_table_constructor: reached beginning of fields")
				end
			end
		end
	else
		utils.debug_log("navigate_table_constructor: current node not found in field children")
	end

	utils.debug_log("navigate_table_constructor: returning nil")
	return nil
end

function movement.navigate_function_call(func_call, current_node, direction)
	local func_name = func_call:child(0) -- Usually the function name

	-- Check if we're on the function name or part of it (for member expressions like vim.notify)
	local is_on_function_name = false
	if func_name then
		if current_node == func_name then
			is_on_function_name = true
		elseif func_name:type() == "member_expression" then
			-- For member expressions, check if we're on any part of it
			local temp_node = current_node
			while temp_node do
				if temp_node == func_name then
					is_on_function_name = true
					break
				end
				temp_node = temp_node:parent()
			end
		end
	end

	if direction > 0 then
		-- Forward: if we're on the function name, jump to first parameter
		if is_on_function_name then
			local args = nil
			for child in func_call:iter_children() do
				if child:type() == "arguments" or child:type() == "argument_list" then
					args = child
					break
				end
			end

			if args then
				utils.debug_log("Found arguments node, getting first child target")
				utils.debug_log("Arguments node type: " .. args:type())

				-- Debug: list all children of args
				local child_count = 0
				for child in args:iter_children() do
					child_count = child_count + 1
					utils.debug_log("  Child " .. child_count .. ": " .. child:type())
				end

				local first_arg = traversal.get_first_child_target(args)
				if first_arg then
					utils.debug_log("Returning first arg: " .. first_arg:type())
					return first_arg
				else
					utils.debug_log("No first arg found!")
				end
			end
		end
	else
		-- Backward: if we're in arguments, jump back to function name
		if not is_on_function_name and func_name then
			-- Check if we're inside the arguments
			local args = nil
			for child in func_call:iter_children() do
				if child:type() == "arguments" or child:type() == "argument_list" then
					args = child
					break
				end
			end

			if args then
				-- Check if current_node is inside the arguments
				local temp_node = current_node
				while temp_node do
					if temp_node == args then
						utils.debug_log("In arguments, jumping back to function name")
						return func_name
					end
					temp_node = temp_node:parent()
					-- Stop if we reach the function call level to avoid going too far up
					if temp_node and temp_node == func_call then
						break
					end
				end
			end
		end
	end

	return nil
end

function movement.navigate_member_expression(member_expr, current_node, direction)
	-- Navigate the entire member expression as a single unit
	-- e.g., vim.api.nvim_buf_get_lines or Foo.bar.baz

	if direction > 0 then
		-- Moving forward: check if this member expression is part of a function call
		-- If so, jump to the first argument instead of the end of the expression
		local parent = member_expr:parent()
		utils.debug_log("Member expr parent: " .. (parent and parent:type() or "nil"))
		if parent and (parent:type() == "call_expression" or parent:type() == "function_call") then
			utils.debug_log("Member expression is part of function call, looking for arguments...")
			-- This is a function call like utils.debug_log(...)
			-- Look for arguments and jump to first parameter
			for child in parent:iter_children() do
				utils.debug_log("Function call child: " .. child:type())
				if child:type() == "arguments" or child:type() == "argument_list" then
					utils.debug_log("Found arguments, getting first child target...")
					local first_arg = traversal.get_first_child_target(child)
					if first_arg then
						local arg_row, arg_col = first_arg:start()
						utils.debug_log(
							string.format(
								"Member expression is function call: jumping to first arg (%d,%d)",
								arg_row,
								arg_col
							)
						)
						return arg_row, arg_col
					else
						utils.debug_log("No first argument found in arguments container")
					end
					break
				end
			end
			utils.debug_log("No arguments found in function call, continuing with member expr navigation")
		end

		-- Get current cursor position to check if we're already at the end
		local current_row, current_col = utils.get_cursor_pos()
		local end_row, end_col = member_expr:end_()

		utils.debug_log(
			string.format(
				"Member expr boundary check: cursor=(%d,%d), expr_end=(%d,%d)",
				current_row,
				current_col,
				end_row,
				end_col
			)
		)

		-- Check if we're at the exact end position of the current node
		-- Tree-sitter may return nodes that end at the cursor position, but we should
		-- consider this as being "past" the node for navigation purposes
		local current_node_end_row, current_node_end_col = current_node:end_()
		utils.debug_log(string.format("Current node end: (%d,%d)", current_node_end_row, current_node_end_col))

		if current_row == current_node_end_row and current_col == current_node_end_col then
			utils.debug_log(
				string.format(
					"At exact end of current node (%d,%d == %d,%d), using general navigation",
					current_row,
					current_col,
					current_node_end_row,
					current_node_end_col
				)
			)
			return nil
		end

		-- If we're already at or past the end of the member expression,
		-- don't navigate within it - let general navigation take over
		if current_row > end_row or (current_row == end_row and current_col >= end_col) then
			utils.debug_log(
				string.format(
					"Already at/past end of member expression (%d,%d >= %d,%d), using general navigation",
					current_row,
					current_col,
					end_row,
					end_col
				)
			)
			return nil
		end

		-- Otherwise, we need to move past the entire expression
		-- But Tree-sitter's end() position might be beyond the line end
		-- So let's use general navigation to find the next valid target
		utils.debug_log(
			string.format(
				"Member expression forward: need to jump past '%s', using general navigation",
				ts.node_text(member_expr):gsub("\n", "\\n")
			)
		)
		return nil
	else
		-- Get current cursor position to check if we're already at the start
		local current_row, current_col = utils.get_cursor_pos()
		local start_row, start_col = member_expr:start()

		-- If we're already at or before the start of the member expression,
		-- don't navigate within it - let general navigation take over
		if current_row < start_row or (current_row == start_row and current_col <= start_col) then
			utils.debug_log(
				string.format(
					"Already at/before start of member expression (%d,%d <= %d,%d), using general navigation",
					current_row,
					current_col,
					start_row,
					start_col
				)
			)
			return nil
		end

		-- Moving backward: jump to the start of the expression
		utils.debug_log(
			string.format(
				"Member expression backward: jumping to start (%d,%d) of '%s'",
				start_row,
				start_col,
				ts.node_text(member_expr):gsub("\n", "\\n")
			)
		)
		return start_row, start_col
	end
end

function movement.find_next_forward(node)
	-- Try sibling first
	local target = traversal.get_next_sibling_target(node)
	if target then
		return target
	end

	-- Try going up and finding next sibling of parent
	local parent = node:parent()
	while parent do
		local parent_sibling = traversal.get_next_sibling_target(parent)
		if parent_sibling then
			return parent_sibling
		end
		parent = parent:parent()
	end

	return nil
end

function movement.find_next_backward(node)
	-- Try previous sibling
	local target = traversal.get_prev_sibling_target(node)
	if target then
		return target
	end

	-- Try going up and finding previous sibling of parent
	local parent = node:parent()
	while parent do
		local parent_sibling = traversal.get_prev_sibling_target(parent)
		if parent_sibling then
			return parent_sibling
		end
		parent = parent:parent()
	end

	return nil
end

-- Fallback regex-based navigation
function movement.fallback_movement(bufnr, row, col, direction)
	local lines = utils.get_buffer_text(bufnr)
	local line = lines[row + 1] -- Convert to 1-indexed

	if not line then
		return row, col
	end

	local patterns = {
		"%w+", -- Words
		"[%[%]%(%){}]", -- Brackets
		"[,.;:]", -- Punctuation
		"[=<>!]=?", -- Operators
		"[+%-*/%%^]", -- Math operators
	}

	if direction > 0 then
		-- Forward search
		local search_start = col + 1
		local best_pos = nil
		local best_distance = math.huge

		for _, pattern in ipairs(patterns) do
			local start_pos = search_start
			while true do
				local match_start, match_end = string.find(line, pattern, start_pos)
				if not match_start then
					break
				end

				if match_start > col then
					local distance = match_start - col
					if distance < best_distance then
						best_distance = distance
						best_pos = match_start - 1 -- Convert to 0-indexed
					end
					break
				end
				start_pos = match_end + 1
			end
		end

		if best_pos then
			return row, best_pos
		end

		-- Try next line
		if row + 1 < #lines then
			return row + 1, 0
		end
	else
		-- Backward search
		local best_pos = nil
		local best_distance = math.huge

		for _, pattern in ipairs(patterns) do
			local pos = 1
			while true do
				local match_start, match_end = string.find(line, pattern, pos)
				if not match_start or match_start >= col then
					break
				end

				local distance = col - match_start
				if distance < best_distance then
					best_distance = distance
					best_pos = match_start - 1 -- Convert to 0-indexed
				end
				pos = match_end + 1
			end
		end

		if best_pos then
			return row, best_pos
		end

		-- Try previous line
		if row > 0 then
			local prev_line = lines[row]
			return row - 1, #prev_line
		end
	end

	return row, col
end

-- Public API
function M.setup(user_config)
	config = vim.tbl_deep_extend("force", config, user_config or {})
end

function M.move_forward()
	local bufnr = 0
	local row, col = utils.get_cursor_pos()

	utils.debug_log("move_forward: starting at (" .. row .. "," .. col .. ")")

	-- Skip leading whitespace if we're at the beginning of a line
	local new_row, new_col = utils.skip_leading_whitespace(bufnr, row, col)
	if new_row ~= row or new_col ~= col then
		-- We moved due to whitespace skipping, that's the complete action
		utils.debug_log("move_forward: whitespace skip to (" .. new_row .. "," .. new_col .. ")")
		utils.set_cursor_pos(new_row, new_col)
		return true
	end

	new_row, new_col = movement.find_next_target(bufnr, row, col, 1)
	utils.debug_log(
		"move_forward: find_next_target returned (" .. (new_row or "nil") .. "," .. (new_col or "nil") .. ")"
	)

	if new_row and new_col and (new_row ~= row or new_col ~= col) then
		utils.debug_log("move_forward: setting cursor to (" .. new_row .. "," .. new_col .. ")")
		utils.set_cursor_pos(new_row, new_col)

		-- Verify the cursor was actually set
		local verify_row, verify_col = utils.get_cursor_pos()
		utils.debug_log("move_forward: cursor now at (" .. verify_row .. "," .. verify_col .. ")")
		return true
	end

	utils.debug_log("move_forward: no movement")
	return false
end

function M.move_backward()
	local bufnr = 0
	local row, col = utils.get_cursor_pos()

	local new_row, new_col = movement.find_next_target(bufnr, row, col, -1)

	if new_row and new_col and (new_row ~= row or new_col ~= col) then
		utils.set_cursor_pos(new_row, new_col)
		return true
	end

	return false
end

-- API functions with count support (for compatibility with init.lua)
function M.forward(count)
	count = count or 1
	for _ = 1, count do
		if not M.move_forward() then
			break
		end
	end
end

function M.backward(count)
	count = count or 1
	for _ = 1, count do
		if not M.move_backward() then
			break
		end
	end
end

-- Expose internal functions for testing
M._internal = {
	utils = utils,
	ts = ts,
	contexts = contexts,
	traversal = traversal,
	movement = movement,
	config = config,
	cache = cache,
}

return M
