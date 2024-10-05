require("lazy").setup({
	--------------
	-- Ai
	--------------
	-- Lazy
	{
		"vague2k/vague.nvim",
		config = function()
			require("vague").setup({
				-- optional configuration here
			})
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom", -- | top | left | right
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = false,
					hide_during_completion = true,
					debounce = 75,
					keymap = {
						accept = "<M-l>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				copilot_node_command = "node", -- Node.js version must be > 18.x
				server_opts_overrides = {},
			})
		end,
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- set this if you want to always pull the latest change
		opts = {
			---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
			provider = "copilot", -- Recommend using Claude
			auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
			vendors = {
				ollama = {
					["local"] = true,
					endpoint = "127.0.0.1:11434/v1",
					model = "llama3",
					parse_curl_args = function(opts, code_opts)
						return {
							url = opts.endpoint .. "/chat/completions",
							headers = {
								["Accept"] = "application/json",
								["Content-Type"] = "application/json",
							},
							body = {
								model = opts.model,
								messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
								max_tokens = 2048,
								stream = true,
							},
						}
					end,
					parse_response_data = function(data_stream, event_state, opts)
						require("avante.providers").openai.parse_response(data_stream, event_state, opts)
					end,
				},
			},
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-5-sonnet-20240620",
				temperature = 0,
				max_tokens = 4096,
			},
			behaviour = {
				auto_suggestions = false, -- Experimental stage
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = false,
			},
			mappings = {
				--- @class AvanteConflictMappings
				diff = {
					ours = "co",
					theirs = "ct",
					all_theirs = "ca",
					both = "cb",
					cursor = "cc",
					next = "]x",
					prev = "[x",
				},
				suggestion = {
					accept = "<M-l>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
				jump = {
					next = "]]",
					prev = "[[",
				},
				submit = {
					normal = "<CR>",
					insert = "<C-s>",
				},
				sidebar = {
					switch_windows = "<Tab>",
					reverse_switch_windows = "<S-Tab>",
				},
			},
			hints = { enabled = true },
			windows = {
				---@type "right" | "left" | "top" | "bottom"
				position = "right", -- the position of the sidebar
				wrap = true, -- similar to vim.o.wrap
				width = 45, -- default % based on available width
				sidebar_header = {
					align = "center", -- left, center, right for title
					rounded = true,
				},
			},
			highlights = {
				diff = {
					current = "DiffText",
					incoming = "DiffAdd",
				},
			},
			--- @class AvanteConflictUserConfig
			diff = {
				autojump = true,
				---@type string | fun(): any
				list_opener = "copen",
			},
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				dependencies = {
					"nvim-treesitter/nvim-treesitter",
					"echasnovski/mini.nvim",
				},
				opts = {
					file_types = { "markdown", "Avante" },
					anti_conceal = { enabled = false },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	--------------
	-- Editor
	--------------
	{
		"akinsho/bufferline.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		lazy = "VeryLazy",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "tabs",
					show_buffer_icons = false,
					show_buffer_close_icons = false,
					show_close_icon = false,
					tab_size = 20, -- Set the fixed width of tabs
					diagnostics = false,
					always_show_bufferline = true,
				},
			})
			vim.o.showtabline = 1
		end,
	},
	{
		"nvim-lua/plenary.nvim",
		lazy = false,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				sort = { "desc", "alphanum", "lower", "icase", "mod" },
				delay = 1500,
			})
		end,
	},
	{
		"echasnovski/mini.ai",
		version = "*",
		lazy = false,
		config = function()
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
		"echasnovski/mini.indentscope",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mini.indentscope").setup({
				draw = {
					delay = 100,
				},
				mappings = {
					-- Textobjects
					object_scope = "ii",
					object_scope_with_border = "ai",

					-- Motions (jump to respective border line; if not present - body line)
					goto_top = "[i",
					goto_bottom = "]i",
				},
				options = {
					border = "both",
					indent_at_cursor = true,
					try_as_border = false,
				},
				symbol = "╎",
			})

			-- Disable for certain filetypes
			vim.api.nvim_create_autocmd({ "FileType" }, {
				desc = "Disable indentscope for certain filetypes",
				callback = function()
					local ignore_filetypes = {
						"aerial",
						"dashboard",
						"help",
						"lazy",
						"leetcode.nvim",
						"mason",
						"neo-tree",
						"NvimTree",
						"neogitstatus",
						"notify",
						"startify",
						"toggleterm",
						"Trouble",
						"markdown",
					}
					if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
						vim.b.miniindentscope_disable = true
					end
				end,
			})
		end,
	},
	{
		"echasnovski/mini.bracketed",
		version = "*",
		event = "VeryLazy",
		config = function()
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
				comment = { suffix = "c", options = {} },
				conflict = { suffix = "x", options = {} },
				diagnostic = { suffix = "d", options = {} },
				indent = { suffix = "i", options = {} },
				treesitter = { suffix = "t", options = {} },
				window = { suffix = "w", options = {} },
			})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		lazy = true,
		cmd = { "Toggleterm" },
		keys = { "<c-\\>", "<lt>l" },
		version = "*",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				hide_numbers = true, -- hide the number column in toggleterm buffers
				shade_filetypes = {},
				autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
				start_in_insert = true,
				insert_mappings = true, -- whether or not the open mapping applies in insert mode
				terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
				direction = "float",
				persist_size = true,
				persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
				close_on_exit = true, -- close the terminal window when the process exits
				-- Change the default shell. Can be a string or a function returning a string
				shell = vim.o.shell,
				auto_scroll = true, -- automatically scroll to the bottom on terminal output
				winbar = {
					enabled = false,
					name_formatter = function(term) --  term: Terminal
						return term.name
					end,
				},
			})
			local Terminal = require("toggleterm.terminal").Terminal
			function Lazygit_toggle()
				local buf_dir = vim.fn.expand("%:p:h")
				local git_dir_cmd = "git -C " .. buf_dir .. " rev-parse --show-toplevel"
				local git_dir = vim.fn.system(git_dir_cmd)
				local lazygit = Terminal:new({
					cmd = "lazygit -p=" .. git_dir,
					dir = "",
					direction = "float",
					float_opts = {
						border = "double",
					},
					-- function to run on opening the terminal
					on_open = function(term)
						vim.cmd("startinsert!")
						vim.api.nvim_buf_set_keymap(
							term.bufnr,
							"n",
							"q",
							"<cmd>close<CR>",
							{ noremap = true, silent = true }
						)
					end,
					-- function to run on closing the terminal
					on_close = function()
						vim.cmd("startinsert!")
					end,
				})
				lazygit:toggle()
			end
			vim.keymap.set("n", "<lt>l", Lazygit_toggle, {
				noremap = true,
				silent = true,
				desc = "Lazygit open",
			})
		end,
	},
	{
		"sindrets/winshift.nvim",
		lazy = true,
		cmd = { "WinShift" },
		config = function()
			-- Lua
			require("winshift").setup({
				highlight_moving_win = true, -- Highlight the window being moved
				focused_hl_group = "Visual", -- The highlight group used for the moving window
				moving_win_options = {
					-- These are local options applied to the moving window while it's
					-- being moved. They are unset when you leave Win-Move mode.
					wrap = false,
					cursorline = false,
					cursorcolumn = false,
					colorcolumn = "",
				},
				keymaps = {
					disable_defaults = false, -- Disable the default keymaps
					win_move_mode = {
						["h"] = "left",
						["j"] = "down",
						["k"] = "up",
						["l"] = "right",
						["H"] = "far_left",
						["J"] = "far_down",
						["K"] = "far_up",
						["L"] = "far_right",
					},
				},
				window_picker = function()
					return require("winshift.lib").pick_window({
						-- A string of chars used as identifiers by the window picker.
						picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
						filter_rules = {
							-- This table allows you to indicate to the window picker that a window
							-- should be ignored if its buffer matches any of the following criteria.
							cur_win = true, -- Filter out the current window
							floats = true, -- Filter out floating windows
							filetype = {}, -- List of ignored file types
							buftype = {}, -- List of ignored buftypes
							bufname = { ".*SidebarNvim_[0-9]+$" }, -- List of vim regex patterns matching ignored buffer names
						},
						filter_func = nil,
					})
				end,
			})
			-- Start Win-Move mode:
			vim.cmd([[
				nnoremap <C-W><C-M> <Cmd>WinShift<CR>
				nnoremap <C-W>m <Cmd>WinShift<CR>
				
				" Swap two windows:
				nnoremap <C-W>X <Cmd>WinShift swap<CR>
				
				" If you don't want to use Win-Move mode you can create mappings for calling the
				" move commands directly:
				nnoremap <C-M-H> <Cmd>WinShift left<CR>
				nnoremap <C-M-J> <Cmd>WinShift down<CR>
				nnoremap <C-M-K> <Cmd>WinShift up<CR>
				nnoremap <C-M-L> <Cmd>WinShift right<CR>
		]])
		end,
	},
	{
		"pocco81/auto-save.nvim",
		event = "VeryLazy",
		config = function()
			require("auto-save").setup({
				enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
				execution_message = {
					message = function() -- message to print on save
						return "AutoSave"
					end,
					dim = 0.18, -- dim the color of `message`
					cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
				},
				trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
				condition = function(buf)
					local fn = vim.fn
					local utils = require("auto-save.utils.data")
					if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
						return true -- met condition(s), can save
					end
					return false
				end,
				write_all_buffers = false,
				debounce_delay = 135,
			})
		end,
	},
	{
		"nvim-lua/plenary.nvim",
		event = "VeryLazy",
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
		config = function()
			require("nvim-web-devicons").setup({
				-- your personnal icons can go here (to override)
				-- you can specify color or cterm_color instead of specifying both of them
				-- DevIcon will be appended to `name`
				override = {
					zsh = {
						icon = "",
						color = "#428850",
						cterm_color = "65",
						name = "Zsh",
					},
				},
				-- globally enable different highlight colors per icon (default to true)
				-- if set to false all icons will have the default icon's color
				color_icons = true,
				-- globally enable default icons (default to false)
				-- will get overriden by `get_icons` option
				default = true,
				-- globally enable "strict" selection of icons - icon will be looked up in
				-- different tables, first by filename, and if not found by extension; this
				-- prevents cases when file doesn't have any extension but still gets some icon
				-- because its name happened to match some extension (default to false)
				strict = true,
				-- same as `override` but specifically for overrides by filename
				-- takes effect when `strict` is true
				override_by_filename = {
					[".gitignore"] = {
						icon = "",
						color = "#f1502f",
						name = "Gitignore",
					},
				},
				-- same as `override` but specifically for overrides by extension
				-- takes effect when `strict` is true
				override_by_extension = {
					["log"] = {
						icon = "",
						color = "#81e043",
						name = "Log",
					},
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = {
					history = true,
					updateevents = "TextChanged,TextChangedI",
					enable_autosnippets = true,
					store_selection_keys = "<Tab>",
				},
				config = function(_, opts)
					require("luasnip").config.set_config(opts)
					require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })
					vim.keymap.set({ "i" }, "<C-K>", function()
						require("luasnip").expand()
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-L>", function()
						require("luasnip").jump(1)
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-J>", function()
						require("luasnip").jump(-1)
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-E>", function()
						if require("luasnip").choice_active() then
							require("luasnip").change_choice(1)
						end
					end, { silent = true })
				end,
			},
			{
				"zbirenbaum/copilot-cmp",
				config = function()
					require("copilot_cmp").setup({
						suggestion = { enabled = true },
						panel = { enabled = true },
					})
				end,
			},
			{
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-buffer",
			},
		},
		config = function(_)
			local cmp = require("cmp")
			cmp.setup({
				experimental = {
					ghost_text = true,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
						-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", group_index = 1 },
					{ name = "nvim_lua", group_index = 1 },
					{ name = "path", group_index = 1 },
					{ name = "copilot", group_index = 2 },
					-- { name = "luasnip", group_index = 1 },
				}, {
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- 	event = "VeryLazy",
	-- 	-- follow latest release.
	-- 	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- 	-- install jsregexp (optional!).
	-- 	build = "make install_jsregexp",
	-- 	config = function()
	-- 		local ls = require("luasnip")
	-- 		vim.keymap.set({ "i" }, "<C-K>", function()
	-- 			ls.expand()
	-- 		end, { silent = true })
	-- 		vim.keymap.set({ "i", "s" }, "<C-L>", function()
	-- 			ls.jump(1)
	-- 		end, { silent = true })
	-- 		vim.keymap.set({ "i", "s" }, "<C-J>", function()
	-- 			ls.jump(-1)
	-- 		end, { silent = true })
	--
	-- 		vim.keymap.set({ "i", "s" }, "<C-E>", function()
	-- 			if ls.choice_active() then
	-- 				ls.change_choice(1)
	-- 			end
	-- 		end, { silent = true })
	-- 	end,
	-- },
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
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
				highlight = { enable = true },
				indent = { enable = true },
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
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter.configs").setup({
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
		event = "VeryLazy",
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
			end, { noremap = true, silent = true })
			vim.keymap.set("n", "[]", function()
				treesitter_ctx.toggle()
			end, { noremap = true, silent = true })
			treesitter_ctx.disable()
		end,
	},
	{
		"stevearc/conform.nvim",
		lazy = true,
		keys = { "<lt>r" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { { "prettierd", "prettier" } },
					rust = { "rustfmt" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					python = { "isort", "black" },
					json = { "jq" },
				},
				formatters = {
					["clang-format"] = {
						prepend_args = { "-style", "file" },
					},
				},
				log_level = vim.log.levels.ERROR,
				notify_on_error = true,
			})

			function GetGitFilePath()
				local bufname = vim.fn.bufname("%")
				local filepath = vim.fn.fnamemodify(bufname, ":p")
				local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
				if vim.v.shell_error ~= 0 then
					return nil
				end
				local relative_path = filepath:sub(#git_root + 2)
				return relative_path
			end

			function Format()
				local buf = vim.api.nvim_get_current_buf()
				require("conform").format({ bufnr = buf })
			end

			function FormatDiff()
				local gitpath = GetGitFilePath()
				if gitpath ~= nil then
					os.execute(
						"git diff -U0 --no-color --relative HEAD -- " .. gitpath .. " | clang-format-diff -p1 -i"
					)
					vim.api.nvim_command("e")
				end
			end

			require("which-key").add({
				{
					"<lt>r",
					Format,
					mode = "n",
					noremap = true,
					silent = true,
					desc = "Conform format",
				},
				-- {
				-- 	"<lt>d",
				-- 	FormatDiff,
				-- 	noremap = true,
				-- 	silent = true,
				-- 	desc = "Conform format diff",
				-- },
			})
		end,
	},
	{
		"mg979/vim-visual-multi",
		lazy = true,
		keys = { "<c-n>" },
	},
	-- View
	{
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				-- optionally use on_attach to set keymaps when aerial has attached to a buffer
				on_attach = function(bufnr)
					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
		end,
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"folke/trouble.nvim",
		lazy = "true",
		cmd = "Trouble",
		opts = {
			position = "right",
		},
		keys = {
			{
				"<lt>x",
				"<cmd>Trouble diagnostics toggle filter.buf=0 win.position=right<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<lt>X",
				"<cmd>Trouble diagnostics toggle win.position=right<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<lt>i",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			require("noice").setup({
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = true, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
				messages = {
					-- notify
					-- split
					-- vsplit
					-- popup
					-- mini
					-- cmdline
					-- cmdline_popup
					-- cmdline_output
					-- messages
					-- confirm
					-- hover
					-- popupmenu
					enabled = true, -- enables the Noice messages UI
					view = "notify", -- default view for messages
					view_error = "popup", -- view for errors
					view_warn = "mini", -- view for warnings
					view_history = "messages", -- view for :messages
					view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
				},
				routes = {
					{
						filter = {
							event = "msg_show",
							cmdline = ":w",
						},
						opts = { skip = true },
					},
					{
						filter = {
							event = "msg_show",
							find = "AutoSave",
						},
						opts = { skip = true },
					},
					{
						filter = {
							event = "msg_show",
							find = "Hunk",
						},
						opts = { skip = true },
					},
				},
				popupmenu = {
					enabled = true, -- enables the Noice popupmenu UI
					backend = "nui", -- backend to use to show regular cmdline completions
					kind_icons = {}, -- set to `false` to disable icons
				},
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"LhKipp/nvim-nu",
		lazy = true,
		ft = { "nu" },
		config = function()
			require("nu").setup({
				use_lsp_features = false,
			})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	},
	{
		"folke/twilight.nvim",
		cmd = { "Twilight" },
		lazy = true,
		opts = {
			dimming = {
				alpha = 0.25, -- amount of dimming
				-- we try to get the foreground from the highlight groups or fallback color
				color = { "Normal", "#ffffff" },
				term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
				inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
			},
			context = 10, -- amount of lines we will try to show around the current line
			treesitter = true, -- use treesitter when available for the filetype
			-- treesitter is used to automatically expand the visible text,
			-- but you can further control the types of nodes that should always be fully expanded
			expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
				"function",
				"method",
				"table",
				"if_statement",
			},
			exclude = {}, -- exclude these filetypes
		},
	},
	{
		"folke/zen-mode.nvim",
		dependencies = {
			"folke/twilight.nvim",
		},
		lazy = true,
		cmd = { "ZenMode" },
		keys = { "<lt>z" },
		opts = {
			window = {
				backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
				width = 120, -- width of the Zen window
				height = 1, -- height of the Zen window
				options = {},
			},
			plugins = {
				options = {
					enabled = true,
					ruler = false, -- disables the ruler text in the cmd line area
					showcmd = false, -- disables the command in the last line of the screen
					laststatus = 0, -- turn off the statusline in zen mode
				},
				twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
				gitsigns = { enabled = false }, -- disables git signs
				tmux = { enabled = false }, -- disables the tmux statusline
				kitty = {
					enabled = true,
					font = "+4", -- font size increment
				},
				alacritty = {
					enabled = true,
					font = "14", -- font size
				},
				wezterm = {
					enabled = false,
					-- can be either an absolute font size or the number of incremental steps
					font = "+4", -- (10% increase per step)
				},
			},
		},
		config = function()
			require("zen-mode").setup({})
			require("which-key").add({
				{
					"<lt>z",
					require("zen-mode").toggle,
					mode = "n",
					noremap = true,
					silent = true,
					desc = "Zenmode toggle",
				},
			})
		end,
	},
	{
		"Tyler-Barham/floating-help.nvim",
		event = "VeryLazy",
		config = function()
			local fh = require("floating-help")
			fh.setup({
				-- Defaults
				width = 80, -- Whole numbers are columns/rows
				height = 0.9, -- Decimals are a percentage of the editor
				position = "E", -- NW,N,NW,W,C,E,SW,S,SE (C==center)
				border = "rounded", -- rounded,double,single
			})
			require("which-key").add({
				{
					"<F1>",
					fh.toggle,
					noremap = true,
					silent = true,
					desc = "Floating help",
				},
				{
					"<F3>",
					function()
						fh.open("t=cppman", vim.fn.expand("<cword>"))
					end,
					noremap = true,
					silent = true,
					desc = "Floating cppman",
				},
				{
					"<F4>",
					function()
						fh.open("t=man", vim.fn.expand("<cword>"))
					end,
					noremap = true,
					silent = true,
					desc = "Floating linux man",
				},
			})

			local function cmd_abbrev(abbrev, expansion)
				local cmd = "cabbr "
					.. abbrev
					.. ' <c-r>=(getcmdpos() == 1 && getcmdtype() == ":" ? "'
					.. expansion
					.. '" : "'
					.. abbrev
					.. '")<CR>'
				vim.cmd(cmd)
			end
			-- Redirect `:h` to `:FloatingHelp`
			cmd_abbrev("h", "FloatingHelp")
			cmd_abbrev("help", "FloatingHelp")
			cmd_abbrev("helpc", "FloatingHelpClose")
			cmd_abbrev("helpclose", "FloatingHelpClose")
		end,
	},
	{
		"lomes0/sidebar.nvim",
		event = "VeryLazy",
		cond = function()
			return not vim.api.nvim_get_option_value("diff", { win = 0 })
		end,
		config = function()
			require("sidebar-nvim").setup({
				open = false,
				disable_default_keybindings = 1,
				bindings = nil,
				side = "left",
				initial_width = 35,
				hide_statusline = true,
				update_interval = 0,
				sections = {
					"files",
					"buffers",
				},
				section_separator = { "", "", "" },
				section_title_separator = { "---------" },
				containers = {
					attach_shell = "/bin/sh",
					show_all = true,
					interval = 5000,
				},
				todos = { ignored_paths = { "~" } },
				files = {
					icon = "",
					show_hidden = false,
					ignored_paths = { "%.git$" },
				},
				buffers = {
					icon = "",
					ignored_buffers = {}, -- ignore buffers by regex
					sorting = "name", -- alternatively set it to "name" to sort by buffer name instead of buf id
					show_numbers = false, -- whether to also show the buffer numbers
					ignore_not_loaded = true, -- whether to ignore not loaded buffers
					ignore_terminal = true, -- whether to show terminal buffers in the list
				},
			})
			vim.api.nvim_create_autocmd(
				{ "BufAdd", "BufDelete", "BufEnter", "TabEnter", "ModeChanged", "DiagnosticChanged" },
				{
					callback = function()
						require("sidebar-nvim").update()
					end,
				}
			)
			vim.keymap.set(
				"n",
				"`",
				require("sidebar-nvim").toggle,
				{ noremap = true, silent = true, desc = "Sidebar toggle" }
			)
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {
						"filename",
						{
							"_G.clipboard_icon",
						},
					},
					lualine_e = {},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
	-- Lsp
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"rmagatti/goto-preview",
		lazy = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local refs_opts = {
				layout_strategy = "horizontal",
				sorting_strategy = "descending",
				layout_config = {
					height = math.ceil(vim.o.lines * 0.8), -- maximally available lines
					width = math.ceil(vim.o.columns * 0.85), -- maximally available columns
					prompt_position = "bottom",
				},
				hide_preview = false,
				mappings = {
					n = {
						["<S-t>"] = require("telescope.actions").select_tab,
						["<S-h>"] = require("telescope.actions").select_vertical,
						["<S-k>"] = require("telescope.actions").select_horizontal,
					},
					i = {
						["<esc>"] = require("telescope.actions").close,
						["<S-t>"] = require("telescope.actions").select_tab,
						["<S-h>"] = require("telescope.actions").select_vertical,
						["<S-k>"] = require("telescope.actions").select_horizontal,
					},
				},
			}

			require("goto-preview").setup({
				width = 120, -- Width of the floating window
				height = 15, -- Height of the floating window
				border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
				default_mappings = false, -- Bind default mappings
				debug = false, -- Print debug information
				opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
				resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
				post_open_hook = nil,
				post_close_hook = nil,
				references = { -- Configure the telescope UI for slowing the references cycling window.
					telescope = require("telescope.themes").get_dropdown(refs_opts),
				},
				-- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
				focus_on_open = true, -- Focus the floating window when opening it.
				dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
				force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
				bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
				stack_floating_preview_windows = true, -- Whether to nest floating windows
				preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
				same_file_float_preview = true,
			})
			require("which-key").add({
				{
					"gpr",
					require("goto-preview").goto_preview_references,
					noremap = true,
					silent = true,
					desc = "Lsp preview references",
				},
				{
					"gpt",
					require("goto-preview").goto_preview_type_definition,
					noremap = true,
					silent = true,
					desc = "Lsp preview definitions",
				},
				{
					"gpi",
					require("goto-preview").goto_preview_implementation,
					noremap = true,
					silent = true,
					desc = "Lsp preview implementations",
				},
				{
					"gpd",
					require("goto-preview").goto_preview_declaration,
					noremap = true,
					silent = true,
					desc = "Lsp preview declaration",
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		config = function()
			require("mason").setup({})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = {
			"VonHeikemen/lsp-zero.nvim",
		},
		cond = function()
			return not vim.bo.filetype == "mdx"
		end,
		config = function()
			local lsp = require("lsp-zero")
			require("mason-lspconfig").setup({
				-- Replace the language servers listed here
				-- with the ones you want to install
				ensure_installed = { "tsserver", "rust_analyzer", "clangd" },
				handlers = {
					lsp.default_setup,
				},
			})
		end,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		event = "VeryLazy",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		branch = "v3.x",
		config = function()
			local lsp = require("lsp-zero")
			local cmp = require("cmp")
			local cmp_action = require("lsp-zero").cmp_action()
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			lsp.extend_lspconfig()

			lsp.preset("recommended")
			cmp.setup({
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-f>"] = cmp_action.luasnip_jump_forward(),
					["<C-b>"] = cmp_action.luasnip_jump_backward(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
					["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
					["<Enter>"] = cmp.mapping.confirm({ select = true }),
				}),
			})

			lsp.set_preferences({
				sign_icons = {},
			})

			lsp.on_attach(function(_, bufnr)
				require("which-key").add({
					{
						"gd",
						function()
							vim.lsp.buf.definition()
						end,
						buffer = bufnr,
						noremap = true,
						silent = true,
						desc = "Lsp goto definition",
					},
					{
						"gh",
						function()
							vim.lsp.buf.hover()
						end,
						buffer = bufnr,
						noremap = true,
						silent = true,
						desc = "Lsp hover",
					},
					{
						"gca",
						function()
							vim.lsp.buf.code_action()
						end,
						buffer = bufnr,
						noremap = true,
						silent = true,
						desc = "Lsp code action",
					},
				})
			end)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
	},
	{
		"lomes0/navigator.lua",
		event = "VeryLazy",
		dependencies = {
			{ "lomes0/guihua.lua", run = "cd lua/fzy && make" },
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("navigator").setup({
				debug = false,
				width = 0.75, -- max width ratio (number of cols for the floating window) / (window width)
				height = 0.3, -- max list window height, 0.3 by default
				preview_height = 0.35, -- max height of preview windows
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- border style, can be one of 'none', 'single', 'double',
				ts_fold = {
					enable = false,
					max_lines_scan_comments = 30, -- only fold when the fold level higher than this value
					disable_filetypes = { "help", "guihua", "text" }, -- list of filetypes which doesn't fold using treesitter
				},
				default_mapping = false, -- set to false if you will remap every key or if you using old version of nvim-
				keymaps = {
					{
						key = "grn",
						func = require("navigator.rename").rename,
						desc = "Lsp rename",
					},
					{
						key = "gW",
						func = require("navigator.workspace").workspace_symbol_live,
						desc = "Lsp workspace symbol fuzyy finder",
					},
					{
						key = "gwa",
						func = require("navigator.workspace").add_workspace_folder,
						desc = "Lsp add workspace folder",
					},
					{
						key = "gwr",
						func = require("navigator.workspace").remove_workspace_folder,
						desc = "Lsp remove workspace folder",
					},
					{
						key = "gwl",
						func = require("navigator.workspace").list_workspace_folders,
						desc = "Lsp print workspace folders",
					},
					{
						key = "<lt>cg",
						func = require("navigator.ctags").ctags_gen,
						desc = "Ctags generate",
					},
					{
						key = "<lt>cf",
						func = require("navigator.ctags").ctags_symbols,
						desc = "Ctags symbols",
					},
					{
						key = "<lt>cs",
						func = require("navigator.ctags").ctags,
						desc = "Ctags search",
					},
				},
				treesitter_analysis = true, -- treesitter variable context
				treesitter_navigation = true, -- bool|table false: use lsp to navigate between symbol ']r/[r', table: a list of
				treesitter_analysis_max_num = 100, -- how many items to run treesitter analysis
				treesitter_analysis_condense = true, -- condense form for treesitter analysis
				transparency = 50, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it
				lsp_signature_help = false, -- if you would like to hook ray-x/lsp_signature plugin in navigator
				signature_help_cfg = nil, -- if you would like to init ray-x/lsp_signature plugin in navigator, and pass in your own config to signature help
				icons = { -- refer to lua/navigator.lua for more icons config
					icons = false,
					code_action_icon = "🏏", -- note: need terminal support, for those not support unicode, might crash
					diagnostic_head = "🐛",
					diagnostic_head_severity_1 = "🈲",
					fold = {
						prefix = "#", -- icon to show before the folding need to be 2 spaces in display width
						separator = "", -- e.g. shows   3 lines 
					},
				},
				mason = false, -- set to true if you would like use the lsp installed by williamboman/mason
				lsp = {
					enable = true, -- skip lsp setup, and only use treesitter in navigator.
					code_action = { enable = false, sign = true, sign_priority = 40, virtual_text = true },
					code_lens_action = { enable = false, sign = true, sign_priority = 40, virtual_text = true },
					document_highlight = true, -- LSP reference highlight,
					format_on_save = false, -- {true|false} set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
					format_options = { async = false }, -- async: disable by default, the option used in vim.lsp.buf.format({async={true|false}, name = 'xxx'})
					disable_format_cap = { "sqlls", "lua_ls", "gopls" }, -- a list of lsp disable format capacity (e.g. if you using efm or vim-codeformat etc), empty {} by default
					diagnostic = {
						underline = true,
						virtual_text = true, -- show virtual for diagnostic message
						update_in_insert = false, -- update diagnostic message in insert mode
						float = { -- setup for floating windows style
							focusable = false,
							sytle = "minimal",
							border = "rounded",
							source = "always",
							header = "",
							prefix = "",
						},
					},

					hover = {
						enable = false,
						keymap = {
							["<lt>h"] = {
								go = function()
									local w = vim.fn.expand("<cWORD>")
									vim.cmd("GoDoc " .. w)
								end,
								default = function()
									local w = vim.fn.expand("<cWORD>")
									vim.lsp.buf.workspace_symbol(w)
								end,
							},
						},

						diagnostic_scrollbar_sign = { "▃", "▆", "█" }, -- experimental:  diagnostic status in scroll bar area; set to false to disable the diagnostic sign,
						diagnostic_virtual_text = false, -- show virtual for diagnostic message
						diagnostic_update_in_insert = false, -- update diagnostic message in insert mode
						display_diagnostic_qf = false, -- always show quickfix if there are diagnostic errors, set to false if you want to ignore it
						tsserver = {
							filetypes = { "typescript" }, -- disable javascript etc,
							-- set to {} to disable the lspclient for all filetypes
						},
						ctags = {
							cmd = "ctags",
							tagfile = "tags",
							options = "-R --exclude=.git --exclude=node_modules --exclude=test --exclude=vendor --excmd=number",
						},
						-- the lsp setup can be a function, .e.g
						gopls = function()
							local go = pcall(require, "go")
							if go then
								local cfg = require("go.lsp").config()
								cfg.on_attach = function(client)
									client.server_capabilities.documentFormattingProvider = false -- efm/null-ls
								end
								return cfg
							end
						end,
						lua_ls = {
							sumneko_root_path = vim.fn.expand("$HOME") .. "/github/sumneko/lua-language-server",
							sumneko_binary = vim.fn.expand("$HOME")
								.. "/github/sumneko/lua-language-server/bin/macOS/lua-language-server",
						},
						-- servers = { "cmake", "ltex" }, -- by default empty, and it should load all LSP clients avalible based on filetype
						-- but if you whant navigator load  e.g. `cmake` and `ltex` for you , you
						-- can put them in the `servers` list and navigator will auto load them.
						-- you could still specify the custom config  like this
						-- cmake = {filetypes = {'cmake', 'makefile'}, single_file_support = false},
					},
				},
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		opts = {
			-- options
		},
		config = function()
			require("fidget").setup({})
		end,
	},
	-- Coding
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		config = function()
			local dap = require("dap")
			dap.adapters.gdb = {
				type = "executable",
				command = "/usr/local/bin/gdb",
				args = { "-i", "dap" },
			}
			dap.configurations.c = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = true,
				},
			}
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup({})
			require("which-key").add({
				{
					"<lt>u",
					require("dapui").toggle,
					mode = "n",
					silent = true,
					noremap = true,
					desc = "Dapui toggle",
				},
			})
		end,
	},
	-- Navigation
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		tag = "0.1.4",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local focus_preview = function(prompt_bufnr)
				local action_state = require("telescope.actions.state")
				local picker = action_state.get_current_picker(prompt_bufnr)
				local prompt_win = picker.prompt_win
				local previewer = picker.previewer
				local winid = previewer.state.winid
				local bufnr = previewer.state.bufnr
				vim.keymap.set("n", "<Tab>", function()
					vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
				end, { buffer = bufnr })
				vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
				-- api.nvim_set_current_win(winid)
			end
			require("telescope").setup({
				defaults = {
					layout_config = {
						scroll_speed = 5,
						horizontal = {
							preview_cutoff = 120,
							preview_width = 0.75, -- Ratio of the preview width
							results_width = 0.25, -- Ratio of the results width
						},
						width = 0.75, -- Overall width ratio of the Telescope window
						height = 0.85, -- Overall height ratio of the Telescope window
					},
					file_ignore_patterns = {
						"node_modules",
						--  ".git",
					},
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
					mappings = {
						n = {
							["<C-p>"] = require("telescope.actions.layout").toggle_preview,
							["<Tab>"] = focus_preview,
							["<S-t>"] = require("telescope.actions").select_tab,
							["<S-h>"] = require("telescope.actions").select_vertical,
							["<S-k>"] = require("telescope.actions").select_horizontal,
						},
						i = {
							["<esc>"] = require("telescope.actions").close,
							["<S-t>"] = require("telescope.actions").select_tab,
							["<S-h>"] = require("telescope.actions").select_vertical,
							["<S-k>"] = require("telescope.actions").select_horizontal,
							["<C-u>"] = false,
							["<S-Tab>"] = false,
							["<Tab>"] = focus_preview,
							["<C-p>"] = require("telescope.actions.layout").toggle_preview,
						},
					},
				},
				pickers = {
					lsp_references = {
						-- theme = "dropdown",
					},
				},
			})

			local function git_root()
				local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
				if handle ~= nil then
					local result = handle:read("*a")
					handle:close()
					return result:match("^%s*(.-)%s*$")
				end
			end

			local function telescope_search_dir()
				local git_dir = git_root()
				if git_dir ~= nil then
					return git_dir
				end

				return "."
			end

			require("which-key").add({
				{
					"<lt>g",
					function()
						require("telescope.builtin").live_grep({
							cwd = telescope_search_dir(),
						})
					end,
					noremap = true,
					silent = true,
					desc = "Telescope grep",
				},
				{
					"<lt>f",
					function()
						require("telescope.builtin").find_files({
							cwd = telescope_search_dir(),
							no_ignore = false,
							hidden = true,
						})
					end,
					noremap = true,
					silent = true,
					desc = "Telescope find file",
				},
				{
					"<lt>t",
					require("telescope.builtin").treesitter,
					noremap = true,
					silent = true,
					desc = "Telescope treesitter",
				},
			})
		end,
	},
	-- {
	-- 	"swaits/zellij-nav.nvim",
	-- 	lazy = true,
	-- 	event = "VeryLazy",
	-- 	keys = {
	-- 		{ "<C-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" } },
	-- 		{ "<C-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
	-- 		{ "<C-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
	-- 		{ "<C-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
	-- 	},
	-- 	opts = {},
	-- },
	{
		"mikavilpas/yazi.nvim",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("yazi").setup({
				open_for_directories = false,
			})
		end,
		keys = {
			{
				"\\",
				function()
					require("yazi").yazi()
				end,
				desc = "Open the file manager",
			},
		},
		opts = {
			-- enable this if you want to open yazi instead of netrw.
			-- Note that if you enable this, you need to call yazi.setup() to
			-- initialize the plugin. lazy.nvim does this for you in certain cases.
			open_for_directories = false,
			floating_window_scaling_factor = 0.85,
			-- the transparency of the yazi floating window (0-100). See :h winblend
			yazi_floating_window_winblend = 0,

			log_level = vim.log.levels.OFF,
			yazi_floating_window_border = "none",
		},
	},
	-- Git
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")
					require("which-key").add({
						{
							" ",
							function()
								if vim.wo.diff then
									vim.cmd.normal({ "]c", bang = true })
								else
									gitsigns.nav_hunk("next")
								end
							end,
							mode = "n",
							noremap = true,
							silent = true,
							buffer = bufnr,
							desc = "Gitsigns next change",
						},
						{
							"sa",
							gitsigns.stage_hunk,
							mode = "n",
							noremap = true,
							silent = true,
							buffer = bufnr,
							desc = "Gitsigns stage hunk",
						},
						{
							"s",
							function()
								gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
							end,
							mode = "v",
							noremap = true,
							silent = true,
							buffer = bufnr,
							desc = "Gitsigns stage selection",
						},
						{
							"sb",
							gitsigns.stage_buffer,
							mode = "n",
							noremap = true,
							silent = true,
							buffer = bufnr,
							desc = "Gitsigns stage buffer",
						},
						{
							"su",
							gitsigns.undo_stage_hunk,
							mode = "n",
							noremap = true,
							silent = true,
							buffer = bufnr,
							desc = "Gitsigns stage undo",
						},
						{
							"sR",
							gitsigns.reset_buffer,
							mode = "n",
							noremap = true,
							silent = true,
							buffer = bufnr,
							desc = "Gitsigns reset buffer",
						},
						{
							"sp",
							gitsigns.preview_hunk,
							mode = "n",
							noremap = true,
							silent = true,
							buffer = bufnr,
							desc = "Gitsigns preview hunk",
						},
						{
							"st",
							gitsigns.toggle_current_line_blame,
							mode = "n",
							noremap = true,
							silent = true,
							buffer = bufnr,
							desc = "Gitsigns toggle blame",
						},
						{
							"sd",
							gitsigns.diffthis,
							mode = "n",
							noremap = true,
							silent = true,
							buffer = bufnr,
							desc = "Gitsigns diffthis",
						},
					})

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
	-- Colors
	{
		"rose-pine/neovim",
		lazy = "true",
		config = function()
			require("rose-pine").setup({
				variant = "main", -- auto, main, moon, or dawn
				dark_variant = "moon", -- main, moon, or dawn
				dim_inactive_windows = false,
				extend_background_behind_borders = true,
				enable = {
					terminal = true,
					legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
					migrations = true, -- Handle deprecated options automatically
				},

				styles = {
					bold = true,
					italic = true,
					transparency = true,
				},
				groups = {
					border = "muted",
					link = "iris",
					panel = "surface",
					error = "love",
					hint = "iris",
					info = "foam",
					note = "pine",
					todo = "rose",
					warn = "gold",
					git_add = "foam",
					git_change = "rose",
					git_delete = "love",
					git_dirty = "rose",
					git_ignore = "muted",
					git_merge = "iris",
					git_rename = "pine",
					git_stage = "iris",
					git_text = "rose",
					git_untracked = "subtle",
					h1 = "iris",
					h2 = "foam",
					h3 = "rose",
					h4 = "gold",
					h5 = "pine",
					h6 = "foam",
				},
				highlight_groups = {
					-- Comment = { fg = "foam" },
					-- VertSplit = { fg = "muted", bg = "muted" },
				},
				before_highlight = function(_, highlight, palette)
					-- Change palette colour
					if highlight.fg == palette.pine then
						highlight.fg = "#a59dc7"
					end
				end,
			})
		end,
	},
	{
		"catppuccin/nvim",
		event = "VeryLazy",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false, -- disables setting the background color.
				show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
				term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = false, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.001, -- percentage of the shade to apply to the inactive window
				},
				no_italic = false, -- Force no italic
				no_bold = false, -- Force no bold
				no_underline = false, -- Force no underline
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				color_overrides = {},
				custom_highlights = {},
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					notify = false,
					mini = {
						enabled = true,
						indentscope_color = "",
					},
				},
			})
		end,
	},
	{
		"sho-87/kanagawa-paper.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa-paper").setup({
				undercurl = true,
				transparent = true,
				gutter = false,
				dimInactive = false, -- disabled when transparent
				terminalColors = true,
				commentStyle = { italic = true },
				functionStyle = { italic = false },
				keywordStyle = { italic = false, bold = false },
				statementStyle = { italic = false, bold = false },
				typeStyle = { italic = false },
				colors = { theme = {}, palette = {} }, -- override default palette and theme colors
				overrides = function() -- override highlight groups
					return {}
				end,
			})
		end,
	},
})
