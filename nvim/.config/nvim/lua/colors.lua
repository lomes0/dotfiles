local M = {}

-- Define a function to simplify setting highlight groups
local function set_highlight(group, properties)
	vim.api.nvim_set_hl(0, group, properties)
end

local function set_color_visual()
	set_highlight("Visual", { bg = "#51576d", bold = false, italic = false, fg = "none" })
end

local function set_color_cursor_hl(opts)
	set_highlight("LspReference", opts)
	set_highlight("LspReferenceRead", opts)
	set_highlight("LspReferenceWrite", opts)
	set_highlight("LspReferenceText", opts)
end

local function set_color_win_seperator()
	-- Window separator Line
	set_highlight("WinSeparator", { fg = "#6e6a86", sp = "none", bg = "none", bold = false, italic = false })
	vim.api.nvim_create_autocmd({ "WinEnter" }, {
		callback = function()
			vim.opt.laststatus = 3
		end,
		pattern = "*",
	})
end

local function set_color_ts_context()
	-- Treesitter
	set_highlight("TreesitterContext", { bg = "#51576d", bold = false, italic = true })
	set_highlight("TreesitterContextLineNumber", { bg = "#51576d", fg = "white", bold = false, italic = true })
	set_highlight("TreesitterContextLineNumberBottom", { bg = "#51576d", bold = false, italic = true })
	set_highlight("TreesitterContextBottom", { bold = false, italic = false })
end

local function set_color_common(opts_cursor)
	set_color_win_seperator()
	set_color_ts_context()
	set_color_cursor_hl(opts_cursor)
	set_color_visual()
end

function SetColorCatppuccin()
	local opts_cursor = { fg = "#d6ccca", bold = false, italic = false, bg = "none" }
	vim.api.nvim_command("colorscheme catppuccin-frappe")
	set_color_common(opts_cursor)

	vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
	-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#303446", fg = "#303446" })
	vim.api.nvim_set_hl(0, "Float", { link = "Normal" })
end

function SetColorRose()
	local opts_cursor = { fg = "#d6ccca", bold = false, italic = false, bg = "none" }
	vim.api.nvim_command("colorscheme rose-pine-moon")
	set_color_common(opts_cursor)
	vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
	vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
	vim.api.nvim_set_hl(0, "Float", { link = "Normal" })
	vim.api.nvim_set_hl(0, "Folded", { bg = "#51576d", fg = "#bbaaaa" })
end

function SetColorFox()
	local opts_cursor = { fg = "#d6ccca", bold = false, italic = false, bg = "none" }
	vim.api.nvim_command("colorscheme duskfox")
	set_color_common(opts_cursor)
end

function SetColorKan()
	local opts_cursor = { fg = "", bold = false, italic = false, bg = "#51576d" }
	local opts_noice = { fg = "#b1c9b8", bg = "none", bold = false, italic = false }
	local opts_noice_search = { fg = "#ffd675", bg = "none", bold = false, italic = false }
	vim.api.nvim_command("colorscheme kanagawa-dragon")
	set_color_common(opts_cursor)

	--set_highlight('LinNr', { fg = 'none', bg = 'none', bold = false, italic = false })
	set_highlight("SignColumn", { fg = "none", bg = "none", bold = false, italic = false })
	set_highlight("GitSignsAdd", { bg = "none", fg = "#76946a", bold = false, italic = false })
	set_highlight("GitSignsChange", { bg = "none", fg = "#fca561", bold = false, italic = false })
	set_highlight("GitSignsDelete", { bg = "none", fg = "#c34043", bold = false, italic = false })
	set_highlight("LineNr", { fg = "#808080", bg = "none", bold = false, italic = false })

	vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", opts_noice_search)
	vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", opts_noice_search)
	vim.api.nvim_set_hl(0, "NoiceCmdline", opts_noice)
	vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", opts_noice)
	vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", opts_noice)

	vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
	vim.api.nvim_set_hl(0, "Float", { link = "Normal" })
	-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#181616" })
end

function M.init()
	vim.keymap.set("n", "<Leader>1", SetColorKan, { silent = true, noremap = true })
	vim.keymap.set("n", "<Leader>2", SetColorCatppuccin, { silent = true, noremap = true })
	vim.keymap.set("n", "<Leader>3", SetColorRose, { silent = true, noremap = true })
	vim.keymap.set("n", "<Leader>4", SetColorFox, { silent = true, noremap = true })

	vim.api.nvim_command("lua SetColorRose()")
end

return M
