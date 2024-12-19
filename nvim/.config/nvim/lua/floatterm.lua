local M = {}

M.Terminals = {}

Floatterm = {}
Floatterm.__index = Floatterm

function Floatterm:new()
	local term = {
		loaded = nil,
		buf = nil,
		win = nil,
	}

	setmetatable(term, Floatterm)

	return term
end

function Floatterm:toggle()
	if not self.loaded or not vim.api.nvim_win_is_valid(self.win) then
		if not self.buf or not vim.api.nvim_buf_is_valid(self.buf) then
			-- Create a buffer
			self.buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_set_option_value("bufhidden", "hide", { buf = self.buf })
			vim.api.nvim_set_option_value("filetype", "terminal", { buf = self.buf })
		end

		-- Create a window
		self.win = vim.api.nvim_open_win(self.buf, true, {
			border = "rounded",
			relative = "editor",
			style = "minimal",
			height = math.ceil(vim.o.lines * 1.0),
			width = math.ceil(vim.o.columns * 0.45),
			row = 0, --> Top of the window
			col = math.ceil(vim.o.columns * 1.0), --> Far right; should add up to 1 with win_width
			focusable = true,
		})

		vim.api.nvim_set_option_value("winblend", 0, { win = self.win }) --> Semi transparent buffer
		-- Buffer-local Keymaps
		local keymaps_opts = { silent = true, buffer = self.buf }
		vim.keymap.set("n", "<ESC>", function()
			Launch_floatterm(1)
		end, keymaps_opts)
		vim.keymap.set("n", "q", function()
			Launch_floatterm(1)
		end, keymaps_opts)
	else
		vim.api.nvim_win_hide(self.win)
	end
	self.loaded = not self.loaded
end

function Launch_floatterm(idx)
	M.Terminals[idx]:toggle()
end

function M.init()
	table.insert(M.Terminals, Floatterm:new())
	vim.keymap.set({ "n", "t" }, "<F12>", function()
		Launch_floatterm(1)
	end, { desc = "Toggle floatterm" })
end

function Embad_floatterm()
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)
	local cursor = vim.api.nvim_win_get_cursor(win)

	vim.api.nvim_win_close(win, true)
	vim.api.nvim_set_current_buf(buf)
	vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), cursor)
end

vim.keymap.set("n", "<lt>ef", Embad_floatterm, { noremap = true, silent = true })

M.init()
