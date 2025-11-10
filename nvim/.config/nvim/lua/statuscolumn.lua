-- ============================================================================
-- StatusColumn Performance Optimized Implementation
-- ============================================================================
-- This implementation follows hot/cold path separation:
-- - Hot path (statuscolumn callback): O(1) operations only, no loops/API calls
-- - Cold path (setup/autocmds): All expensive precomputation
-- ============================================================================

local M = {
	-- Config
	levels = { true, true, true, true, true },
	max_level = 5,
	complement = true,
	fold = "",

	-- Precomputed data (cold path)
	harpoon_rows = {}, -- { [bufnr] = { [row] = true } }
	harpoon_module = nil, -- Cached module reference
}

-- ============================================================================
-- Cold Path: Highlight Setup (called once + on ColorScheme)
-- ============================================================================
M.setup_highlights = function()
	vim.api.nvim_set_hl(0, "FoldSign", { fg = "#ffffff" })
	vim.api.nvim_set_hl(0, "CurrentLineNr", { fg = "#d9a46c", bold = true })
	vim.api.nvim_set_hl(0, "HarpoonIndicator", { fg = "#61afef", bold = true })
end

-- ============================================================================
-- Cold Path: Harpoon Cache Refresh (called on buffer/harpoon changes)
-- ============================================================================
M.init_harpoon = function()
	local ok, harpoon = pcall(require, "harpoon")
	if ok then
		M.harpoon_module = harpoon
		M.refresh_harpoon_cache()
	end
end

M.refresh_harpoon_cache = function()
	if not M.harpoon_module then
		return
	end

	-- Reset cache
	M.harpoon_rows = {}

	local list = M.harpoon_module:list("spots")
	if list and list.items then
		for _, item in ipairs(list.items) do
			if item and item.value and item.value.file and item.value.row then
				-- Get buffer number from file path (normalized)
				local file = vim.fn.fnamemodify(item.value.file, ":p")
				local bufnr = vim.fn.bufnr(file)

				if bufnr ~= -1 then
					if not M.harpoon_rows[bufnr] then
						M.harpoon_rows[bufnr] = {}
					end
					M.harpoon_rows[bufnr][item.value.row] = true
				end
			end
		end
	end
end

-- ============================================================================
-- Hot Path: O(1) Harpoon Lookup
-- ============================================================================
M.harpoon_sign = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local lnum = vim.v.lnum

	if M.harpoon_rows[bufnr] and M.harpoon_rows[bufnr][lnum] then
		return "%#HarpoonIndicator#󰃃%*"
	end
	return ""
end

-- ============================================================================
-- Hot Path: Line Number Rendering
-- ============================================================================
M.line_number = function()
	local is_current_line = vim.v.relnum == 0
	local number = is_current_line and vim.v.lnum or vim.v.relnum

	if is_current_line then
		return string.format("%%#CurrentLineNr#%d%%*", number)
	else
		return tostring(number)
	end
end

-- ============================================================================
-- Hot Path: Main Statuscolumn Callback (O(1) operations only!)
-- ============================================================================
M.statuscolumn = function()
	return table.concat({
		"%s", -- Built-in sign column
		M.harpoon_sign(), -- O(1) hash lookup
		" ",
		"%=", -- Right-align the rest
		M.line_number(), -- Simple check + format
		" ",
		"%C", -- Built-in fold column (optimal!)
		" ",
	})
end

-- ============================================================================
-- Cold Path: Fold Level Toggle (z1-z5, z0 keymaps)
-- ============================================================================
local function statuscolumn_update()
	vim.schedule(function()
		vim.cmd("redraw!")

		local zvals = ""
		for i = 1, M.max_level do
			if M.levels[i] then
				zvals = zvals .. tostring(i) .. " " .. M.fold .. "\n"
			else
				zvals = zvals .. tostring(i) .. " " .. "\n"
			end
		end
		if M.complement then
			zvals = zvals .. "n " .. M.fold
		else
			zvals = zvals .. "n "
		end

		vim.schedule(function()
			vim.cmd("Noice dismiss")
			Snacks.notify.info(zvals)
		end)
	end)
end

local function zi_update(i)
	if i <= M.max_level then
		M.levels[i] = not M.levels[i]
	else
		M.complement = not M.complement
	end
	statuscolumn_update()
end

-- ============================================================================
-- Cold Path: Setup Keymaps
-- ============================================================================
M.setup_keymaps = function()
	for i = 1, M.max_level do
		local zi = "z" .. tostring(i)
		vim.keymap.set("n", zi, function()
			zi_update(i)
		end)
	end

	vim.keymap.set("n", "z0", function()
		zi_update(M.max_level + 1)
	end)
end

-- ============================================================================
-- Cold Path: Setup Autocmds
-- ============================================================================
M.setup_autocmds = function()
	-- Refresh highlights on colorscheme change
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = M.setup_highlights,
		desc = "Refresh statuscolumn highlights",
	})

	-- Refresh harpoon cache on buffer changes
	vim.api.nvim_create_autocmd("BufEnter", {
		callback = M.refresh_harpoon_cache,
		desc = "Refresh harpoon statuscolumn cache",
	})

	-- Refresh harpoon cache on harpoon changes (if event exists)
	vim.api.nvim_create_autocmd("User", {
		pattern = "HarpoonChanged",
		callback = M.refresh_harpoon_cache,
		desc = "Refresh harpoon cache on harpoon changes",
	})
end

-- ============================================================================
-- Cold Path: Main Setup (called once on require)
-- ============================================================================
M.setup = function()
	M.setup_highlights()
	M.init_harpoon()
	M.setup_autocmds()
	M.setup_keymaps()
end

-- Initialize on require
M.setup()

return M
