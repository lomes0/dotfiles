local M = {}

M.Terminals = {}

local Floatterm = {}
Floatterm.__index = Floatterm

function Floatterm:new()
	local term = {
		loaded = nil,
		buf = nil,
		win = nil,
		job_id = nil,
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

			-- Start terminal job in the buffer
			vim.api.nvim_buf_call(self.buf, function()
				self.job_id = vim.fn.jobstart(vim.o.shell, {
					term = true,
				})
			end)
		end

		-- Calculate centered window position
		local win_height = math.ceil(vim.o.lines * 0.85)
		local win_width = math.ceil(vim.o.columns * 0.85)
		local row = math.ceil((vim.o.lines - win_height) / 2)
		local col = math.ceil((vim.o.columns - win_width) / 2)

		-- Create a window
		self.win = vim.api.nvim_open_win(self.buf, true, {
			border = "rounded",
			relative = "editor",
			style = "minimal",
			height = win_height,
			width = win_width,
			row = row,
			col = col,
			focusable = true,
		})

		vim.api.nvim_set_option_value("winblend", 0, { win = self.win })

		-- Buffer-local Keymaps
		local keymaps_opts = { silent = true, buffer = self.buf }
		vim.keymap.set("t", "<ESC>", function()
			Launch_floatterm(1)
		end, keymaps_opts)
		vim.keymap.set("n", "<ESC>", function()
			Launch_floatterm(1)
		end, keymaps_opts)
		vim.keymap.set("n", "q", function()
			Launch_floatterm(1)
		end, keymaps_opts)

		self.loaded = true

		-- Enter terminal mode automatically
		vim.cmd("startinsert")
	else
		vim.api.nvim_win_close(self.win, true)
		self.win = nil
		self.loaded = false
	end
end

function Launch_floatterm(idx)
	if M.Terminals[idx] then
		M.Terminals[idx]:toggle()
	else
		vim.notify("Terminal " .. idx .. " not found", vim.log.levels.ERROR)
	end
end

function M.init()
	-- Create the first terminal instance
	table.insert(M.Terminals, Floatterm:new())

	-- Set up keymaps
	vim.keymap.set({ "n", "t" }, "<F12>", function()
		Launch_floatterm(1)
	end, { desc = "Toggle floating terminal" })
end

-- Add method to create additional terminals
function M.new_terminal()
	table.insert(M.Terminals, Floatterm:new())
	return #M.Terminals
end

-- Add method to get terminal count
function M.count()
	return #M.Terminals
end

-- Initialize the module
M.init()

return M
