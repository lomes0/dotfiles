local M = {}

M.floatterm_loaded = false
M.floatterm_buf = nil
M.floatterm_win = nil

function Launch_floatterm()
	if not M.floatterm_loaded or not vim.api.nvim_win_is_valid(M.floatterm_win) then
		if not M.floatterm_buf or not vim.api.nvim_buf_is_valid(M.floatterm_buf) then
			-- Create a buffer
			M.floatterm_buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_set_option_value("bufhidden", "hide", { buf = M.floatterm_buf })
			vim.api.nvim_set_option_value("filetype", "terminal", { buf = M.floatterm_buf })
			--vim.api.nvim_buf_set_lines(M.floatterm_buf, 0, 1, false, {
			--  "# Notepad",
			--  "",
			--  "> Notepad clears when the current Neovim session closes",
			--})
		end
		-- Create a window
		M.floatterm_win = vim.api.nvim_open_win(M.floatterm_buf, true, {
			border = "rounded",
			relative = "editor",
			style = "minimal",
			height = math.ceil(vim.o.lines * 0.35),
			width = math.ceil(vim.o.columns * 0.35),
			row = 0, --> Top of the window
			col = math.ceil(vim.o.columns * 0.65), --> Far right; should add up to 1 with win_width
		})

		vim.api.nvim_set_option_value("winblend", 0, { win = M.floatterm_win }) --> Semi transparent buffer
		-- Buffer-local Keymaps
		local keymaps_opts = { silent = true, buffer = M.floatterm_buf }
		vim.keymap.set("n", "<ESC>", function()
			Launch_floatterm()
		end, keymaps_opts)
		vim.keymap.set("n", "q", function()
			Launch_floatterm()
		end, keymaps_opts)
	else
		vim.api.nvim_win_hide(M.floatterm_win)
	end
	M.floatterm_loaded = not M.floatterm_loaded
end

function M.init()
	vim.api.nvim_set_keymap("n", ";1", ":lua Launch_floatterm()<cr>", { desc = "Toggle Notepad" })
end

return M
