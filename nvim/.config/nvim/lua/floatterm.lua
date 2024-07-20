local M = {}

M.Terminals = {}

Floatterm = {}
Floatterm.__index = Floatterm

function Floatterm:new()
	local term = {
		loaded = nil,
		buf = nil,
		win = nil,
		-- pos = {
		-- 	x = nil,
		-- 	y = nil,
		-- 	width = nil,
		-- 	height = nil,
		-- }
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
			-- vim.api.nvim_buf_set_lines(self.buf, 0, 1, false, {
			--   "# Notepad",
			--   "",
			--   "> Notepad clears when the current Neovim session closes",
			-- })
		end
		-- Create a window
		self.win = vim.api.nvim_open_win(self.buf, true, {
			border = "rounded",
			relative = "editor",
			style = "minimal",
			height = math.ceil(vim.o.lines * 0.35),
			width = math.ceil(vim.o.columns * 0.35),
			row = 0, --> Top of the window
			col = math.ceil(vim.o.columns * 0.65), --> Far right; should add up to 1 with win_width
		})
		-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#303446", fg = "#303446" })

		vim.api.nvim_set_option_value("winblend", 0, { win = self.win }) --> Semi transparent buffer
		-- Buffer-local Keymaps
		local keymaps_opts = { silent = true, buffer = self.buf }
		vim.keymap.set("n", "<ESC>", function()
			Launch_floatterm()
		end, keymaps_opts)
		vim.keymap.set("n", "q", function()
			Launch_floatterm()
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
	for i = 1, 4 do
		table.insert(M.Terminals, Floatterm:new())
		vim.keymap.set("n", ";" .. i, function()
			Launch_floatterm(i)
		end, { desc = "Toggle floatterm " .. i })
	end
end

return M
