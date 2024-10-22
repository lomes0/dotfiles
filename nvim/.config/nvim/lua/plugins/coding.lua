return {
	{
		"t-troebst/perfanno.nvim",
		config = function()
			local perfanno = require("perfanno")
			local util = require("perfanno.util")

			perfanno.setup({
				-- Creates a 10-step RGB color gradient beween background color and "#CC3300"
				line_highlights = util.make_bg_highlights(nil, "#CC3300", 10),
				vt_highlight = util.make_fg_highlight("#CC3300"),
			})

			local keymap = vim.api.nvim_set_keymap
			local opts = { noremap = true, silent = true }

			keymap("n", "<LEADER>plf", ":PerfLoadFlat<CR>", opts)
			keymap("n", "<LEADER>plg", ":PerfLoadCallGraph<CR>", opts)
			keymap("n", "<LEADER>plo", ":PerfLoadFlameGraph<CR>", opts)

			keymap("n", "<LEADER>pe", ":PerfPickEvent<CR>", opts)

			keymap("n", "<LEADER>pa", ":PerfAnnotate<CR>", opts)
			keymap("n", "<LEADER>pf", ":PerfAnnotateFunction<CR>", opts)
			keymap("v", "<LEADER>pa", ":PerfAnnotateSelection<CR>", opts)

			keymap("n", "<LEADER>pt", ":PerfToggleAnnotations<CR>", opts)

			keymap("n", "<LEADER>ph", ":PerfHottestLines<CR>", opts)
			keymap("n", "<LEADER>ps", ":PerfHottestSymbols<CR>", opts)
			keymap("n", "<LEADER>pc", ":PerfHottestCallersFunction<CR>", opts)
			keymap("v", "<LEADER>pc", ":PerfHottestCallersSelection<CR>", opts)
		end,
	},
	{
		"dhananjaylatkar/cscope_maps.nvim",
		dependencies = {
			"folke/snacks.nvim", -- optional [for picker="snacks"]
		},
		opts = {
			-- maps related defaults
			disable_maps = false, -- "true" disables default keymaps
			skip_input_prompt = true, -- "true" doesn't ask for input
			prefix = "<leader>c", -- prefix to trigger maps

			-- cscope related defaults
			cscope = {
				-- location of cscope db file
				db_file = "./cscope.out", -- DB or table of DBs
				-- NOTE:
				--   when table of DBs is provided -
				--   first DB is "primary" and others are "secondary"
				--   primary DB is used for build and project_rooter
				-- cscope executable
				exec = "cscope", -- "cscope" or "gtags-cscope"
				-- choose your fav picker
				picker = "quickfix", -- "quickfix", "telescope", "fzf-lua", "mini-pick" or "snacks"
				-- size of quickfix window
				qf_window_size = 5, -- any positive integer
				-- position of quickfix window
				qf_window_pos = "bottom", -- "bottom", "right", "left" or "top"
				-- "true" does not open picker for single result, just JUMP
				skip_picker_for_single_result = false, -- "false" or "true"
				-- custom script can be used for db build
				db_build_cmd = { script = "default", args = { "-bqkv" } },
				-- statusline indicator, default is cscope executable
				statusline_indicator = nil,
				-- try to locate db_file in parent dir(s)
				project_rooter = {
					enable = false, -- "true" or "false"
					-- change cwd to where db_file is located
					change_cwd = false, -- "true" or "false"
				},
			},
			-- stack view defaults
			stack_view = {
				tree_hl = true, -- toggle tree highlighting
			},
		},
		config = function(_, opts)
			require("cscope_maps").setup(opts)

			local group = vim.api.nvim_create_augroup("CscopeBuild", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.c", "*.h" },
				callback = function()
					vim.cmd("Cscope db build")
				end,
				group = group,
			})
		end,
	},
	{
		"daishengdong/calltree.nvim",
		dependencies = {
			"dhananjaylatkar/cscope_maps.nvim",
		},
		opts = {
			prefix = "<leader>o", -- keep consistent with cscope_maps
			-- brief: only shows a symbol's name
			-- detailed: shows just more details
			-- detailed_paths: shows filename and line number
			tree_style = "brief", -- alternatives: detailed, detailed_paths
		},
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		dependencies = {
			{
				"junegunn/fzf",
				run = function()
					vim.fn["fzf#install"]()
				end,
			},
		},
		init = function()
			local function qbf_move_entry(direction)
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				local last_line = vim.api.nvim_buf_line_count(0)
				local next_cursor_pos = { cursor_pos[1] + direction, cursor_pos[2] }

				if (cursor_pos[1] == last_line and direction == 1) or (cursor_pos[1] == 1 and direction == -1) then
					return
				end

				local qhandler = require("bqf.qfwin.handler")
				local qwinid = vim.api.nvim_get_current_win()
				vim.api.nvim_win_set_cursor(0, next_cursor_pos)
				qhandler.open(false, false, qwinid, next_cursor_pos[1])

				vim.opt.cursorline = true
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#4f5669", fg = "", blend = 0 })
				vim.api.nvim_set_current_win(qwinid)
			end

			function _G.quickfix_j_key()
				qbf_move_entry(1)
			end

			function _G.quickfix_k_key()
				qbf_move_entry(-1)
			end

			-- Create autocmd for quickfix window
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "qf",
				callback = function()
					vim.api.nvim_buf_set_keymap(
						0,
						"n",
						"j",
						":lua _G.quickfix_j_key()<cr>",
						{ noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(
						0,
						"n",
						"k",
						":lua _G.quickfix_k_key()<cr>",
						{ noremap = true, silent = true }
					)
				end,
			})

			vim.api.nvim_create_autocmd("WinClosed", {
				callback = function(args)
					local winid = tonumber(args.match)
					if vim.fn.getwininfo(winid)[1] and vim.fn.getwininfo(winid)[1].quickfix then
						vim.opt.cursorline = false
					end
				end,
			})
		end,
		config = function(_, opts)
			require("bqf").setup({
				previous_winid_ft_skip = false,
				auto_enable = true,
				magic_window = true,
				auto_resize_height = false,
				preview = {
					auto_preview = false,
					border = "rounded",
					show_title = true,
					show_scroll_bar = true,
					delay_syntax = 50,
					win_height = 15,
					win_vheight = 15,
					winblend = 0,
					wrap = false,
					buf_label = true,
					should_preview_cb = function()
						return true
					end,
				},
				func_map = {
					description = [[The table for {function = key}]],
					default = [[see ###Function table for detail]],
				},
				filter = {
					fzf = {
						action_for = {
							["ctrl-t"] = "tabedit",
							["ctrl-v"] = "vsplit",
							["ctrl-x"] = "split",
							["ctrl-q"] = "signtoggle",
							["ctrl-c"] = "closeall",
						},
						extra_opts = { "--bind", "ctrl-o:toggle-all" },
					},
				},
			})
		end,
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		config = function(_, opts)
			require("trouble").setup({
				auto_close = false, -- auto close when there are no items
				auto_preview = false, -- automatically open preview when on an item
				auto_refresh = false, -- auto refresh when open
				auto_jump = false, -- auto jump to the item when there's only one
				focus = false, -- Focus the window when opened
				restore = true, -- restores the last location in the list when opening
				follow = false, -- Follow the current item
				indent_guides = true, -- show indent guides
				max_items = 200, -- limit number of items that can be displayed per section
				multiline = true, -- render multi-line messages
				pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
				warn_no_results = true, -- show a warning when there are no results
				open_no_results = false, -- open the trouble window when there are no results
				---@type trouble.Window.opts
				win = {}, -- window options for the results window. Can be a split or a floating window.
				-- Window options for the preview window. Can be a split, floating window,
				-- or `main` to show the preview in the main editor window.
				---@type trouble.Window.opts
				preview = {
					type = "main",
					-- when a buffer is not yet loaded, the preview window will be created
					-- in a scratch buffer with only syntax highlighting enabled.
					-- Set to false, if you want the preview to always be a real loaded buffer.
					scratch = true,
				},
				-- Throttle/Debounce settings. Should usually not be changed.
				---@type table<string, number|{ms:number, debounce?:boolean}>
				throttle = {
					refresh = 20, -- fetches new data when needed
					update = 10, -- updates the window
					render = 10, -- renders the window
					follow = 100, -- follows the current item
					preview = { ms = 100, debounce = true }, -- shows the preview for the current item
				},
				---@type table<string, trouble.Mode>
				modes = {
					diagnostics = {
						win = {
							position = "right",
							relative = "win",
							size = 0.3,
						},
						auto_open = false,
					},
					lsp_document_symbols = {
						win = {
							position = "right",
							relative = "win",
							size = 0.3,
						},
						auto_open = false,
					},
					-- sources define their own modes, which you can use directly,
					-- or override like in the example below
					lsp_references = {
						-- some modes are configurable, see the source code for more details
						params = {
							include_declaration = true,
						},
					},
					-- The LSP base mode for:
					-- * lsp_definitions, lsp_references, lsp_implementations
					-- * lsp_type_definitions, lsp_declarations, lsp_command
					lsp_base = {
						params = {
							-- don't include the current location in the results
							include_current = false,
						},
					},
					-- more advanced example that extends the lsp_document_symbols
					symbols = {
						desc = "document symbols",
						mode = "lsp_document_symbols",
						focus = false,
						win = { position = "right" },
						filter = {
							-- remove Package since luals uses it for control flow structures
							["not"] = { ft = "lua", kind = "Package" },
							any = {
								-- all symbol kinds for help / markdown files
								ft = { "help", "markdown" },
								-- default set of symbol kinds
								kind = {
									"Class",
									"Constructor",
									"Enum",
									"Field",
									"Function",
									"Interface",
									"Method",
									"Module",
									"Namespace",
									"Package",
									"Property",
									"Struct",
									"Trait",
								},
							},
						},
					},
				},
			})
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*.c",
				callback = function()
					require("trouble").refresh()
				end,
			})
		end,
		keys = {
			{
				"<F11>",
				function()
					local trouble = require("trouble")
					local opts = { mode = "diagnostics", focus = false }
					trouble.toggle(opts)
				end,
				desc = "Trouble Buffer Diagnostics",
			},
			{
				"<F10>",
				function()
					local trouble = require("trouble")
					local opts = { mode = "lsp_document_symbols", focus = false }
					trouble.toggle(opts)
				end,
				desc = "Trouble Buffer Symbols",
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				lazy = false,
				opts = {
					history = true,
					updateevents = "TextChanged,TextChangedI",
					enable_autosnippets = true,
					store_selection_keys = "<Tab>",
				},
				config = function(_, opts)
					local luasnip = require("luasnip")
					local luasnip_loaders = require("luasnip.loaders.from_lua")

					luasnip.config.set_config(opts)
					luasnip_loaders.load({
						paths = { "~/.config/nvim/LuaSnip/" },
					})
					vim.keymap.set({ "i" }, "<C-K>", function()
						luasnip.expand()
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-E>", function()
						if luasnip.choice_active() then
							luasnip.change_choice(1)
						end
					end, { silent = true })

					vim.api.nvim_create_autocmd("User", {
						pattern = "LuasnipInsertNodeEnter",
						callback = function()
							vim.keymap.set({ "i", "s" }, "<Tab>", function()
								luasnip.jump(1)
							end, { silent = true })
							vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
								luasnip.jump(-1)
							end, { silent = true })
						end,
					})

					vim.api.nvim_create_autocmd("User", {
						pattern = "LuasnipInsertNodeLeave",
						callback = function()
							vim.keymap.del({ "i", "s" }, "<Tab>", { silent = true })
							vim.keymap.del({ "i", "s" }, "<S-Tab>", { silent = true })
						end,
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
				"saadparwaiz1/cmp_luasnip",
			},
		},
		config = function(_, opts)
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local luasnip = require("luasnip")

			cmp.setup({
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				snippet = {
					expand = function(args)
						-- You need Neovim v0.10 to use vim.snippet
						-- vim.snippet.expand(args.body)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
					["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{
						name = "luasnip",
						group_index = 3,
					},
					{
						name = "nvim_lsp",
						group_index = 4,
					},
					{
						name = "nvim_lua",
						group_index = 5,
					},
					{
						name = "path",
						group_index = 2,
					},
					{
						name = "buffer",
						group_index = 1,
						option = {
							get_bufnrs = function()
								local bufs = {}
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									bufs[vim.api.nvim_win_get_buf(win)] = true
								end
								return vim.tbl_keys(bufs)
							end,
						},
					},
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

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
}
