vim.g.mapleader = "<"
vim.o.autowriteall = true
vim.o.guifont = "Hack"
local move_floating_window_scale = 4
_G.clipboard_icon = "📔"

-- Neovide
if vim.g.neovide then
	vim.g.neovide_position_animation_length = 0
	vim.g.neovide_cursor_animation_length = 0.00
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_cursor_animate_in_insert_mode = false
	vim.g.neovide_cursor_animate_command_line = false
	vim.g.neovide_scroll_animation_far_lines = 0
	vim.g.neovide_scroll_animation_length = 0.00

	vim.g.neovide_transparency = 0.9 -- Adjust transparency level
	vim.g.neovide_background_color = "#1e1e1e" -- Set a background color to prevent transparency issues
	-- vim.g.neovide_cursor_vfx_mode = "railgun" -- Try different effects to check if they affect color

	vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
	vim.keymap.set("v", "<D-c>", '"+y') -- Copy
	vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
	vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
	vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
	vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

	vim.g.terminal_color_0 = "#000000" -- black
	vim.g.terminal_color_1 = "#ff5555" -- red
	vim.g.terminal_color_2 = "#50fa7b" -- green
	vim.g.terminal_color_3 = "#f1fa8c" -- yellow
	vim.g.terminal_color_4 = "#bd93f9" -- blue
	vim.g.terminal_color_5 = "#ff79c6" -- magenta
	vim.g.terminal_color_6 = "#8be9fd" -- cyan
	vim.g.terminal_color_7 = "#bbbbbb" -- white
	vim.g.terminal_color_8 = "#44475a" -- bright black (grey)
	vim.g.terminal_color_9 = "#ff6e6e" -- bright red
	vim.g.terminal_color_10 = "#69ff94" -- bright green
	vim.g.terminal_color_11 = "#ffffa5" -- bright yellow
	vim.g.terminal_color_12 = "#d6acff" -- bright blue
	vim.g.terminal_color_13 = "#ff92df" -- bright magenta
	vim.g.terminal_color_14 = "#a4ffff" -- bright cyan
	vim.g.terminal_color_15 = "#ffffff" -- bright white
end

local opts = {
	{ "tabstop", 4 },
	{ "softtabstop", 4 },
	{ "shiftwidth", 4 },
	{ "scrolloff", 10 },
	{ "updatetime", 50 },
	{ "conceallevel", 2 },
	{ "report", 999 },
	{ "cmdheight", 0 },
	{ "title", true },
	{ "showcmd", true },
	{ "smartindent", true },
	{ "autoindent", true },
	{ "breakindent", true },
	{ "expandtab", false },
	{ "swapfile", false },
	{ "backup", false },
	{ "wrap", false },
	{ "undofile", true },
	{ "incsearch", true },
	{ "hlsearch", true },
	{ "nu", true },
	{ "relativenumber", true },
	{ "exrc", true },
	{ "termguicolors", true },
	{ "ignorecase", false },
	{ "ea", false },
	{ "winfixwidth", false },
	{ "winfixheight", false },
	{ "signcolumn", "number" },
	{ "guicursor", "n-v-c-i:block" },
	{ "encoding", "UTF-8" },
	{ "guicursor", "" },
	{ "undodir", os.getenv("HOME") .. "/.vim/undodir" },
}

local keymaps_noremap = {
	{
		{ "n", "v" },
		";d",
		'"_x',
		desc = "Delete into void register",
	},
}

