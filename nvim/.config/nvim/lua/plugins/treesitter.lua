return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			-- Cache parsers to avoid repeated creation
			local parser_cache = {}

			-- Lazy parser loading function
			local function get_cached_parser(bufnr, lang)
				local key = bufnr .. ":" .. lang
				if not parser_cache[key] then
					parser_cache[key] = vim.treesitter.get_parser(bufnr, lang)
				end
				return parser_cache[key]
			end

			require("nvim-treesitter.configs").setup({
				modules = {},
				ignore_install = {},
				incremental_selection = {
					enable = false,
				},
				textobjects = {
					swap = {
						enable = true,
						swap_next = {
							["L"] = "@parameter.inner",
						},
						swap_previous = {
							["H"] = "@parameter.inner",
						},
					},
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
							["]d"] = "@conditional.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]D"] = "@conditional.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
						},
					},
				},
				-- Only install essential parsers initially
				ensure_installed = {
					"lua", -- Always needed for config
					"vim", -- Always needed for config
					"vimdoc", -- Always needed for help
				},
				sync_install = false,
				auto_install = true, -- Install parsers on demand
				highlight = {
					enable = true,
					disable = { "text" },
					-- Performance optimization: disable for large files
					disable = function(_, buf)
						local max_filesize = 1024 * 1024 -- 1 MB
						local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
						return ok and stats and stats.size > max_filesize
					end,
				},
				indent = {
					enable = false, -- Disabled for better performance
				},
			})

			-- Store parser getter in global for other modules
			_G.get_cached_parser = get_cached_parser

			-- Clear parser cache when buffer is deleted
			vim.api.nvim_create_autocmd("BufDelete", {
				callback = function(event)
					for key, _ in pairs(parser_cache) do
						if key:match("^" .. event.buf .. ":") then
							parser_cache[key] = nil
						end
					end
				end,
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
			vim.keymap.set({ "n", "x", "o" }, ">", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, "<", ts_repeat_move.repeat_last_move_previous)
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
