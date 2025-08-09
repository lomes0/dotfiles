vim.opt.fillchars = { eob = " " }

vim.opt.completeopt = { "noinsert", "noselect" }

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
		"<C-Enter>",
		[[<C-\><C-n>]],
		desc = "Exit terminal mode",
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
		desc = "Next tab",
	},
	{
		"t",
		"<c-s-tab>",
		"<c-\\><c-n><cmd>tabprev<cr>",
		desc = "Prev tab",
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

local M = {}

function M.move_floating_window(win_id, a, b)
	local config = vim.api.nvim_win_get_config(win_id)
	config.row = config.row + a
	config.col = config.col + b
	vim.api.nvim_win_set_config(win_id, config)
end

function M.bufdir()
	return vim.api.nvim_buf_get_name(0):match("(.*/)")
end

function M.gitroot(dir)
	if dir == nil then
		return nil
	end

	while dir and dir ~= "/" do
		if vim.uv.fs_stat(dir .. "/.git") ~= nil then
			return dir
		end
		dir = vim.fn.fnamemodify(dir, ":h") -- Move up one directory
	end
	return nil
end

local function thisdir()
	return "./"
end

local function set_cwd()
	local dir = M.bufdir() or vim.fn.getcwd(-1, -1)
	vim.cmd("cd " .. (M.gitroot(dir) or M.bufdir() or thisdir()))
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
	local gitdir = M.gitroot(M.bufdir())
	if gitdir == nil then
		print("Not a git repo")
		return
	end

	local term_win = vim.api.nvim_get_current_win()
	local prev_buf = vim.api.nvim_get_current_buf()
	local term_buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_win_set_buf(term_win, term_buf)
	vim.fn.termopen("lazygit -w=" .. gitdir, {
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

local api = vim.api
local autocmd = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

local g = augroup("user/keep_yank_position", { clear = true })

autocmd("ModeChanged", {
	pattern = { "n:no", "no:n" },
	group = g,
	callback = function(ev)
		if vim.v.operator == "y" then
			if ev.match == "n:no" then
				vim.b.user_yank_last_pos = vim.fn.getpos(".")
			else
				if vim.b.user_yank_last_pos then
					vim.fn.setpos(".", vim.b.user_yank_last_pos)
					vim.b.user_yank_last_pos = nil
				end
			end
		end
	end,
})

autocmd("ModeChanged", {
	pattern = {
		"V:n",
		"n:V",
		"v:n",
		"n:v",
	},
	group = g,
	callback = function(ev)
		local match = ev.match
		if vim.tbl_contains({ "n:V", "n:v" }, match) then
			-- vim.b.user_yank_last_pos = vim.fn.getpos(".")
			vim.b.user_yank_last_pos = vim.api.nvim_win_get_cursor(0)
		else
			-- if vim.tbl_contains({ "V:n", "v:n" }, match) then
			if vim.v.operator == "y" then
				local last_pos = vim.b.user_yank_last_pos
				if last_pos then
					-- vim.fn.setpos(".", last_pos)
					vim.api.nvim_win_set_cursor(0, last_pos)
				end
			end
			vim.b.user_yank_last_pos = nil
			-- end
		end
	end,
})

-- Set the commentstring for C++ files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cpp", "c", "cc", "h", "hpp", "rust" },
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})

vim.keymap.set("n", "A", function()
	local filepath = vim.fn.expand("%:p")
	if filepath == "" then
		print("No file to commit")
		return
	end

	vim.cmd("silent! write") -- Save the buffer
	-- vim.fn.system("git add " .. vim.fn.shellescape(filepath))
	vim.fn.system("git commit --amend --no-edit")

	print("Amended last commit with changes from " .. filepath)
end, { noremap = true, silent = true })

vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = require("vim.ui.clipboard.osc52").paste("+"),
		["*"] = require("vim.ui.clipboard.osc52").paste("*"),
	},
}

vim.api.nvim_create_user_command("RemoveSnacksNotifWindows", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local type = vim.bo[buf].filetype
		if type == "snacks.notif" or type == "snacks_notif" then
			vim.api.nvim_win_close(win, true)
		end
	end
end, {})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ft = args.match
		local blacklist = { "qf", "calltree", "CsStackView" }
		if not vim.tbl_contains(blacklist, ft) then
			vim.wo.signcolumn = "yes"
			vim.o.statuscolumn = "%!v:lua.require('statuscolumn').statuscolumn()"
		else
			vim.wo.statuscolumn = "   "
		end
	end,
})

vim.keymap.set("n", "<leader>e", function()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local node = ts_utils.get_node_at_cursor()

	while node do
		local type = node:type()
		if
			vim.tbl_contains(
				{ "function_definition", "if_statement", "for_statement", "while_statement", "block" },
				type
			)
		then
			local _, _, end_row, _ = node:range()
			vim.api.nvim_win_set_cursor(0, { end_row + 1, 0 }) -- go to start of line after block end
			return
		end
		node = node:parent()
	end
end, { desc = "Go to end of current block" })

vim.lsp.enable({ "clangd", "pylsp", "tsserver", "rust-analyzer" })

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		vim.keymap.set("n", "gi", function()
			vim.api.nvim_exec("lua vim.lsp.buf.incoming_calls()", false)
			vim.defer_fn(function()
				vim.api.nvim_exec("LTOpenToCalltree", false)
			end, 10)
		end, opts)
		vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		vim.keymap.set("n", "gca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	end,
})

local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
		if not client or type(value) ~= "table" then
			return
		end
		local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
					token = ev.data.params.token,
					msg = ("[%3d%%] %s%s"):format(
						value.kind == "end" and 100 or value.percentage or 100,
						value.title or "",
						value.message and (" **%s**"):format(value.message) or ""
					),
					done = value.kind == "end",
				}
				break
			end
		end

		local msg = {} ---@type string[]
		progress[client.id] = vim.tbl_filter(function(v)
			return table.insert(msg, v.msg) or not v.done
		end, p)

		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(table.concat(msg, "\n"), 0, {
			id = "lsp_progress",
			title = client.name,
			opts = function(notif)
				notif.icon = #progress[client.id] == 0 and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client:supports_method("textDocument/documentHighlight") then
			local autocmd = vim.api.nvim_create_autocmd
			local augroup = vim.api.nvim_create_augroup("lsp_highlight", { clear = false })

			vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup })

			autocmd({ "CursorHold" }, {
				group = augroup,
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			autocmd({ "CursorMoved" }, {
				group = augroup,
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end

		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end

		if client:supports_method("textDocument/completion") then
			-- Enable native completion for Neovim 0.11+
			local ok, completion = pcall(function()
				return vim.lsp.completion
			end)
			if ok and completion and completion.enable then
				completion.enable(true, client.id, args.buf, { autotrigger = true })
			else
				-- Fallback: enable omnifunc for older API
				vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
			end
		end

		vim.diagnostic.config({ virtual_text = { current_line = true } })
	end,
})
