return {
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
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			_G.clipboard_icon = ""
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
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		tag = "0.1.4",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"debugloop/telescope-undo.nvim",
			"nvim-telescope/telescope-dap.nvim",
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
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					undo = {},
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

			vim.keymap.set("n", "<lt>q", function()
				require("telescope.builtin").live_grep({
					cwd = telescope_search_dir(),
				})
			end, {
				noremap = true,
				silent = true,
				desc = "Telescope grep",
			})
			vim.keymap.set("n", "<lt>f", function()
				require("telescope.builtin").find_files({
					cwd = telescope_search_dir(),
				})
			end, {
				noremap = true,
				silent = true,
				desc = "Telescope find files",
			})
			vim.keymap.set("n", "<lt>t", require("telescope.builtin").treesitter, {
				noremap = true,
				silent = true,
				desc = "Telescope treesitter",
			})
			vim.keymap.set("n", "<lt>k", require("telescope.builtin").keymaps, {
				noremap = true,
				silent = true,
				desc = "Telescope keymaps",
			})

			require("telescope").load_extension("fzf")

			require("telescope").load_extension("undo")

			require("telescope").load_extension("dap")
		end,
	},
}

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
-- {
-- 	"zbirenbaum/copilot.lua",
-- 	cmd = "Copilot",
-- 	event = "InsertEnter",
-- 	config = function()
-- 		require("copilot").setup({
-- 			panel = {
-- 				enabled = true,
-- 				auto_refresh = false,
-- 				keymap = {
-- 					jump_prev = "[[",
-- 					jump_next = "]]",
-- 					accept = "<CR>",
-- 					refresh = "gr",
-- 					open = "<M-CR>",
-- 				},
-- 				layout = {
-- 					position = "bottom", -- | top | left | right
-- 					ratio = 0.4,
-- 				},
-- 			},
-- 			suggestion = {
-- 				enabled = true,
-- 				auto_trigger = false,
-- 				hide_during_completion = true,
-- 				debounce = 75,
-- 				keymap = {
-- 					accept = "<M-l>",
-- 					accept_word = false,
-- 					accept_line = false,
-- 					next = "<M-]>",
-- 					prev = "<M-[>",
-- 					dismiss = "<C-]>",
-- 				},
-- 			},
-- 			filetypes = {
-- 				yaml = false,
-- 				markdown = false,
-- 				help = false,
-- 				gitcommit = false,
-- 				gitrebase = false,
-- 				hgcommit = false,
-- 				svn = false,
-- 				cvs = false,
-- 				["."] = false,
-- 			},
-- 			copilot_node_command = "node", -- Node.js version must be > 18.x
-- 			server_opts_overrides = {},
-- 		})
-- 	end,
-- },
-- {
-- 	"yetone/avante.nvim",
-- 	event = "VeryLazy",
-- 	lazy = false,
-- 	version = false, -- set this if you want to always pull the latest change
-- 	opts = {
-- 		---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
-- 		provider = "ollama", -- Recommend using Claude
-- 		auto_suggestions_provider = "ollama", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
-- 		vendors = {
-- 			ollama = {
-- 				["local"] = true,
-- 				endpoint = "127.0.0.1:11434/v1",
-- 				model = "llama3",
-- 				parse_curl_args = function(opts, code_opts)
-- 					return {
-- 						url = opts.endpoint .. "/chat/completions",
-- 						headers = {
-- 							["Accept"] = "application/json",
-- 							["Content-Type"] = "application/json",
-- 						},
-- 						body = {
-- 							model = opts.model,
-- 							messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
-- 							max_tokens = 2048,
-- 							stream = true,
-- 						},
-- 					}
-- 				end,
-- 				parse_response_data = function(data_stream, event_state, opts)
-- 					require("avante.providers").openai.parse_response(data_stream, event_state, opts)
-- 				end,
-- 			},
-- 		},
-- 		claude = {
-- 			endpoint = "https://api.anthropic.com",
-- 			model = "claude-3-5-sonnet-20240620",
-- 			temperature = 0,
-- 			max_tokens = 4096,
-- 		},
-- 		behaviour = {
-- 			auto_suggestions = false, -- Experimental stage
-- 			auto_set_highlight_group = true,
-- 			auto_set_keymaps = true,
-- 			auto_apply_diff_after_generation = false,
-- 			support_paste_from_clipboard = false,
-- 		},
-- 		mappings = {
-- 			--- @class AvanteConflictMappings
-- 			diff = {
-- 				ours = "co",
-- 				theirs = "ct",
-- 				all_theirs = "ca",
-- 				both = "cb",
-- 				cursor = "cc",
-- 				next = "]x",
-- 				prev = "[x",
-- 			},
-- 			suggestion = {
-- 				accept = "<M-l>",
-- 				next = "<M-]>",
-- 				prev = "<M-[>",
-- 				dismiss = "<C-]>",
-- 			},
-- 			jump = {
-- 				next = "]]",
-- 				prev = "[[",
-- 			},
-- 			submit = {
-- 				normal = "<CR>",
-- 				insert = "<C-s>",
-- 			},
-- 			sidebar = {
-- 				switch_windows = "<Tab>",
-- 				reverse_switch_windows = "<S-Tab>",
-- 			},
-- 		},
-- 		hints = { enabled = true },
-- 		windows = {
-- 			---@type "right" | "left" | "top" | "bottom"
-- 			position = "right", -- the position of the sidebar
-- 			wrap = true, -- similar to vim.o.wrap
-- 			width = 45, -- default % based on available width
-- 			sidebar_header = {
-- 				align = "center", -- left, center, right for title
-- 				rounded = true,
-- 			},
-- 		},
-- 		highlights = {
-- 			diff = {
-- 				current = "DiffText",
-- 				incoming = "DiffAdd",
-- 			},
-- 		},
-- 		--- @class AvanteConflictUserConfig
-- 		diff = {
-- 			autojump = true,
-- 			---@type string | fun(): any
-- 			list_opener = "copen",
-- 		},
-- 	},
-- 	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
-- 	build = "make",
-- 	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
-- 	dependencies = {
-- 		"nvim-treesitter/nvim-treesitter",
-- 		"stevearc/dressing.nvim",
-- 		"nvim-lua/plenary.nvim",
-- 		"MunifTanjim/nui.nvim",
-- 		--- The below dependencies are optional,
-- 		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
-- 		"zbirenbaum/copilot.lua", -- for providers='copilot'
-- 		{
-- 			-- support for image pasting
-- 			"HakonHarnes/img-clip.nvim",
-- 			event = "VeryLazy",
-- 			opts = {
-- 				-- recommended settings
-- 				default = {
-- 					embed_image_as_base64 = false,
-- 					prompt_for_file_name = false,
-- 					drag_and_drop = {
-- 						insert_mode = true,
-- 					},
-- 					-- required for Windows users
-- 					use_absolute_path = true,
-- 				},
-- 			},
-- 		},
-- 		{
-- 			-- Make sure to set this up properly if you have lazy=true
-- 			"MeanderingProgrammer/render-markdown.nvim",
-- 			dependencies = {
-- 				"nvim-treesitter/nvim-treesitter",
-- 				"echasnovski/mini.nvim",
-- 			},
-- 			opts = {
-- 				file_types = { "markdown", "Avante" },
-- 				anti_conceal = { enabled = false },
-- 				win_options = {
-- 					concealcursor = {
-- 						default = vim.api.nvim_get_option_value("concealcursor", {}),
-- 						rendered = "nc",
-- 					},
-- 				},
-- 			},
-- 			ft = { "markdown", "Avante" },
-- 		},
-- 	},
-- },
-- {
-- 	"rmagatti/goto-preview",
-- 	lazy = false,
-- 	dependencies = {
-- 		"nvim-telescope/telescope.nvim",
-- 	},
-- 	config = function()
-- 		local refs_opts = {
-- 			layout_strategy = "horizontal",
-- 			sorting_strategy = "descending",
-- 			layout_config = {
-- 				height = math.ceil(vim.o.lines * 0.8), -- maximally available lines
-- 				width = math.ceil(vim.o.columns * 0.85), -- maximally available columns
-- 				prompt_position = "bottom",
-- 			},
-- 			hide_preview = false,
-- 			mappings = {
-- 				n = {
-- 					["<S-t>"] = require("telescope.actions").select_tab,
-- 					["<S-h>"] = require("telescope.actions").select_vertical,
-- 					["<S-k>"] = require("telescope.actions").select_horizontal,
-- 				},
-- 				i = {
-- 					["<esc>"] = require("telescope.actions").close,
-- 					["<S-t>"] = require("telescope.actions").select_tab,
-- 					["<S-h>"] = require("telescope.actions").select_vertical,
-- 					["<S-k>"] = require("telescope.actions").select_horizontal,
-- 				},
-- 			},
-- 		}
--
-- 		require("goto-preview").setup({
-- 			width = 120, -- Width of the floating window
-- 			height = 15, -- Height of the floating window
-- 			border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
-- 			default_mappings = false, -- Bind default mappings
-- 			debug = false, -- Print debug information
-- 			opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
-- 			resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
-- 			post_open_hook = nil,
-- 			post_close_hook = nil,
-- 			references = { -- Configure the telescope UI for slowing the references cycling window.
-- 				telescope = require("telescope.themes").get_dropdown(refs_opts),
-- 			},
-- 			-- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
-- 			focus_on_open = true, -- Focus the floating window when opening it.
-- 			dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
-- 			force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
-- 			bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
-- 			stack_floating_preview_windows = true, -- Whether to nest floating windows
-- 			preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
-- 			same_file_float_preview = true,
-- 		})
-- 		vim.keymap.set("n", "gpr", require("goto-preview").goto_preview_references, {
-- 			noremap = true,
-- 			silent = true,
-- 		})
--
-- 		vim.keymap.set("n", "gpt", require("goto-preview").goto_preview_type_definition, {
-- 			noremap = true,
-- 			silent = true,
-- 		})
--
-- 		vim.keymap.set("n", "gpi", require("goto-preview").goto_preview_implementation, {
-- 			noremap = true,
-- 			silent = true,
-- 		})
--
-- 		vim.keymap.set("n", "gpd", require("goto-preview").goto_preview_declaration, {
-- 			noremap = true,
-- 			silent = true,
-- 		})
-- 	end,
-- },
-- {
-- 	"lomes0/navigator.lua",
-- 	event = "VeryLazy",
-- 	dependencies = {
-- 		{ "lomes0/guihua.lua", run = "cd lua/fzy && make" },
-- 		"neovim/nvim-lspconfig",
-- 		"nvim-treesitter/nvim-treesitter",
-- 		"nvim-telescope/telescope.nvim",
-- 	},
-- 	config = function()
-- 		require("navigator").setup({
-- 			debug = false,
-- 			width = 0.75, -- max width ratio (number of cols for the floating window) / (window width)
-- 			height = 0.3, -- max list window height, 0.3 by default
-- 			preview_height = 0.35, -- max height of preview windows
-- 			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- border style, can be one of 'none', 'single', 'double',
-- 			ts_fold = {
-- 				enable = false,
-- 				max_lines_scan_comments = 30, -- only fold when the fold level higher than this value
-- 				disable_filetypes = { "help", "guihua", "text" }, -- list of filetypes which doesn't fold using treesitter
-- 			},
-- 			default_mapping = false, -- set to false if you will remap every key or if you using old version of nvim-
-- 			keymaps = {
-- 				{
-- 					key = "grn",
-- 					func = require("navigator.rename").rename,
-- 					desc = "Lsp rename",
-- 				},
-- 				{
-- 					key = "gW",
-- 					func = require("navigator.workspace").workspace_symbol_live,
-- 					desc = "Lsp workspace symbol fuzyy finder",
-- 				},
-- 				{
-- 					key = "gwa",
-- 					func = require("navigator.workspace").add_workspace_folder,
-- 					desc = "Lsp add workspace folder",
-- 				},
-- 				{
-- 					key = "gwr",
-- 					func = require("navigator.workspace").remove_workspace_folder,
-- 					desc = "Lsp remove workspace folder",
-- 				},
-- 				{
-- 					key = "gwl",
-- 					func = require("navigator.workspace").list_workspace_folders,
-- 					desc = "Lsp print workspace folders",
-- 				},
-- 				{
-- 					key = "<lt>cg",
-- 					func = require("navigator.ctags").ctags_gen,
-- 					desc = "Ctags generate",
-- 				},
-- 				{
-- 					key = "<lt>cf",
-- 					func = require("navigator.ctags").ctags_symbols,
-- 					desc = "Ctags symbols",
-- 				},
-- 				{
-- 					key = "<lt>cs",
-- 					func = require("navigator.ctags").ctags,
-- 					desc = "Ctags search",
-- 				},
-- 			},
-- 			treesitter_analysis = true, -- treesitter variable context
-- 			treesitter_navigation = true, -- bool|table false: use lsp to navigate between symbol ']r/[r', table: a list of
-- 			treesitter_analysis_max_num = 100, -- how many items to run treesitter analysis
-- 			treesitter_analysis_condense = true, -- condense form for treesitter analysis
-- 			transparency = 50, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it
-- 			lsp_signature_help = false, -- if you would like to hook ray-x/lsp_signature plugin in navigator
-- 			signature_help_cfg = nil, -- if you would like to init ray-x/lsp_signature plugin in navigator, and pass in your own config to signature help
-- 			icons = { -- refer to lua/navigator.lua for more icons config
-- 				icons = false,
-- 				code_action_icon = "🏏", -- note: need terminal support, for those not support unicode, might crash
-- 				diagnostic_head = "🐛",
-- 				diagnostic_head_severity_1 = "🈲",
-- 				fold = {
-- 					prefix = "#", -- icon to show before the folding need to be 2 spaces in display width
-- 					separator = "", -- e.g. shows   3 lines 
-- 				},
-- 			},
-- 			mason = false, -- set to true if you would like use the lsp installed by williamboman/mason
-- 			lsp = {
-- 				enable = true, -- skip lsp setup, and only use treesitter in navigator.
-- 				code_action = { enable = false, sign = true, sign_priority = 40, virtual_text = true },
-- 				code_lens_action = { enable = false, sign = true, sign_priority = 40, virtual_text = true },
-- 				document_highlight = true, -- LSP reference highlight,
-- 				format_on_save = false, -- {true|false} set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
-- 				format_options = { async = false }, -- async: disable by default, the option used in vim.lsp.buf.format({async={true|false}, name = 'xxx'})
-- 				disable_format_cap = { "sqlls", "lua_ls", "gopls" }, -- a list of lsp disable format capacity (e.g. if you using efm or vim-codeformat etc), empty {} by default
-- 				diagnostic = {
-- 					underline = true,
-- 					virtual_text = true, -- show virtual for diagnostic message
-- 					update_in_insert = false, -- update diagnostic message in insert mode
-- 					float = { -- setup for floating windows style
-- 						focusable = false,
-- 						sytle = "minimal",
-- 						border = "rounded",
-- 						source = "always",
-- 						header = "",
-- 						prefix = "",
-- 					},
-- 				},
--
-- 				hover = {
-- 					enable = false,
-- 					keymap = {
-- 						["<lt>h"] = {
-- 							go = function()
-- 								local w = vim.fn.expand("<cWORD>")
-- 								vim.cmd("GoDoc " .. w)
-- 							end,
-- 							default = function()
-- 								local w = vim.fn.expand("<cWORD>")
-- 								vim.lsp.buf.workspace_symbol(w)
-- 							end,
-- 						},
-- 					},
--
-- 					diagnostic_scrollbar_sign = { "▃", "▆", "█" }, -- experimental:  diagnostic status in scroll bar area; set to false to disable the diagnostic sign,
-- 					diagnostic_virtual_text = false, -- show virtual for diagnostic message
-- 					diagnostic_update_in_insert = false, -- update diagnostic message in insert mode
-- 					display_diagnostic_qf = false, -- always show quickfix if there are diagnostic errors, set to false if you want to ignore it
-- 					tsserver = {
-- 						filetypes = { "typescript" }, -- disable javascript etc,
-- 						-- set to {} to disable the lspclient for all filetypes
-- 					},
-- 					ctags = {
-- 						cmd = "ctags",
-- 						tagfile = "tags",
-- 						options = "-R --exclude=.git --exclude=node_modules --exclude=test --exclude=vendor --excmd=number",
-- 					},
-- 					-- the lsp setup can be a function, .e.g
-- 					gopls = function()
-- 						local go = pcall(require, "go")
-- 						if go then
-- 							local cfg = require("go.lsp").config()
-- 							cfg.on_attach = function(client)
-- 								client.server_capabilities.documentFormattingProvider = false -- efm/null-ls
-- 							end
-- 							return cfg
-- 						end
-- 					end,
-- 					lua_ls = {
-- 						sumneko_root_path = vim.fn.expand("$HOME") .. "/github/sumneko/lua-language-server",
-- 						sumneko_binary = vim.fn.expand("$HOME")
-- 							.. "/github/sumneko/lua-language-server/bin/macOS/lua-language-server",
-- 					},
-- 					-- servers = { "cmake", "ltex" }, -- by default empty, and it should load all LSP clients avalible based on filetype
-- 					-- but if you whant navigator load  e.g. `cmake` and `ltex` for you , you
-- 					-- can put them in the `servers` list and navigator will auto load them.
-- 					-- you could still specify the custom config  like this
-- 					-- cmake = {filetypes = {'cmake', 'makefile'}, single_file_support = false},
-- 				},
-- 			},
-- 		})
-- 	end,
-- },
