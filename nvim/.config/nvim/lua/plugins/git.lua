return {
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				signcolumn = true,
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

					vim.keymap.set("n", " b", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns prev change",
					})

					-- stage
					vim.keymap.set("n", "ca", gitsigns.stage_hunk, {
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns stage",
					})
					vim.keymap.set("v", "ca", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, {
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns stage selection",
					})

					-- reset
					vim.keymap.set("n", "cR", gitsigns.reset_buffer, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns reset buffer",
					})

					-- reset
					vim.keymap.set("n", "cr", gitsigns.reset_hunk, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns reset hunk",
					})

					-- preview
					vim.keymap.set("n", "cp", gitsigns.preview_hunk, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns preview hunk",
					})

					-- blame
					vim.keymap.set("n", "cb", gitsigns.toggle_current_line_blame, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns toggle blame",
					})

					-- diff
					vim.keymap.set("n", "cd", gitsigns.diffthis, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns diffthis",
					})

					vim.wo.signcolumn = "yes"
					vim.o.statuscolumn = "%!v:lua.require('statuscolumn').statuscolumn()"
				end,
			})
		end,
	},
	{
		"sindrets/diffview.nvim",
		lazy = true,
		cmd = { "DiffviewOpen" },
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			"echasnovski/mini.pick", -- optional
		},
		config = true,
	},
}
