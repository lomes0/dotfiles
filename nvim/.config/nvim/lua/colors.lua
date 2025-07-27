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

function M.set_color_win_separator()
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
	local buffer_bg = "#4a4a4a"
	vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "none", fg = "none" })
	vim.api.nvim_set_hl(0, "BufferLineSeparator", { bg = buffer_bg, fg = buffer_bg })
	vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { bg = buffer_bg, fg = buffer_bg })
	vim.api.nvim_set_hl(0, "BufferLineModifiedSelected", { bg = buffer_bg, fg = "none" })
	vim.api.nvim_set_hl(0, "BufferLineBuffer", { bg = buffer_bg, fg = "none" })
	vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = buffer_bg, fg = "none" })
end

M.colorscheme_opts = {
	["kanagawa"] = {
		treesitter_context = {
			bg = "#3d3e42",
			italic = true,
		},
		custom_highlights = function()
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
		treesitter_context = {
			bg = "#3d3e42",
			italic = true,
		},
		custom_highlights = function()
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
		treesitter_context = {
			bg = "#51576d",
			italic = true,
		},
		custom_highlights = function()
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
	if not M.colorscheme_opts[scheme] then
		vim.notify("Unknown colorscheme: " .. scheme, vim.log.levels.WARN)
		return
	end

	vim.cmd("colorscheme " .. scheme)

	local opts = M.colorscheme_opts[scheme]
	local ts_context_opts = opts.treesitter_context
	local custom_highlights = opts.custom_highlights

	-- Schedule UI updates to avoid blocking
	vim.schedule(function()
		vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
		M.set_color_ts_context(ts_context_opts)
		M.set_color_bufferline()
		M.set_color_win_separator()
		M.set_color_visual()
		M.set_color_debug()

		-- Apply custom highlights if they exist
		if custom_highlights then
			vim.schedule(custom_highlights)
		end
	end)
end

function M.init()
	M.SetColorScheme("kanagawa")
	-- M.SetColorScheme("catppuccin-macchiato")
	-- M.SetColorScheme("tokyonight-moon")
end

return M
