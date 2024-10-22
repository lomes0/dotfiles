local M = {
	last_type = nil,
}

function M.m(tb, ta)
	for k, v in pairs(ta) do
		tb[k] = v
	end
	return tb
end

function M.set_color_visual()
	vim.api.nvim_set_hl(0, "Visual", {
		bg = "#51576d",
		fg = "none",
	})
end

-- function M.set_color_cursor_hl(opts)
-- 	vim.api.nvim_set_hl(0, "LspReferenceText", opts)
-- end

function M.set_color_win_seperator()
	vim.api.nvim_set_hl(0, "WinSeparator", {
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

function M.set_color_ts_context(opts_ts)
	opts_ts = opts_ts or {
		bg = "#51576d",
		italic = true,
	}
	vim.api.nvim_set_hl(0, "TreesitterContext", M.m(opts_ts, {}))
	vim.api.nvim_set_hl(0, "TreesitterContextBottom", M.m(opts_ts, { fg = "none" }))
	vim.api.nvim_set_hl(0, "TreesitterContextSeparator", M.m(opts_ts, { fg = "none" }))
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", M.m(opts_ts, { fg = "white" }))
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", M.m(opts_ts, {}))
end

function M.set_color_debug()
	-- Define highlight groups for white line background
	-- vim.cmd('highlight DapBreakpointLine guifg=#000000')
	vim.api.nvim_set_hl(0, "DapStoppedLine", {
		bg = "#365d78", -- Background color
		fg = "#c5cdd6", -- Foreground color
		blend = 60, -- Blend level
	})

	-- Define the signs with the updated line highlighting
	vim.fn.sign_define("DapBreakpoint", {
		text = "○", -- nerdfonts icon here
		texthl = "DapBreakpointSymbol",
		linehl = "DapBreakpointLine", -- Use the new highlight group
		numhl = "DapBreakpoint",
	})

	vim.fn.sign_define("DapStopped", {
		text = "◉",
		texthl = "DapStoppedSymbol",
		linehl = "DapStoppedLine",
		numhl = "DapBreakpoint",
	})
end

function M.set_color_bufferline()
	-- Buffer
	local aaa = "#4a4a4a"
	vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "none", fg = "none" })
	vim.api.nvim_set_hl(0, "BufferLineSeparator", { bg = aaa, fg = aaa })
	vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { bg = aaa, fg = aaa })
	vim.api.nvim_set_hl(0, "BufferLineModifiedSelected", { bg = aaa, fg = "none" })
	vim.api.nvim_set_hl(0, "BufferLineBuffer", { bg = aaa, fg = "none" })
	vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = aaa, fg = "none" })
end