local keymaps = {
	{
		"v",
		"<C-c>",
		"<Esc>",
		desc = "Visual mode escape",
	},
	{
		"v",
		"/",
		function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gc", true, false, true), "x", false)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gv", true, false, true), "x", false)
		end,
		noremap = true,
		desc = "Nvim init.lua",
	},
	{
		"n",
		"cc",
		function(_)
			vim.api.nvim_command("cd ~/.config/nvim/lua/")
			vim.api.nvim_command([[edit ~/.config/nvim/lua/init.lua]])
		end,
		desc = "Nvim init.lua",
	},
	{
		"n",
		"<C-d>",
		"<C-d>zz",
		desc = "Move cursor down",
	},
	{
		"n",
		"<C-u>",
		"<C-u>zz",
		desc = "Move cursor up",
	},
	{
		"n",
		"n",
		"nzzzv",
		desc = "Search and recenter cursor",
	},
	{
		"n",
		"N",
		"Nzzzv",
		desc = "Search and recenter cursor",
	},
	{
		"n",
		"<lt>w",
		function()
			vim.api.nvim_command("cd " .. vim.api.nvim_buf_get_name(0):match("(.*/)"))
		end,
		desc = "Editor change workdir",
	},
	{
		"n",
		"<C-a>",
		"gg<S-v>G",
		desc = "Editor select all",
	},
	{
		"v",
		"J",
		":m '>+1<cr>gv=gv",
		desc = "Editor move lines up",
	},
	{
		"v",
		"K",
		":m '<-2<cr>gv=gv",
		desc = "Editor move lines down",
	},
	{
		"v",
		"<C-c>",
		'"+y',
		desc = "copy to system clipboard",
	},
	{
		"n",
		"-",
		function()
			if vim.opt.clipboard:get()[1] == "unnamedplus" then
				vim.opt.clipboard = ""
				_G.clipboard_icon = "📔"
			else
				vim.opt.clipboard = "unnamedplus"
				_G.clipboard_icon = "💻"
			end
		end,
		desc = "copy to system clipboard",
	},
	{
		"v",
		"y",
		"ygv<esc>",
		desc = "yank and keep cursor",
	},
	{
		"n",
		"<tab>",
		"<cmd>tabnext<cr>",
		desc = "next tab",
	},
	{
		"n",
		"<s-tab>",
		"<cmd>tabprev<cr>",
		desc = "prev tab",
	},
	{
		"n",
		"<lt>v",
		"<cmd>vsplit<cr><C-\\><C-n><C-w>l<cmd>enew<cr>",
		desc = "Pane split vertical",
	},
	{
		"n",
		"<lt>s",
		"<cmd>split<cr><C-\\><C-n><C-w>j<cmd>enew<cr>",
		desc = "Pane split horizontal",
	},
	{
		"t",
		"<C-h>",
		"<C-\\><C-n><C-w>h",
		desc = "Window move left",
	},
	{
		"t",
		"<C-j>",
		"<C-\\><C-n><C-w>j",
		desc = "Window move down",
	},
	{
		"t",
		"<C-k>",
		"<C-\\><C-n><C-w>k",
		desc = "Window move up",
	},
	{
		"t",
		"<C-l>",
		"<C-\\><C-n><C-w>l",
		desc = "Window move right",
	},
	{
		"t",
		"<C-w>h",
		"<C-\\><C-n><C-w>h",
		desc = "Window move left",
	},
	{
		"t",
		"<C-w>j",
		"<C-\\><C-n><C-w>j",
		desc = "Window move down",
	},
	{
		"t",
		"<C-w>k",
		"<C-\\><C-n><C-w>k",
		desc = "Window move up",
	},
	{
		"t",
		"<C-w>l",
		"<C-\\><C-n><C-w>l",
		desc = "Window move right",
	},
	{
		"n",
		"<c-left>",
		"<C-w><",
		desc = "Window resize left",
	},
	{
		"n",
		"<c-right>",
		"<C-w>>",
		desc = "Window resize right",
	},
	{
		"n",
		"<c-up>",
		"<C-w>-",
		desc = "Window resize up",
	},
	{
		"n",
		"<c-down>",
		"<C-w>+",
		desc = "Window resize down",
	},
	{
		"n",
		"tt",
		function()
			vim.api.nvim_command("term")
			vim.api.nvim_set_option_value("scrolloff", 0, { scope = "local" })
		end,
		desc = "Terminal open",
	},
	{
		"t",
		"<C-w>",
		"<C-\\><C-n><C-w>",
		desc = "Terminal window cmd",
	},
	{
		"t",
		"<C-_>",
		"<C-\\><C-n>/",
		desc = "Terminal search buffer",
	},
	{
		"t",
		":",
		"<C-\\><C-n>:",
		desc = "Terminal command",
	},
	{
		"t",
		"<C-f>",
		"<C-\\><C-n>",
		desc = "Terminal escape",
	},
	{
		"n",
		"<lt>q",
		function()
			Window_remove_active_buffer()
		end,
		desc = "Remove active buffer",
	},
	{
		"t",
		"<lt>q",
		function()
			Window_remove_active_buffer()
		end,
		desc = "Remove active buffer",
	},
	{
		"n",
		"Q",
		"<cmd>qa<cr>",
		desc = "Close neovim",
	},
	{
		"n",
		"<left>",
		function()
			Move_floating_window(vim.api.nvim_get_current_win(), 0, -1 * move_floating_window_scale)
		end,
		desc = "Move floating window left",
	},
	{
		"n",
		"<up>",
		function()
			Move_floating_window(vim.api.nvim_get_current_win(), -1 * move_floating_window_scale, 0)
		end,
		desc = "Moving floating window up",
	},
	{
		"n",
		"<down>",
		function()
			Move_floating_window(vim.api.nvim_get_current_win(), move_floating_window_scale, 0)
		end,
		desc = "Moving floating window down",
	},
	{
		"n",
		"<right>",
		function()
			Move_floating_window(vim.api.nvim_get_current_win(), 0, move_floating_window_scale)
		end,
		desc = "Moving floating window right",
	},
}

