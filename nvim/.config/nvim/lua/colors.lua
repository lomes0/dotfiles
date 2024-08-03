local M = {}

-- Define a function to simplify setting highlight groups
local function set_highlight(group, properties)
	vim.api.nvim_set_hl(0, group, properties)
end

local function m(tb, ta)
	for k, v in pairs(ta) do
		tb[k] = v
	end
	return tb
end

local function set_color_visual()
	set_highlight("Visual", {
		bg = "#51576d",
		fg = "none",
	})
end

local function set_color_cursor_hl(opts)
	set_highlight("LspReference", opts)
	set_highlight("LspReferenceRead", opts)
	set_highlight("LspReferenceWrite", opts)
	set_highlight("LspReferenceText", opts)
end

local function set_color_win_seperator()
	set_highlight("WinSeparator", {
		bg = "none",
		fg = "#6e6a86",
		sp = "none",
	})
	vim.api.nvim_create_autocmd({ "WinEnter" }, {
		callback = function()
			vim.opt.laststatus = 3
		end,
		pattern = "*",
	})
end

local function set_color_ts_context(opts_ts)
	opts_ts = opts_ts or {
		bg = "#51576d",
		italic = true,
	}
	set_highlight("TreesitterContext", opts_ts)
	set_highlight("TreesitterContextLineNumber", m(opts_ts, { fg = "white", italic = true }))
	set_highlight("TreesitterContextLineNumberBottom", m(opts_ts, { italic = true }))
	set_highlight("TreesitterContextBottom", {})
end

local function set_color_common(scheme, opts_cursor, opts_ts)
	vim.api.nvim_command("colorscheme " .. scheme)

	set_color_ts_context(opts_ts)
	set_color_cursor_hl(opts_cursor)
	set_color_win_seperator()
	set_color_visual()
end

function SetColorCatppuccin()
	set_color_common("catppuccin-frappe", {
		bg = "#51576d",
		fg = "",
	})

	set_highlight("NormalFloat", { link = "Normal" })
	set_highlight("Float", { link = "Normal" })
end

function SetColorRose()
	set_color_common("rose-pine-moon", {
		bg = "none",
		fg = "#d6ccca",
	})

	set_highlight("NormalFloat", { link = "Normal" })
	set_highlight("FloatBorder", { link = "Normal" })
	set_highlight("Float", { link = "Normal" })
	set_highlight("Folded", { bg = "#51576d", fg = "#bbaaaa" })
end

function SetColorKan()
	local opts_noice = { fg = "#b1c9b8", bg = "none" }
	local opts_noice_search = { fg = "#ffd675", bg = "none" }
	set_color_common("kanagawa-dragon", {
		bg = "#3d3e42",
		fg = "",
	}, {
		bg = "#3d3e42",
		fg = "",
	})

	set_highlight("SignColumn", { fg = "none", bg = "none" })
	set_highlight("GitSignsAdd", { bg = "none", fg = "#76946a" })
	set_highlight("GitSignsChange", { bg = "none", fg = "#fca561" })
	set_highlight("GitSignsDelete", { bg = "none", fg = "#c34043" })
	set_highlight("LineNr", { fg = "#808080", bg = "none" })

	set_highlight("NoiceCmdlinePopupBorderSearch", opts_noice_search)
	set_highlight("NoiceCmdlineIconSearch", opts_noice_search)
	set_highlight("NoiceCmdline", opts_noice)
	set_highlight("NoiceCmdlineIcon", opts_noice)
	set_highlight("NoiceCmdlinePopupBorder", opts_noice)

	set_highlight("NormalFloat", { link = "Normal" })
	set_highlight("Float", { link = "Normal" })
end

function M.init()
	vim.keymap.set("n", "<Leader>1", SetColorKan, { silent = true, noremap = true })
	vim.keymap.set("n", "<Leader>2", SetColorCatppuccin, { silent = true, noremap = true })
	vim.keymap.set("n", "<Leader>3", SetColorRose, { silent = true, noremap = true })
	vim.api.nvim_command("lua SetColorKan()")
end

return M
