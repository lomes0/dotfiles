return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufReadPost",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				ignore_install = {},
				incremental_selection = {
					enable = false,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
						},
					},
				},
				ensure_installed = {
					"make",
					"cmake",
					"css",
					"scss",
					"kdl",
					"markdown",
					"toml",
					"latex",
					"cpp",
					"lua",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					-- disable = function(_, buf)
					-- 	local max_filesize = 100 * 1024 -- 100 KB
					-- 	local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(buf))
					-- 	return stats and stats.size > max_filesize
					-- end,
				},
				indent = {
					enable = false,
				},
			})
			vim.filetype.add({
				extension = {
					mdx = "mdx",
				},
			})
			vim.treesitter.language.register("markdown", "mdx")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "BufReadPost",
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				ignore_install = {},
				ensure_installed = {},
				sync_install = false,
				auto_install = false,
				textobjects = {
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = "@function.outer",
							["]r"] = "@return.outer",
							["]p"] = "@parameter.outer",
							["]a"] = "@assignment.outer",
							["]o"] = "@loop.*",
							-- ["]b"] = "@block.outer",
							-- ["]s"] = "@statement.outer",
							-- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
							-- ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]R"] = "@return.outer",
							["]P"] = "@parameter.outer",
							["]A"] = "@assignment.outer",
							["]O"] = "@loop.*",
							-- ["]B"] = "@block.outer",
							-- ["]S"] = "@statement.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[r"] = "@return.outer",
							["[p"] = "@parameter.outer",
							["[a"] = "@assignment.outer",
							["[o"] = "@loop.*",
							-- ["[b"] = "@block.outer",
							-- ["[s"] = "@statement.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[R"] = "@return.outer",
							["[P"] = "@parameter.outer",
							["[A"] = "@assignment.outer",
							["[O"] = "@loop.*",
							-- ["[B"] = "@block.outer",
							-- ["[S"] = "@statement.outer",
						},
					},
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
						},
						include_surrounding_whitespace = true,
					},
				},
			})
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			-- Repeat movement with ; and ,
			vim.keymap.set({ "n", "x", "o" }, ".", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ">", ts_repeat_move.repeat_last_move_previous)
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 0,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = nil,
				zindex = 20,
				on_attach = nil,
			})
			local treesitter_ctx = require("treesitter-context")
			vim.keymap.set("n", "[[", function()
				treesitter_ctx.go_to_context()
			end, { noremap = true, silent = true, desc = "Treesitter prev context" })
			vim.keymap.set("n", "[]", function()
				treesitter_ctx.toggle()
			end, { noremap = true, silent = true, desc = "Treesitter toggle context" })
			treesitter_ctx.disable()
		end,
	},
}
