local M = {}

M.get_treesitter_node = function(row, col)
	return vim.treesitter.get_node({
		pos = { row, col },
	})
end

M.advance = function(iterator, opts)
	local res_state = iterator.state

	-- Compute loop data
	local iter_method = "prev"
	local cur_state = res_state

	-- Loop
	local iter = iterator[iter_method]
	for _ = 1, opts.n_times do
		-- Advance
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

H.treesitter = function(opts)
	opts = vim.tbl_deep_extend(
		"force",
		{ add_to_jumplist = false, n_times = vim.v.count1 },
		H.get_config().treesitter.options,
		opts or {}
	)

	opts.wrap = false

	local is_bad_node = function(node)
		return node == nil or node:parent() == nil
	end
	local is_after = function(row_new, col_new, row_ref, col_ref)
		return row_ref < row_new or (row_ref == row_new and col_ref < col_new)
	end
	local is_before = function(row_new, col_new, row_ref, col_ref)
		return is_after(row_ref, col_ref, row_new, col_new)
	end

	local iterator = {}

	-- Traverse node and parents until node's end is after current position
	-- iterator.next = function(node_pos)
	-- 	local node = node_pos.node
	-- 	if is_bad_node(node) then
	-- 		return nil
	-- 	end
	--
	-- 	local init_row, init_col = node_pos.pos[1], node_pos.pos[2]
	-- 	local cur_row, cur_col, cur_node = init_row, init_col, node
	--
	-- 	repeat
	-- 		if is_bad_node(cur_node) then
	-- 			break
	-- 		end
	--
	-- 		cur_row, cur_col = cur_node:end_()
	-- 		-- Correct for end-exclusiveness
	-- 		cur_col = cur_col - 1
	-- 		cur_node = cur_node:parent()
	-- 	until is_after(cur_row, cur_col, init_row, init_col)
	--
	-- 	if not is_after(cur_row, cur_col, init_row, init_col) then
	-- 		return
	-- 	end
	--
	-- 	return { node = cur_node, pos = { cur_row, cur_col } }
	-- end

	-- Traverse node and parents until node's start is before current position
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

	local cur_pos = { vim.v.foldstart, vim.fn.indent(vim.v.foldstart) }

	local ok, node = pcall(H.get_treesitter_node, cur_pos[1] - 1, cur_pos[2])
	if not ok then
		error(
			"In `treesitter()` target can not find tree-sitter node under cursor."
				.. " Do you have tree-sitter enabled in current buffer?"
		)
	end
	iterator.state = { pos = { cur_pos[1] - 1, cur_pos[2] }, node = node }

	return H.advance(iterator, opts)

	-- if res_node_pos == nil then
	-- 	return
	-- end

	-- Apply
	-- local row, col = res_node_pos.pos[1], res_node_pos.pos[2]
	-- vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

return H
