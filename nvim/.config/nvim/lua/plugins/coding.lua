return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- set this if you want to always pull the latest change
		build = "make",
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-tree/nvim-web-devicons",
			{ "zbirenbaum/copilot.lua" },
			{
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
					win_options = {
						concealcursor = {
							default = vim.api.nvim_get_option_value("concealcursor", {}),
							rendered = "nc",
						},
					},
				},
				ft = { "markdown", "Avante" },
			},
		},
		opts = {
			provider = "ollama",
			auto_suggestions_provider = "ollama",
			vendors = {
				ollama = {
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
								messages = require("avante.providers").copilot.parse_messages(code_opts), -- you can make your own message, but this is very advanced
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
	},
	{
		"lomes0/nvim-bqf",
		ft = "qf",
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
		end,
	},
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
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- {
			-- 	-- snippet plugin
			-- 	"L3MON4D3/LuaSnip",
			-- 	dependencies = "rafamadriz/friendly-snippets",
			-- 	opts = {
			-- 		history = true,
			-- 		updateevents = "TextChanged,TextChangedI",
			-- 		enable_autosnippets = true,
			-- 		store_selection_keys = "<Tab>",
			-- 	},
			-- 	config = function(_, opts)
			-- 		require("luasnip").config.set_config(opts)
			-- 		require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })
			-- 		vim.keymap.set({ "i" }, "<C-K>", function()
			-- 			require("luasnip").expand()
			-- 		end, { silent = true })
			-- 		vim.keymap.set({ "i", "s" }, "<C-L>", function()
			-- 			require("luasnip").jump(1)
			-- 		end, { silent = true })
			-- 		vim.keymap.set({ "i", "s" }, "<C-J>", function()
			-- 			require("luasnip").jump(-1)
			-- 		end, { silent = true })
			-- 		vim.keymap.set({ "i", "s" }, "<C-E>", function()
			-- 			if require("luasnip").choice_active() then
			-- 				require("luasnip").change_choice(1)
			-- 			end
			-- 		end, { silent = true })
			-- 	end,
			-- },
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
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			cmp.setup({
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				snippet = {
					expand = function(args)
						-- You need Neovim v0.10 to use vim.snippet
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
					["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
				}),
				sources = cmp.config.sources({
					{
						name = "nvim_lsp",
						group_index = 4,
					},
					{
						name = "nvim_lua",
						group_index = 3,
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
					-- { name = "copilot", group_index = 2 },
					-- { name = "luasnip", group_index = 1 },
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
