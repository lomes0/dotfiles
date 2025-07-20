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
			-- Batch highlight setting for performance
			local highlights = {
				-- Git highlights
				SignColumn = { fg = "none", bg = "none" },
				GitSignsAdd = { bg = "none", fg = "#8bb38e" },
				GitSignsChange = { bg = "none", fg = "#fce2bb" },
				GitSignsDelete = { bg = "none", fg = "#c34043" },
				LineNr = { fg = "#808080", bg = "none" },

				-- Noice highlights
				NoiceCmdlinePopupBorderSearch = { fg = "#ffd675", bg = "none" },
				NoiceCmdlineIconSearch = { fg = "#ffd675", bg = "none" },
				NoiceCmdline = { fg = "#b1c9b8", bg = "none" },
				NoiceCmdlineIcon = { fg = "#b1c9b8", bg = "none" },
				NoiceCmdlinePopupBorder = { fg = "#b1c9b8", bg = "none" },

				-- Float highlights
				NormalFloat = { link = "Normal" },
				Float = { link = "Normal" },

				-- LSP and Treesitter highlights (grouped by color)
				["@type.builtin.c"] = { fg = "#e6b791" },
				["@type.builtin.cpp"] = { fg = "#e6b791" },
				["@lsp.type.class.c"] = { fg = "#e6b791" },
				["@lsp.mod.defaultLibrary.c"] = { fg = "#e6b791" },

				["@variable.parameter"] = { fg = "#e6e3be" },
				["@lsp.type.variable.c"] = { fg = "#e6e3be" },

				["@lsp.type.function.c"] = { fg = "#abd1c8" },
				["@variable.c"] = { fg = "#dedac5" },
				["@function.call"] = { fg = "#82abc4", bg = "none", bold = true },
				["@keyword.modifier"] = { fg = "#937ba8", bg = "none" },

				-- Keyword highlights (all using same color)
				["@keyword.directive"] = { fg = "#c2a9d9", bg = "none" },
				["@keyword.directive.cpp"] = { fg = "#c2a9d9", bg = "none" },
				["@keyword.repeat"] = { fg = "#c2a9d9", bg = "none" },
				["@keyword.repeat.c"] = { fg = "#c2a9d9", bg = "none" },
				["@keyword.conditional"] = { fg = "#c2a9d9", bg = "none" },
				["@keyword.function"] = { fg = "#c2a9d9", bg = "none" },
				["@keyword.function.rust"] = { fg = "#c2a9d9", bg = "none" },
				["@keyword.modifier.rust"] = { fg = "#c2a9d9", bg = "none" },
				["@keyword.rust"] = { fg = "#c2a9d9", bg = "none" },

				["@_parent"] = { fg = "#f2eca7", bg = "none" },
			}

			-- Batch apply all highlights
			for group, opts in pairs(highlights) do
				vim.api.nvim_set_hl(0, group, opts)
			end
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
			local highlights = {
				NormalFloat = { link = "Normal" },
				FloatBorder = { link = "Normal" },
				Float = { link = "Normal" },
				CurSearch = { bg = "#738994", fg = "white" },
				IncSearch = { bg = "#738994", fg = "white" },
				Search = { bg = "#738994", fg = "white" },
			}
			for group, opts in pairs(highlights) do
				vim.api.nvim_set_hl(0, group, opts)
			end
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
			local highlights = {
				FloatBorder = { link = "Normal" },
				NormalFloat = { link = "Normal" },
				Float = { link = "Normal" },
				["@type.builtin.c"] = { fg = "#abd4d6" },
				["@type.builtin.cpp"] = { fg = "#abd4d6" },
			}
			for group, opts in pairs(highlights) do
				vim.api.nvim_set_hl(0, group, opts)
			end
		end,
	},
}

function M.SetColorScheme(scheme)
	vim.cmd("colorscheme " .. scheme)

	local opts = M.colorscheme_opts[scheme]
	local opts_ts = opts[1]
	local opts_cursor = opts[2]
	local callback = opts[3]

	-- Schedule UI updates to avoid blocking
	vim.schedule(function()
		vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
		M.set_color_ts_context(opts_ts)
		M.set_color_bufferline()
		M.set_color_win_seperator()
		M.set_color_visual()
		M.set_color_debug()

		-- Schedule callback separately to prevent nested scheduling issues
		vim.schedule(callback)
	end)
end

function M.init()
	M.SetColorScheme("kanagawa")
	-- M.SetColorScheme("catppuccin-macchiato")
	-- M.SetColorScheme("tokyonight-moon")
end

return M
