local folderOfThisFile = (...):match("(.-)[^%.]+$")

--
-- settings
--
vim.g.mapleader = "<"
vim.opt.guicursor = ""
-- tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true
-- backup
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.wrap = false
-- search
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.scrolloff = 999
vim.opt.updatetime = 50
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.opt.exrc = true
vim.opt.termguicolors = true
vim.opt.ea = false
vim.opt.winfixwidth = false
vim.opt.winfixheight = false
vim.o.autowriteall = true
vim.opt.conceallevel = 2
vim.opt.report = 999
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.guicursor = "n-v-c-i:block"
vim.o.guifont = "Hack"
vim.opt.encoding='UTF-8'

-- Function to save and restore the cursor position after yank in visual mode
function Preserve_cursor_after_yank()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    vim.cmd('normal! `<y`>')
    vim.fn.setpos('.', end_pos)
    vim.fn.setpos("'<", start_pos)
    vim.fn.setpos("'>", end_pos)
end

--
-- remaps
--
-- comments
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true })
vim.keymap.set('v', '<C-_>', 'gc:lua vim.fn.setpos(".", vim.fn.getpos("\'>"))<cr>0', { remap = true })

-- workdir
-- vim.opt.autochdir = true
vim.keymap.set('n', '<leader>a', ':lua vim.api.nvim_command("cd " .. vim.api.nvim_buf_get_name(0):match("(.*/)"))<cr>', { noremap = true } )

-- move lines
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- copy paste delete
vim.keymap.set({"v", "n"}, "<C-c>", "\"+y", {noremap = true})
vim.api.nvim_set_keymap('x', 'y', ':lua Preserve_cursor_after_yank()<CR>', { noremap = true, silent = true })

-- tabs
vim.keymap.set("n", "<tab>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<s-tab>", "<cmd>tabprev<cr>")

-- panes
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<cr><C-\\><C-n><C-w>l<cmd>enew<cr>", {noremap=true})
vim.keymap.set("n", "<leader>s", "<cmd>split<cr><C-\\><C-n><C-w>j<cmd>enew<cr>",{noremap=true})

-- terminals
vim.keymap.set("n", "tt", ":term<cr>")
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", {noremap = true})
vim.keymap.set("t", "<C-_>", "<C-\\><C-n>/", {noremap = true})
vim.keymap.set("t", ":", "<C-\\><C-n>:", {noremap = true})
vim.keymap.set("t", "<C-f>", "<C-\\><C-n>", {noremap = true})

vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l")

vim.cmd([[
	autocmd TermOpen * setlocal nonumber norelativenumber
	autocmd BufWinEnter,WinEnter,BufEnter,TermOpen,TermEnter term://* startinsert
]])

--
-- folding
--
-- https://essais.co/better-folding-in-neovim/

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.cmd([[
function! EnableFolding()
	set nofoldenable
	set foldlevel=1
	set foldlevel=99
	set foldnestmax=4
	set fillchars=fold:\
	set foldtext=CustomFoldText()
	setlocal foldmethod=expr
	setlocal foldexpr=GetPotionFold(v:lnum)
endfunction

if !&diff
	autocmd VimEnter * call EnableFolding()
endif

function! GetPotionFold(lnum)
	if getline(a:lnum) =~? '\v^\s*$'
		return '-1'
	endif

	let this_indent = IndentLevel(a:lnum)
	let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

	if next_indent == this_indent
		return this_indent
	elseif next_indent < this_indent
		return this_indent
	elseif next_indent > this_indent
		return '>' . next_indent
	endif
endfunction

function! IndentLevel(lnum)
	return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
	let numlines = line('$')
	let current = a:lnum + 1

	while current <= numlines
		if getline(current) =~? '\v\S'
			return current
		endif

		let current += 1
	endwhile

	return -2
endfunction

function! CustomFoldText()
	" get first non-blank line
	let fs = v:foldstart

	while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
	endwhile

	if fs > v:foldend
		let line = getline(v:foldstart)
	else
		let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
	endif

	let foldSize = 1 + v:foldend - v:foldstart
	let foldSizeStr = " " . foldSize . " lines "
	let expansionString = repeat(" ", winwidth(0)-len(line)-len(foldSizeStr)-4)
	return line . expansionString . foldSizeStr
endfunction
]])

--
-- buffer
--
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
		vim.cmd('bnext')
		if vim.api.nvim_get_current_buf() == bufnr then
			vim.cmd('enew')
		end
	end

	vim.cmd('bdelete ' .. bufnr)
	vim.api.nvim_set_current_win(startwin)
end