M.colorscheme_opts = {
	["kanagawa"] = {
		-- cursor
		{
			bg = "#3d3e42",
			fg = "",
		},
		-- treesitter
		{
			bg = "#3d3e42",
			fg = "",
		},
		function()
			local opts_noice = { fg = "#b1c9b8", bg = "none" }
			local opts_noice_search = { fg = "#ffd675", bg = "none" }
			-- Git
			vim.api.nvim_set_hl(0, "SignColumn", { fg = "none", bg = "none" })
			vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "none", fg = "#8bb38e" })
			vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "none", fg = "#fce2bb" })
			vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "none", fg = "#c34043" })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#808080", bg = "none" })

			-- Noice
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", opts_noice_search)
			vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", opts_noice_search)
			vim.api.nvim_set_hl(0, "NoiceCmdline", opts_noice)
			vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", opts_noice)
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", opts_noice)

			-- Float
			vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
			vim.api.nvim_set_hl(0, "Float", { link = "Normal" })

			-- Lsp
			vim.api.nvim_set_hl(0, "@type.builtin.c", { fg = "#e6b791" })
			vim.api.nvim_set_hl(0, "@type.builtin.cpp", { fg = "#e6b791" })
			vim.api.nvim_set_hl(0, "@lsp.type.class.c", { fg = "#e6b791" })
			vim.api.nvim_set_hl(0, "@lsp.mod.defaultLibrary.c", { fg = "#e6b791" })

			-- vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#b6cfcb" })
			vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#e6e3be" })
			vim.api.nvim_set_hl(0, "@lsp.type.variable.c", { fg = "#e6e3be" })

			vim.api.nvim_set_hl(0, "@lsp.type.function.c", { fg = "#abd1c8" })
			vim.api.nvim_set_hl(0, "@variable.c", { fg = "#dedac5" })

			vim.api.nvim_set_hl(0, "@function.call", { fg = "#82abc4", bg = "none", bold = true })
			vim.api.nvim_set_hl(0, "@keyword.modifier", { fg = "#937ba8", bg = "none", bold = false })

			vim.api.nvim_set_hl(0, "@keyword.directive", { fg = "#c2a9d9", bg = "none", bold = false })
			vim.api.nvim_set_hl(0, "@keyword.directive.cpp", { fg = "#c2a9d9", bg = "none", bold = false })
			vim.api.nvim_set_hl(0, "@keyword.repeat", { fg = "#c2a9d9", bg = "none", bold = false })
			vim.api.nvim_set_hl(0, "@keyword.repeat.c", { fg = "#c2a9d9", bg = "none", bold = false })
			vim.api.nvim_set_hl(0, "@keyword.conditional", { fg = "#c2a9d9", bg = "none", bold = false })
			vim.api.nvim_set_hl(0, "@keyword.function", { fg = "#c2a9d9", bg = "none", bold = false })
			vim.api.nvim_set_hl(0, "@keyword.function.rust", { fg = "#c2a9d9", bg = "none", bold = false })
			vim.api.nvim_set_hl(0, "@keyword.modifier.rust", { fg = "#c2a9d9", bg = "none", bold = false })
			vim.api.nvim_set_hl(0, "@keyword.rust", { fg = "#c2a9d9", bg = "none", bold = false })
			vim.api.nvim_set_hl(0, "@_parent", { fg = "#f2eca7", bg = "none", bold = false })
		end,
	},
	["tokyonight-moon"] = {
		-- cursor
		{
			bg = "#51576d",
			fg = "",
		},
		-- treesitter
		{
			bg = "#3d3e42",
			fg = "",
		},
		function()
			vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
			vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
			vim.api.nvim_set_hl(0, "Float", { link = "Normal" })
			vim.api.nvim_set_hl(0, "CurSearch", { bg = "#738994", fg = "white" })
			vim.api.nvim_set_hl(0, "IncSearch", { bg = "#738994", fg = "white" })
			vim.api.nvim_set_hl(0, "Search", { bg = "#738994", fg = "white" })
		end,
	},
	["catppuccin-macchiato"] = {
		-- cursor
		{
			bg = "#51576d",
			fg = "",
		},
		-- treesitter
		{
			bg = "#51576d",
			fg = "",
		},
		function()
			vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
			vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
			vim.api.nvim_set_hl(0, "Float", { link = "Normal" })
			vim.api.nvim_set_hl(0, "@type.builtin.c", { fg = "#abd4d6" })
			vim.api.nvim_set_hl(0, "@type.builtin.cpp", { fg = "#abd4d6" })
		end,
	},
}

function M.SetColorScheme(scheme)
	vim.api.nvim_command("colorscheme " .. scheme)

	local opts = M.colorscheme_opts[scheme]
	local opts_ts = opts[1]
	local opts_cursor = opts[2]
	local callback = opts[3]

	vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
	M.set_color_ts_context(opts_ts)
	-- M.set_color_cursor_hl(opts_cursor)
	M.set_color_bufferline()
	M.set_color_win_seperator()
	M.set_color_visual()
	M.set_color_debug()

	callback()
end

function M.init()
	M.SetColorScheme("kanagawa")
	-- M.SetColorScheme("catppuccin-macchiato")
	-- M.SetColorScheme("tokyonight-moon")
end

return M
