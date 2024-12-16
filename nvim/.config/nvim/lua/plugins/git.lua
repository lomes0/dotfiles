return {
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				sign_priority = 6, -- Default priority for all gitsigns
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")
					vim.keymap.set("n", "  ", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns next change",
					})

					-- stage
					vim.keymap.set("n", "sa", gitsigns.stage_hunk, {
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns stage",
					})
					vim.keymap.set("v", "sa", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, {
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns stage selection",
					})

					-- reset
					vim.keymap.set("n", "sR", gitsigns.reset_buffer, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns reset buffer",
					})
					vim.keymap.set("n", "sr", gitsigns.reset_hunk, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns reset hunk",
					})

					-- review
					vim.keymap.set("n", "sp", gitsigns.preview_hunk, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns preview hunk",
					})
					vim.keymap.set("n", "st", gitsigns.toggle_current_line_blame, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns toggle blame",
					})
					vim.keymap.set("n", "sd", gitsigns.diffthis, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns diffthis",
					})

					-- vim.keymap.set("n", "sb", gitsigns.stage_buffer, {
					-- 	noremap = true,
					-- 	silent = true,
					-- 	buffer = bufnr,
					-- 	desc = "Gitsigns stage buffer",
					-- })
					-- vim.keymap.set("n", "su", gitsigns.undo_stage_hunk, {
					-- 	noremap = true,
					-- 	silent = true,
					-- 	buffer = bufnr,
					-- 	desc = "Gitsigns stage undo",
					-- })

					vim.wo.signcolumn = "yes"
				end,
			})
		end,
	},
	{
		"sindrets/diffview.nvim",
		lazy = true,
		cmd = { "DiffviewOpen" },
	},
}