function _G.window_remove_active_buffer()
	local bufnr = vim.api.nvim_get_current_buf()
	local bufwin = vim.api.nvim_get_current_win()
	local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })

	if buftype == 'terminal' then
		vim.cmd('enew')
		vim.cmd('bdelete! ' .. bufnr)
		return
	end

	local window = vim.fn.win_findbuf(bufnr)
	local can_remove = true

	for _, win in ipairs(window) do
		vim.api.nvim_set_current_win(win)
		-- buf is present in other window
		if ( bufwin ~= win ) and ( bufnr == vim.api.nvim_get_current_buf() ) then
			can_remove = false
			break
		end
	end

	if can_remove then
		_G.buffer_remove(bufnr)
	else
		vim.api.nvim_set_current_win(bufwin)
		vim.cmd('enew')
	end
end

vim.keymap.set("n", "<leader>q", ":lua _G.window_remove_active_buffer()<cr>", { noremap = true })
vim.keymap.set("n", "<C-d>", ":lua _G.window_remove_active_buffer()<cr>", { noremap = true })
vim.keymap.set("t", "<leader>q", "<C-\\><C-n>:lua _G.window_remove_active_buffer()<cr>", { noremap = true })
vim.keymap.set("t", "<C-d>", "<C-\\><C-n>:lua _G.window_remove_active_buffer()<cr>", { noremap = true })

vim.keymap.set("n", "Q", "<cmd>qa<cr>", { noremap = true })

--
-- Floating Panes
--
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

-------------------
-- Floating Windows
-------------------
vim.keymap.set("n", "<left>",  "<cmd>lua _G.move_floating_window_left()<cr>",  {noremap=true})
vim.keymap.set("n", "<up>",    "<cmd>lua _G.move_floating_window_up()<cr>",    {noremap=true})
vim.keymap.set("n", "<down>",  "<cmd>lua _G.move_floating_window_down()<cr>",  {noremap=true})
vim.keymap.set("n", "<right>", "<cmd>lua _G.move_floating_window_right()<cr>", {noremap=true})

--vim.keymap.set("n", "+", "<cmd>vertical resize +5<cr>")
--vim.keymap.set("n", "_", "<cmd>vertical resize -5<cr>")
--vim.keymap.set("n", "=", "<cmd>horizontal resize +5<cr>")
--vim.keymap.set("n", "-", "<cmd>horizontal resize -5<cr>")

vim.keymap.set("n", "<c-left>",  "<C-w><", { noremap = true })
vim.keymap.set("n", "<c-right>", "<C-w>>", { noremap = true })
vim.keymap.set("n", "<c-up>",    "<C-w>-", { noremap = true })
vim.keymap.set("n", "<c-down>",  "<C-w>+", { noremap = true })

require(folderOfThisFile .. 'lazy_vim')

-------------------
-- Colors
-------------------
-- Define a function to simplify setting highlight groups
local function set_highlight(group, properties)
	vim.api.nvim_set_hl(0, group, properties)
end

local function SetColorVisual()
	set_highlight('Visual', { bg = '#51576d', bold = false, italic = false, fg = 'none' })
end

local function SetColorCursorHighlight(opts)
	set_highlight('LspReference', opts)
	set_highlight('LspReferenceRead', opts)
	set_highlight('LspReferenceWrite',opts)
	set_highlight('LspReferenceText', opts)
end

function UnsetColorCursorHighlight()
	local opts = { bg = 'none', fg = 'none', bold = false, italic = false }
	set_highlight('LspReference', opts)
	set_highlight('LspReferenceRead', opts)
	set_highlight('LspReferenceWrite',opts)
	set_highlight('LspReferenceText', opts)
end

local function SetColorWinSeparator()
	-- Window separator Line
	set_highlight('WinSeparator', { fg = '#6e6a86', sp = 'none', bg = 'none', bold = false, italic = false })
	vim.api.nvim_create_autocmd({ "WinEnter" }, {
		callback = function() vim.opt.laststatus=3 end,
		pattern = '*',
	});
end

local function SetColorTreesitterContext()
	-- Treesitter
	set_highlight('TreesitterContext', { bg = '#51576d', bold = false, italic = true })
	set_highlight('TreesitterContextLineNumber', { bg = '#51576d', fg = 'white', bold = false, italic = true })
	set_highlight('TreesitterContextLineNumberBottom', { bg = '#51576d', bold = false, italic = true })
	set_highlight('TreesitterContextBottom', { bold = false, italic = false })
end

function SetColorsCommon(opts_cursor)
	SetColorWinSeparator()
	SetColorTreesitterContext()
	SetColorCursorHighlight(opts_cursor)
	SetColorVisual()
end

function SetColorCatppuccin()
	local opts_cursor = { fg = '#d6ccca', bold = false, italic = false, bg = 'none' }
	vim.api.nvim_command('colorscheme catppuccin-frappe')
	SetColorsCommon(opts_cursor)

	vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
	vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#303446', fg = '#303446' })
	vim.api.nvim_set_hl(0, 'Float',		  { link = 'Normal' })
