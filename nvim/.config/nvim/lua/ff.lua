local M = {}

M.get_treesitter_node = function(row, col)
	return vim.treesitter.get_node({
		pos = { row, col },
	})
end

M.advance = function(iterator, opts)
	local res_state = iterator.state

	local iter_method = "prev"
	local cur_state = res_state

	local iter = iterator[iter_method]
	for _ = 1, opts.n_times do
		-- Advance
		print(cur_state.node:type())
		cur_state = iter(cur_state)

		if cur_state == nil then
			-- Stop if can't wrap around edges
			if not opts.wrap then
				break
			end

			-- Wrap around edge
			local edge = iterator.start_edge
			if iter_method == "prev" then
				edge = iterator.end_edge
			end
			if edge == nil then
				break
			end

			cur_state = iter(edge)

			-- Ensure non-nil new state (can happen when there are no targets)
			if cur_state == nil then
				break
			end
		end

		-- Allow only partial reach of `n_times`
		res_state = cur_state
	end

	return res_state
end

M.treesitter = function(_)
	local opts = {
		n_times = 2,
		wrap = false,
	}

	local is_bad_node = function(node)
		return node == nil or node:parent() == nil
	end
	local is_after = function(row_new, col_new, row_ref, col_ref)
		return row_ref < row_new or (row_ref == row_new and col_ref < col_new)
	end
	local is_before = function(row_new, col_new, row_ref, col_ref)
		return is_after(row_ref, col_ref, row_new, col_new) or (row_new + 1) < vim.v.foldstart
	end

	local iterator = {}

	iterator.prev = function(node_pos)
		local node = node_pos.node
		if is_bad_node(node) then
			return nil
		end

		local init_row, init_col = node_pos.pos[1], node_pos.pos[2]
		local cur_row, cur_col, cur_node = init_row, init_col, node

		repeat
			if is_bad_node(cur_node) then
				break
			end

			cur_row, cur_col = cur_node:start()
			cur_node = cur_node:parent()
		until is_before(cur_row, cur_col, init_row, init_col)

		if not is_before(cur_row, cur_col, init_row, init_col) then
			return
		end

		return { node = cur_node, pos = { cur_row, cur_col } }
	end

	local cur_pos = { vim.v.foldstart - 1, vim.fn.indent(vim.v.foldstart) }
	local ok, node = pcall(M.get_treesitter_node, cur_pos[1], cur_pos[2])

	if not ok then
		error(
			"In `treesitter()` target can not find tree-sitter node under cursor."
				.. " Do you have tree-sitter enabled in current buffer?"
		)
	end

	if node == nil then
		return nil
	end

	if vim.fn.indent(vim.v.foldstart) > 0 then
		return node
	else
		return node:parent()
	end

	-- iterator.state = { pos = { cur_pos[1], cur_pos[2] }, node = node }
	-- return M.advance(iterator, opts)
end

M.init()
