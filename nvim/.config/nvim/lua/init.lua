vim.opt.fillchars = { eob = " " }

vim.opt.completeopt = { "noinsert", "noselect" }

vim.loader.enable()

-- Load Snacks module for terminal functionality
local Snacks = require("snacks")

local opts = {
	{ "backup", true },
	{ "writebackup", false },
	{ "swapfile", false },
	{ "guifont", "Hack" },
	{ "autowriteall", true },
	{ "tabstop", 4 },
	{ "softtabstop", 4 },
	{ "shiftwidth", 4 },
	{ "scrolloff", 4 },
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
	{ "encoding", "UTF-8" },
	{ "undodir", os.getenv("HOME") .. "/.vim/undodir" },
}

local keymaps_noremap = {
	-- {
	-- 	{ "n", "v", "x" },
	-- 	"B",
	-- 	function()
	-- 		vim.fn.search('\\S\\{2,\\}', 'bW')
	-- 	end,
	-- 	desc = "Jump to previous word skipping single chars",
	-- },
	-- {
	-- 	{ "n", "v", "x" },
	-- 	"W",
	-- 	function()
	-- 		vim.fn.search('\\S\\{2,\\}', 'W')
	-- 	end,
	-- 	desc = "Jump to next word skipping single chars",
	-- },
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
		"-",
		function()
			local content = vim.fn.getreg('"')
			if content and content ~= "" then
				vim.fn.setreg("+", content)
				print(string.format("Copied %d characters to system clipboard", #content))
			end
		end,
		desc = "copy default register to system clipboard",
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

-- Setup environment for nvim-remote communication
local function setup_nvim_env()
	local env = vim.fn.environ()

	-- Ensure we have a server running
	local server_name = vim.v.servername
	if not server_name or server_name == "" then
		-- Create a server if none exists
		local socket_path = vim.fn.stdpath("run") .. "/nvim_" .. vim.fn.getpid() .. ".sock"
		vim.fn.serverstart(socket_path)
		server_name = socket_path
	end

	-- Set environment variables for nvim-remote communication
	env.NVIM = server_name
	env.NVIM_LISTEN_ADDRESS = server_name -- For compatibility with older tools

	-- Configure editors to use remote editing
	local nvim_remote_cmd = string.format("nvim --server %s --remote-silent", vim.fn.shellescape(server_name))
	env.EDITOR = nvim_remote_cmd
	env.GIT_EDITOR = nvim_remote_cmd
	env.VISUAL = nvim_remote_cmd

	-- Set lazygit-specific environment if needed
	env.LG_CONFIG_FILE = vim.fn.expand("~/.config/lazygit/config.yml")

	return env
end

vim.keymap.set({ "n", "x" }, "<lt>gg", function()
	local dir = M.bufdir() or vim.fn.getcwd()
	local gitdir = M.gitroot(dir)
	if gitdir == nil then
		print("Not a git repo")
		return
	end

	-- Capture the current buffer, window, and tab before opening lazygit
	local prev_buf = vim.api.nvim_get_current_buf()
	local prev_win = vim.api.nvim_get_current_win()
	local prev_tab = vim.api.nvim_get_current_tabpage()

	-- Create a terminal buffer but don't switch to it yet
	local term_buf = vim.api.nvim_create_buf(false, true)

	-- Build command + env
	local cmd = { "lazygit", "-w=" .. gitdir }
	local env = setup_nvim_env()

	-- Start lazygit in the terminal buffer
	local job
	vim.api.nvim_buf_call(term_buf, function()
		job = vim.fn.jobstart(cmd, {
			term = true,
			env = env,
			on_exit = function(_, code, _)
				if code == 0 then
					vim.schedule(function()
						local current_tab = vim.api.nvim_get_current_tabpage()

						-- Switch back to the original window and buffer
						if vim.api.nvim_win_is_valid(prev_win) then
							vim.api.nvim_set_current_win(prev_win)

							-- Make sure we're showing the original buffer
							if vim.api.nvim_buf_is_valid(prev_buf) then
								vim.api.nvim_win_set_buf(prev_win, prev_buf)
							end
						end

						-- Clean up the terminal buffer
						if vim.api.nvim_buf_is_valid(term_buf) then
							vim.api.nvim_buf_delete(term_buf, { force = true })
						end

						if current_tab ~= prev_tab then
							-- Different tab: handle tab switching as before
							if vim.api.nvim_tabpage_is_valid(prev_tab) then
								vim.api.nvim_set_current_tabpage(prev_tab)
								vim.cmd("tabclose")
								if vim.api.nvim_tabpage_is_valid(current_tab) then
									vim.api.nvim_set_current_tabpage(current_tab)
								end
							end
						end
					end)
				end
			end,
		})
	end)

	if type(job) ~= "number" or job <= 0 then
		print("Failed to start lazygit terminal")
		if vim.api.nvim_buf_is_valid(term_buf) then
			vim.api.nvim_buf_delete(term_buf, { force = true })
		end
		return
	end

	-- Now switch the current window to show the terminal buffer
	vim.api.nvim_win_set_buf(prev_win, term_buf)

	-- Reduce visual noise in the terminal buffer
	vim.api.nvim_set_option_value("scrolloff", 0, { scope = "local" })
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

-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
-- 	callback = function()
-- 		local bufname = vim.api.nvim_buf_get_name(0)
-- 		if bufname:match("NvimTree_") then
-- 			vim.wo.statuscolumn = "  "
-- 			vim.wo.signcolumn = "no"
-- 			vim.wo.numberwidth = 1
-- 		end
-- 	end,
-- })

vim.wo.signcolumn = "yes"
vim.wo.statuscolumn = "%!v:lua.require('statuscolumn').statuscolumn()"
vim.wo.numberwidth = 8

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

vim.lsp.enable({ "clangd", "pylsp", "tsserver", "rust-analyzer", "lua_ls" })

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local lsp_opts = { buffer = event.buf }

		vim.keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.hover()<cr>", lsp_opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", lsp_opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", lsp_opts)
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", lsp_opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", lsp_opts)
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", lsp_opts)
		vim.keymap.set("n", "gi", function()
			vim.lsp.buf.incoming_calls()
			vim.defer_fn(function()
				vim.cmd("LTOpenToCalltree")
			end, 10)
		end, lsp_opts)
		vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", lsp_opts)
		vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", lsp_opts)
		vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", lsp_opts)
		vim.keymap.set("n", "gca", "<cmd>lua vim.lsp.buf.code_action()<cr>", lsp_opts)
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

		if client == nil then
			return
		end

		if client:supports_method("textDocument/documentHighlight") then
			local lsp_highlight = vim.api.nvim_create_augroup("lsp_highlight", { clear = false })

			vim.api.nvim_clear_autocmds({ buffer = args.buf, group = lsp_highlight })

			vim.api.nvim_create_autocmd({ "CursorHold" }, {
				group = lsp_highlight,
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved" }, {
				group = lsp_highlight,
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end

		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
		end

		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
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

-- Keep caret position when leaving insert
vim.keymap.set("i", "<Esc>", function()
	local col = vim.fn.col(".")
	local last = vim.fn.col("$") - 1
	return (col <= last) and "<Esc>l" or "<Esc>"
end, { expr = true, silent = true })

-- Do the same for Ctrl-[ (same as Esc)
vim.keymap.set("i", "<C-[>", function()
	local col = vim.fn.col(".")
	local last = vim.fn.col("$") - 1
	return (col <= last) and "<Esc>l" or "<Esc>"
end, { expr = true, silent = true })

-- Set custom cursor appearance for better theme integration
vim.opt.guicursor = table.concat({
	"n-v-c-sm:blink20", -- blink in normal/visual/cmd
	"i-ci-ve:ver25", -- vertical bar in insert & select
	"r-cr-o:hor20", -- thin underline in replace/op-pending
}, ",")

-- Make insert mode a bit more familiar:
--  - delete prefix word using ctrl-backspace
--  - delete suffix word using ctrl-del
--  - delete entire line using shift-del
--  - delete to end of line using ctrl-k
--  - undo using ctrl-d
vim.keymap.set("i", "<C-BS>", "<C-o>db")
vim.keymap.set("i", "<C-Del>", "<C-o>dw")
vim.keymap.set("i", "<S-Del>", "<C-o>dd")
vim.keymap.set("i", "<C-d>", "<C-o>D")
vim.keymap.set("i", "<C-z>", "<C-o>u")

local smartw = require("smartw")
vim.keymap.set({ "n", "x", "o" }, "W", function()
	smartw.forward(vim.v.count1)
end, { desc = "Smart forward word" })

vim.keymap.set({ "n", "x", "o" }, "B", function()
	smartw.backward(vim.v.count1)
end, { desc = "Smart backward word" })

-- Make Shift+arrows/Home/End/PgUp/PgDn start/extend selection
vim.opt.keymodel = { "startsel", "stopsel" }

-- Use Select mode so typing replaces the selection (like most editors)
vim.opt.selectmode = { "key" }