end

function SetColorRose()
	local opts_cursor = { fg = '#d6ccca', bold = false, italic = false, bg = 'none' }
	vim.api.nvim_command('colorscheme rose-pine-moon')
	SetColorsCommon(opts_cursor)
	vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
	vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
	vim.api.nvim_set_hl(0, 'Float',		  { link = 'Normal' })
end

function SetColorFox()
	local opts_cursor = { fg = '#d6ccca', bold = false, italic = false, bg = 'none' }
	vim.api.nvim_command('colorscheme duskfox')
	SetColorsCommon(opts_cursor)
end

function SetColorKan()
	local opts_cursor = { fg = '', bold = false, italic = false, bg = '#51576d' }
	local opts_noice= { fg = '#b1c9b8', bg = 'none', bold = false, italic = false }
	local opts_noice_search= { fg = '#ffd675', bg = 'none', bold = false, italic = false }
	vim.api.nvim_command('colorscheme kanagawa-dragon')
	SetColorsCommon(opts_cursor)

	--set_highlight('LinNr', { fg = 'none', bg = 'none', bold = false, italic = false })
	set_highlight('SignColumn', { fg = 'none', bg = 'none', bold = false, italic = false })
	set_highlight('GitSignsAdd', { bg = 'none', fg = '#76946a', bold = false, italic = false })
	set_highlight('GitSignsChange', { bg = 'none', fg = '#fca561', bold = false, italic = false })
	set_highlight('GitSignsDelete', { bg = 'none', fg = '#c34043', bold = false, italic = false })
	set_highlight('LineNr', { fg = '#808080', bg = 'none', bold = false, italic = false })

	vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderSearch', opts_noice_search )
	vim.api.nvim_set_hl(0, 'NoiceCmdlineIconSearch', opts_noice_search )
	vim.api.nvim_set_hl(0, 'NoiceCmdline', opts_noice )
	vim.api.nvim_set_hl(0, 'NoiceCmdlineIcon', opts_noice )
	vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", opts_noice )

	vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
	vim.api.nvim_set_hl(0, 'Float', { link = 'Normal' })
	vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none', fg = '#181616' })
end

vim.keymap.set("n", "<Leader>1", ":lua SetColorCatppuccin()<cr>",  {noremap=true})
vim.keymap.set("n", "<Leader>2", ":lua SetColorRose()<cr>",  {noremap=true})
vim.keymap.set("n", "<Leader>3", ":lua SetColorFox()<cr>",  {noremap=true})
vim.keymap.set("n", "<Leader>4", ":lua SetColorKan()<cr>",  {noremap=true})
vim.keymap.set("n", "<Leader>0", ":lua UnsetColorCursorHighlight()<cr>",  {noremap=true})

vim.api.nvim_command("lua SetColorKan()")

_G.floatterm_loaded = false
_G.floatterm_buf, _G.floatterm_win = nil, nil

function Launch_floatterm()
	if not _G.floatterm_loaded or not vim.api.nvim_win_is_valid(_G.floatterm_win) then
		if not _G.floatterm_buf or not vim.api.nvim_buf_is_valid(_G.floatterm_buf) then
			-- Create a buffer
			_G.floatterm_buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_set_option_value("bufhidden", "hide", {buf = _G.floatterm_buf})
			vim.api.nvim_set_option_value("filetype", "terminal", {buf = _G.floatterm_buf})
			--vim.api.nvim_buf_set_lines(_G.floatterm_buf, 0, 1, false, {
			--  "# Notepad",
			--  "",
			--  "> Notepad clears when the current Neovim session closes",
			--})
		end
		-- Create a window
		_G.floatterm_win = vim.api.nvim_open_win(_G.floatterm_buf, true, {
			border = "rounded",
			relative = "editor",
			style = "minimal",
			height = math.ceil(vim.o.lines * 0.35),
			width = math.ceil(vim.o.columns * 0.35),
			row = 0, --> Top of the window
			col = math.ceil(vim.o.columns * 0.65), --> Far right; should add up to 1 with win_width
		})

		vim.api.nvim_set_option_value("winblend", 0, {win = _G.floatterm_win}) --> Semi transparent buffer
		-- Buffer-local Keymaps
		local keymaps_opts = { silent = true, buffer = _G.floatterm_buf }
		vim.keymap.set("n", "<ESC>", function()
			Launch_floatterm()
		end, keymaps_opts)
		vim.keymap.set("n", "q", function()
			Launch_floatterm()
		end, keymaps_opts)
	else
		vim.api.nvim_win_hide(_G.floatterm_win)
	end
	_G.floatterm_loaded = not _G.floatterm_loaded
end

vim.api.nvim_set_keymap("n", "<leader>w", ":lua Launch_floatterm()<cr>", { desc = "Toggle Notepad" })
