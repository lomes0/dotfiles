--
-- settings
--
vim.g.mapleader = "<"
vim.o.autowriteall = true
vim.o.guifont = "Hack"

local opts = {
	{ "tabstop", 4 },
	{ "softtabstop", 4 },
	{ "shiftwidth", 4 },
	{ "scrolloff", 5 },
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

local keymaps = {
	{
		"n",
		"<C-_>",
		"gcc",
		{ noremap = false, silent = true, desc = "comment line" },
	},
	{
		"v",
		"<C-_>",
		"gc:lua vim.fn.setpos('.', vim.fn.getpos(''>'))<cr>0",
		{ noremap = false, silent = true, desc = "comment selection" },
	},
	{
		"n",
		"<leader>w",
		':lua vim.api.nvim_command("cd " .. vim.api.nvim_buf_get_name(0):match("(.*/)"))<cr>',
		{ noremap = true, silent = true, desc = "Editor change workdir" },
	},
	{
		"n",
		"<C-a>",
		"gg<S-v>G",
		{ noremap = true, silent = true, desc = "Editor select all" },
	},
	{
		"v",
		"J",
		":m '>+1<cr>gv=gv",
		{ noremap = true, silent = true, desc = "Editor move lines up" },
	},
	{
		"v",
		"K",
		":m '<-2<cr>gv=gv",
		{ noremap = true, silent = true, desc = "Editor move lines down" },
	},
	{
		"v",
		"<C-c>",
		'"+y',
		{ noremap = true, silent = true, desc = "copy to system clipboard" },
	},
	{
		"v",
		"y",
		"ygv<esc>",
		{ noremap = true, silent = true, desc = "yank and keep cursor" },
	},
	{
		"n",
		"<tab>",
		"<cmd>tabnext<cr>",
		{ noremap = true, silent = true, desc = "next tab" },
	},
	{
		"n",
		"<s-tab>",
		"<cmd>tabprev<cr>",
		{ noremap = true, silent = true, desc = "prev tab" },
	},
	{
		"n",
		"<leader>v",
		"<cmd>vsplit<cr><C-\\><C-n><C-w>l<cmd>enew<cr>",
		{ noremap = true, silent = true, desc = "Pane split vertical" },
	},
	{
		"n",
		"<leader>s",
		"<cmd>split<cr><C-\\><C-n><C-w>j<cmd>enew<cr>",
		{ noremap = true, silent = true, desc = "Pane split horizontal" },
	},
	{
		"t",
		"<C-h>",
		"<C-\\><C-n><C-w>h",
		{ noremap = true, silent = true, desc = "Window move left" },
	},
	{
		"t",
		"<C-j>",
		"<C-\\><C-n><C-w>j",
		{ noremap = true, silent = true, desc = "Window move down" },
	},
	{
		"t",
		"<C-k>",
		"<C-\\><C-n><C-w>k",
		{ noremap = true, silent = true, desc = "Window move up" },
	},
	{
		"t",
		"<C-l>",
		"<C-\\><C-n><C-w>l",
		{ noremap = true, silent = true, desc = "Window move right" },
	},
	{
		"t",
		"<C-w>h",
		"<C-\\><C-n><C-w>h",
		{ noremap = true, silent = true, desc = "Window move left" },
	},
	{
		"t",
		"<C-w>j",
		"<C-\\><C-n><C-w>j",
		{ noremap = true, silent = true, desc = "Window move down" },
	},
	{
		"t",
		"<C-w>k",
		"<C-\\><C-n><C-w>k",
		{ noremap = true, silent = true, desc = "Window move up" },
	},
	{
		"t",
		"<C-w>l",
		"<C-\\><C-n><C-w>l",
		{ noremap = true, silent = true, desc = "Window move right" },
	},
	{
		"n",
		"<c-left>",
		"<C-w><",
		{ noremap = true, silent = true, desc = "Window resize left" },
	},
	{
		"n",
		"<c-right>",
		"<C-w>>",
		{ noremap = true, silent = true, desc = "Window resize right" },
	},
	{
		"n",
		"<c-up>",
		"<C-w>-",
		{ noremap = true, silent = true, desc = "Window resize up" },
	},
	{
		"n",
		"<c-down>",
		"<C-w>+",
		{ noremap = true, silent = true, desc = "Window resize down" },
	},
	{
		"n",
		"tt",
		":lua Terminal_open()<cr>",
		{ noremap = true, silent = true, desc = "Terminal" },
	},
	{
		"t",
		"<C-w>",
		"<C-\\><C-n><C-w>",
		{ noremap = true, silent = true, desc = "Terminal window cmd" },
	},
	{
		"t",
		"<C-_>",
		"<C-\\><C-n>/",
		{ noremap = true, silent = true, desc = "Terminal search buffer" },
	},
	{
		"t",
		":",
		"<C-\\><C-n>:",
		{ noremap = true, silent = true, desc = "Terminal command" },
	},
	{
		"t",
		"<C-f>",
		"<C-\\><C-n>",
		{ noremap = true, silent = true, desc = "Terminal escape" },
	},
	{
		"n",
		"<leader>q",
		":lua _G.window_remove_active_buffer()<cr>",
		{ noremap = true, silent = true, desc = "Remove active buffer" },
	},
	{
		"n",
		"<C-d>",
		":lua _G.window_remove_active_buffer()<cr>",
		{ noremap = true, silent = true, desc = "Remove active buffer" },
	},
	{
		"t",
		"<leader>q",
		"<C-\\><C-n>:lua _G.window_remove_active_buffer()<cr>",
		{ noremap = true, silent = true, desc = "Remove active buffer" },
	},
	{
		"t",
		"<C-d>",
		"<C-\\><C-n>:lua _G.window_remove_active_buffer()<cr>",
		{ noremap = true, silent = true, desc = "Remove active buffer" },
	},
	{
		"n",
		"Q",
		"<cmd>qa<cr>",
		{ noremap = true, silent = true, desc = "Close neovim" },
	},
	{
		"n",
		"<left>",
		"<cmd>lua _G.move_floating_window_left()<cr>",
		{ noremap = true, silent = true, desc = "Move floating window left" },
	},
	{
		"n",
		"<up>",
		"<cmd>lua _G.move_floating_window_up()<cr>",
		{ noremap = true, silent = true, desc = "Moving floating window up" },
	},
	{
		"n",
		"<down>",
		"<cmd>lua _G.move_floating_window_down()<cr>",
		{ noremap = true, silent = true, desc = "Moving floating window down" },
	},
	{
		"n",
		"<right>",
		"<cmd>lua _G.move_floating_window_right()<cr>",
		{ noremap = true, silent = true, desc = "Moving floating window right" },
	},
}

function RegisterOpts(opts_array)
	for _, e in ipairs(opts_array) do
		vim.api.nvim_set_option_value(e[1], e[2], {})
	end
end

function RegisterKeymaps(maps_array)
	for _, e in ipairs(maps_array) do
		vim.keymap.set(e[1], e[2], e[3], e[4])
	end
end

function Terminal_open()
	vim.api.nvim_command("term")
	vim.api.nvim_set_option_value("scrolloff", 0, { scope = "local" })
end

function _G.buffer_remove(bufnr)
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

function _G.window_remove_active_buffer()
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
		_G.buffer_remove(bufnr)
	else
		vim.api.nvim_set_current_win(bufwin)
		vim.cmd("enew")
	end
end

function _G.move_floating_window(win_id, a, b)
	local config = vim.api.nvim_win_get_config(win_id)
	config.row = config.row + a
	config.col = config.col + b
	vim.api.nvim_win_set_config(win_id, config)
end

function _G.move_floating_window_left()
	move_floating_window(vim.api.nvim_get_current_win(), 0, -4)
end

function _G.move_floating_window_down()
	move_floating_window(vim.api.nvim_get_current_win(), 4, 0)
end

function _G.move_floating_window_up()
	move_floating_window(vim.api.nvim_get_current_win(), -4, 0)
end

function _G.move_floating_window_right()
	move_floating_window(vim.api.nvim_get_current_win(), 0, 4)
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

RegisterOpts(opts)
RegisterKeymaps(keymaps)

require("lazy_vim")
require("colors").init()
require("folding").init()
require("floatterm").init()
