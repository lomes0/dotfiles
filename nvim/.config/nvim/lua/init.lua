vim.opt.fillchars = { eob = " " }

vim.loader.enable()

local opts = {
	{ "backup", true },
	{ "writebackup", false },
	{ "swapfile", false },
	{ "guifont", "Hack" },
	{ "autowriteall", true },
	{ "tabstop", 4 },
	{ "softtabstop", 4 },
	{ "shiftwidth", 4 },
	{ "scrolloff", 8 },
	{ "updatetime", 50 },
	{ "timeoutlen", 300 },
	{ "conceallevel", 2 },
	{ "report", 999 },
	{ "cmdheight", 0 },
	{ "numberwidth", 8 },
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
	{ "encoding", "UTF-8" },
	{ "undodir", os.getenv("HOME") .. "/.vim/undodir" },
}

local keymaps_noremap = {
	{
		{ "n", "v", "x" },
		"W",
		"4w",
		desc = "3xw",
	},
	{
		{ "n", "v" },
		"x",
		'"_x',
		desc = "Delete into void register",
	},
	{
		{ "v" },
		"p",
		'"_xP',
		desc = "Delete into void register",
	},
}

local move_floating_window_scale = 4

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
		"n",
		"_",
		function()
			if vim.opt.clipboard:get()[1] == "unnamedplus" then
				vim.opt.clipboard = ""
				_G.clipboard_icon = ""
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
		"<F4>",
		"<cmd>tabnew<cr>",
		desc = "Tab new",
	},
	{
		"n",
		"<F3>",
		"<cmd>tabclose<cr>",
		desc = "Tab close",
	},
	{
		"n",
		"<c-tab>",
		"<cmd>tabnext<cr>",
		desc = "Tab next",
	},
	{
		"n",
		"<c-s-tab>",
		"<cmd>tabprev<cr>",
		desc = "Tab prev",
	},
	{
		"t",
		"<c-\\>",
		function()
			Snacks.terminal.toggle()
		end,
		desc = "Toggle float term",
	},
	{
		"t",
		"<c-tab>",
		"<c-\\><c-n><cmd>tabnext<cr>",
		desc = "next tab",
	},
	{
		"t",
		"<c-s-tab>",
		"<c-\\><c-n><cmd>tabprev<cr>",
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
	-- {
	-- 	"t",
	-- 	"<C-_>",
	-- 	"<C-\\><C-n>/",
	-- 	desc = "Terminal search buffer",
	-- },
	{
		"t",
		"<C-;>",
		"<C-\\><C-n>",
		desc = "Terminal command",
	},
	{
		"n",
		"Q",
		"<cmd>qa<cr>",
		desc = "Close neovim",
	},
	-- {
	-- 	"n",
	-- 	"<left>",
	-- 	function()
	-- 		Move_floating_window(vim.api.nvim_get_current_win(), 0, -1 * move_floating_window_scale)
	-- 	end,
	-- 	desc = "Move floating window left",
	-- },
	-- {
	-- 	"n",
	-- 	"<up>",
	-- 	function()
	-- 		Move_floating_window(vim.api.nvim_get_current_win(), -1 * move_floating_window_scale, 0)
	-- 	end,
	-- 	desc = "Moving floating window up",
	-- },
	-- {
	-- 	"n",
	-- 	"<down>",
	-- 	function()
	-- 		Move_floating_window(vim.api.nvim_get_current_win(), move_floating_window_scale, 0)
	-- 	end,
	-- 	desc = "Moving floating window down",
	-- },
	-- {
	-- 	"n",
	-- 	"<right>",
	-- 	function()
	-- 		Move_floating_window(vim.api.nvim_get_current_win(), 0, move_floating_window_scale)
	-- 	end,
	-- 	desc = "Moving floating window right",
	-- },
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
		vim.opt_local.statuscolumn = ""
	end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "BufEnter", "TermOpen", "TermEnter" }, {
	pattern = "term://*",
	callback = function()
		vim.cmd("startinsert")
	end,
})

register_opts(opts)
register_keymaps(keymaps, true)
register_keymaps(keymaps_noremap, false)

set_cwd()

vim.keymap.set({ "n", "x" }, "<lt>gg", function()
	local term_win = vim.api.nvim_get_current_win()
	local prev_buf = vim.api.nvim_get_current_buf()
	local term_buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_win_set_buf(term_win, term_buf)
	vim.fn.termopen("lazygit", {
		on_exit = function()
			-- First ensure the buffer is still valid, then delete it.
			vim.api.nvim_win_set_buf(term_win, prev_buf)
			if vim.api.nvim_buf_is_valid(term_buf) then
				vim.api.nvim_buf_delete(term_buf, { force = true })
			end
		end,
	})
end)

vim.keymap.set({ "n", "x" }, "-", function()
	Snacks.notifier.hide()
	require("notify").dismiss({ silent = true, pending = true })
end)
