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
	local hl = vim.api.nvim_get_hl(0, { name = "LspInlayHint" })
	vim.api.nvim_set_hl(0, "LspInlayHint", M.m(hl, { bg = "none" }))
end

-- function M.set_color_ts_context(opts_ts)
-- 	opts_ts = opts_ts or {
-- 		bg = "#51576d",
-- 		italic = true,
-- 	}
-- 	vim.api.nvim_set_hl(0, "TreesitterContext", M.m(opts_ts, {}))
-- 	vim.api.nvim_set_hl(0, "TreesitterContextBottom", M.m(opts_ts, { fg = "none" }))
-- 	vim.api.nvim_set_hl(0, "TreesitterContextSeparator", M.m(opts_ts, { fg = "none" }))
-- 	vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", M.m(opts_ts, { fg = "white" }))
-- 	vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", M.m(opts_ts, {}))
-- end

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

M.colorscheme_opts = {
	["nordfox"] = {
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
				["@_parent"] = { fg = "#d5dee3", bg = "none" },
				["@type.c"] = { fg = "#b5ada3", bg = "none" },
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
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = "none" })

		-- Apply custom highlights if they exist
		if custom_highlights then
			vim.schedule(custom_highlights)
		end
	end)
end
