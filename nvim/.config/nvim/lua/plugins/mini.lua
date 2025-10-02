return {
	{
		"echasnovski/mini.ai",
		version = "*",
		lazy = false,
		config = function(_, opts)
			require("mini.ai").setup({
				-- Table with textobject id as fields, textobject specification as values.
				-- Also use this to disable builtin textobjects. See |MiniAi.config|.
				custom_textobjects = nil,

				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					-- Main textobject prefixes
					around = "a",
					inside = "i",

					-- Next/last variants
					around_next = "an",
					inside_next = "in",
					around_last = "al",
					inside_last = "il",

					-- Move cursor to corresponding edge of `a` textobject
					goto_left = "g[",
					goto_right = "g]",
				},

				-- Number of lines within which textobject is searched
				n_lines = 50,

				-- How to search for object (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest', 'next', 'previous', 'nearest'.
				search_method = "cover_or_next",

				-- Whether to disable showing non-error feedback
				silent = false,
			})
		end,
	},
	{
		"echasnovski/mini.basics",
		lazy = false,
		version = false,
	},
	{
		"echasnovski/mini.bracketed",
		version = "*",
		event = "VeryLazy",
		config = function(_, opts)
			require("mini.bracketed").setup({
				-- First-level elements are tables describing behavior of a target:
				--
				-- - <suffix> - single character suffix. Used after `[` / `]` in mappings.
				--   For example, with `b` creates `[B`, `[b`, `]b`, `]B` mappings.
				--   Supply empty string `''` to not create mappings.
				--
				-- - <options> - table overriding target options.
				--
				-- See `:h MiniBracketed.config` for more info.

				buffer = { suffix = "b", options = {} },
				conflict = { suffix = "x", options = {} },
				indent = { suffix = "i", options = {} },
				treesitter = { suffix = "t", options = {} },
				-- comment = { suffix = "c", options = {} },
				-- diagnostic = { suffix = "d", options = {} },
				-- window = { suffix = "w", options = {} },
			})
		end,
	},
	{
		"echasnovski/mini.clue",
		lazy = false,
		version = false,
		config = function()
			local miniclue = require("mini.clue")
			miniclue.setup({
				triggers = {
					-- Leader triggers
					{ mode = "n", keys = "<lt>" },
					{ mode = "x", keys = "<lt>" },

					-- Built-in completion
					{ mode = "i", keys = "<C-x>" },

					-- `g` key
					{ mode = "n", keys = "g" },
					{ mode = "x", keys = "g" },

					-- Marks
					{ mode = "n", keys = "'" },
					-- { mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					-- { mode = "x", keys = "`" },

					-- Registers
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },

					-- Window commands
					{ mode = "n", keys = "<C-w>" },

					-- `z` key
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },
				},

				clues = {
					-- Enhance this by adding descriptions for <Leader> mapping groups
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
			})
		end,
	},
	{
		"echasnovski/mini.files",
		version = "*",
		-- No need to copy this inside `setup()`. Will be used automatically.
		opts = {
			-- Customization of shown content
			content = {
				-- Predicate for which file system entries to show
				filter = nil,
				-- What prefix to show to the left of file system entry
				prefix = nil,
				-- In which order to show file system entries
				sort = nil,
			},

			-- Module mappings created only inside explorer.
			-- Use `''` (empty string) to not create one.
			mappings = {
				close = "q",
				go_in = "l",
				go_in_plus = "L",
				go_out = "h",
				go_out_plus = "H",
				mark_goto = "'",
				mark_set = "m",
				reset = "<BS>",
				reveal_cwd = "@",
				show_help = "g?",
				synchronize = "=",
				trim_left = "<",
				trim_right = ">",
			},

			-- General options
			options = {
				-- Whether to delete permanently or move into module-specific trash
				permanent_delete = true,
				-- Whether to use for editing directories
				use_as_default_explorer = true,
			},

			-- Customization of explorer windows
			windows = {
				-- Maximum number of windows to show side by side
				max_number = math.huge,
				-- Whether to show preview of file/directory under cursor
				preview = false,
				-- Width of focused window
				width_focus = 50,
				-- Width of non-focused window
				width_nofocus = 15,
				-- Width of preview window
				width_preview = 25,
			},
		},
		config = function(_, opts)
			require("mini.files").setup(opts)
		end,
	},
	-- {
	-- 	"echasnovski/mini.indentscope",
	-- 	version = "*",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = function(_, opts)
	-- 		require("mini.indentscope").setup({
	-- 			draw = {
	-- 				delay = 100,
	-- 			},
	-- 			mappings = {
	-- 				-- Textobjects
	-- 				object_scope = "ii",
	-- 				object_scope_with_border = "ai",
	--
	-- 				-- Motions (jump to respective border line; if not present - body line)
	-- 				goto_top = "[i",
	-- 				goto_bottom = "]i",
	-- 			},
	-- 			options = {
	-- 				border = "both",
	-- 				indent_at_cursor = true,
	-- 				try_as_border = false,
	-- 			},
	-- 			symbol = "╎",
	-- 		})
	--
	-- 		-- Disable for certain filetypes
	-- 		vim.api.nvim_create_autocmd({ "FileType" }, {
	-- 			desc = "Disable indentscope for certain filetypes",
	-- 			callback = function()
	-- 				local ignore_filetypes = {
	-- 					"Avante",
	-- 					"aerial",
	-- 					"dashboard",
	-- 					"help",
	-- 					"lazy",
	-- 					"leetcode.nvim",
	-- 					"mason",
	-- 					"neo-tree",
	-- 					"NvimTree",
	-- 					"neogitstatus",
	-- 					"notify",
	-- 					"startify",
	-- 					"toggleterm",
	-- 					"Trouble",
	-- 					"markdown",
	-- 				}
	-- 				if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
	-- 					vim.b.miniindentscope_disable = true
	-- 				end
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		version = "*",
		-- No need to copy this inside `setup()`. Will be used automatically.
		options = {
			-- In which modes mappings from this `config` should be created
			modes = { insert = true, command = false, terminal = false },

			-- Global mappings. Each right hand side should be a pair information, a
			-- table with at least these fields (see more in |MiniPairs.map|):
			-- - <action> - one of 'open', 'close', 'closeopen'.
			-- - <pair> - two character string for pair to be used.
			-- By default pair is not inserted after `\`, quotes are not recognized by
			-- `<CR>`, `'` does not insert pair after a letter.
			-- Only parts of tables can be tweaked (others will use these defaults).
			mappings = {
				["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
				["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
				["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

				[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
				["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
				["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

				['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
				["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
				["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
			},
		},
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},
	{
		"echasnovski/mini.surround",
		version = "*",
		opts = {
			-- Add custom surroundings to be used on top of builtin ones. For more
			-- information with examples, see `:h MiniSurround.config`.
			custom_surroundings = nil,

			-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
			highlight_duration = 500,

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = "sa", -- Add surrounding in Normal and Visual modes
				delete = "sd", -- Delete surrounding
				find = "sf", -- Find surrounding (to the right)
				find_left = "sF", -- Find surrounding (to the left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding
				update_n_lines = "sn", -- Update `n_lines`

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},

			-- Number of lines within which surrounding is searched
			n_lines = 20,

			-- Whether to respect selection type:
			-- - Place surroundings on separate lines in linewise mode.
			-- - Place surroundings on each line in blockwise mode.
			respect_selection_type = false,

			-- How to search for surrounding (first inside current line, then inside
			-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
			-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
			-- see `:h MiniSurround.config`.
			search_method = "cover",

			-- Whether to disable showing non-error feedback
			-- This also affects (purely informational) helper messages shown after
			-- idle time if user input is required.
			silent = false,
		},
		config = function(_, opts)
			require("mini.surround").setup(opts)
		end,
	},
}