local function register_opts(opts_array)
	for _, e in ipairs(opts_array) do
		vim.api.nvim_set_option_value(e[1], e[2], {})
	end
end

local function register_keymaps(maps_array, noremap)
	for _, entry in ipairs(maps_array) do
		vim.keymap.set(entry[1], entry[2], entry[3], {
			noremap = noremap,
			silent = true,
			desc = entry["desc"],
		})
	end
end

function buffer_remove(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local startwin = vim.api.nvim_get_current_win()

	if not vim.api.nvim_buf_is_valid(bufnr) then
		print("buffer does not exists")
		return
	end

	local window = vim.fn.win_findbuf(bufnr)

	for _, win in ipairs(window) do
		vim.api.nvim_set_current_win(win)
		vim.cmd("bnext")
		if vim.api.nvim_get_current_buf() == bufnr then
			vim.cmd("enew")
		end
	end

	vim.cmd("bdelete " .. bufnr)
	vim.api.nvim_set_current_win(startwin)
end

function Window_remove_active_buffer()
	local bufnr = vim.api.nvim_get_current_buf()
	local bufwin = vim.api.nvim_get_current_win()
	local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })

	if buftype == "terminal" then
		vim.cmd("enew")
		vim.cmd("bdelete! " .. bufnr)
		return
	end

	local window = vim.fn.win_findbuf(bufnr)
	local can_remove = true

	for _, win in ipairs(window) do
		vim.api.nvim_set_current_win(win)
		-- buf is present in other window
		if (bufwin ~= win) and (bufnr == vim.api.nvim_get_current_buf()) then
			can_remove = false
			break
		end
	end

	if can_remove then
		buffer_remove(bufnr)
	else
		vim.api.nvim_set_current_win(bufwin)
		vim.cmd("enew")
	end
end

function Move_floating_window(win_id, a, b)
	local config = vim.api.nvim_win_get_config(win_id)
	config.row = config.row + a
	config.col = config.col + b
	vim.api.nvim_win_set_config(win_id, config)
end

local function cwd_dir()
	return vim.api.nvim_buf_get_name(0):match("(.*/)")
end

local function set_cwd()
	vim.api.nvim_command("cd " .. (cwd_dir() or "./"))
end

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "BufEnter", "TermOpen", "TermEnter" }, {
	pattern = "term://*",
	callback = function()
		vim.cmd("startinsert")
	end,
})

vim.loader.enable()
register_opts(opts)
register_keymaps(keymaps, true)
register_keymaps(keymaps_noremap, false)

require("lazy_vim")
require("folding").init()
require("floatterm").init()
require("colors").init()
require("colors").SetKan()
set_cwd()
