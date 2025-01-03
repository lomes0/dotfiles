return {
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
		"stevearc/conform.nvim",
		lazy = true,
		keys = {
			{
				"<lt>r",
				function()
					require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
				end,
				desc = "Conform format",
			},
			{
				"<lt>R",
				function()
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

					local gitpath = GetGitFilePath()
					if gitpath ~= nil then
						os.execute(
							"git diff -U0 --no-color --relative HEAD -- " .. gitpath .. " | clang-format-diff -p1 -i"
						)
						vim.api.nvim_command("e")
					end
				end,
				desc = "Conform format git diff",
			},
		},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettierd", "prettier" },
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
				-- onload = function()
				-- 	vim.api.nvim_set_option_value("scrolloff", 5, {})
				-- end,
			})
			-- vim.keymap.set("n", "<F1>", fh.toggle, {
			-- 	noremap = true,
			-- 	silent = true,
			-- 	desc = "Help nvim",
			-- })

			-- vim.keymap.set("n", "<F3>", function()
			-- 	fh.open("t=cppman", vim.fn.expand("<cword>"))
			-- end, {
			-- 	noremap = true,
			-- 	silent = true,
			-- 	desc = "Help cpp",
			-- })

			-- vim.keymap.set("n", "<F4>", function()
			-- 	fh.open("t=man", vim.fn.expand("<cword>"))
			-- end, {
			-- 	noremap = true,
			-- 	silent = true,
			-- 	desc = "Help unix",
			-- })

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
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					-- default mappings
					api.config.mappings.default_on_attach(bufnr)
					-- custom mappings
					vim.keymap.set("n", "<c-y>", api.tree.change_root_to_parent, opts("NvimTree Up"))
				end,
			})

			local nt_api = require("nvim-tree.api")
			local tree_open = false
			local function tab_enter()
				if tree_open then
					nt_api.tree.open()
					vim.api.nvim_command("wincmd p")
				else
					nt_api.tree.close()
				end
			end
			nt_api.events.subscribe(nt_api.events.Event.TreeOpen, function()
				tree_open = true
			end)
			nt_api.events.subscribe(nt_api.events.Event.TreeClose, function()
				tree_open = false
			end)
			vim.api.nvim_create_autocmd({ "TabEnter" }, { callback = tab_enter })

			vim.keymap.set("n", "`", function()
				require("nvim-tree.api").tree.toggle({ focus = false })
			end, { noremap = true, silent = true, desc = "NvimTree Toggle" })
		end,
	},
	{
		"nvim-lua/plenary.nvim",
		lazy = false,
	},
	{
		"akinsho/bufferline.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		even = "VeryLazy",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "tabs",
					separator_style = "slant",
					show_buffer_icons = true,
					show_buffer_close_icons = false,
					show_close_icon = false,
					tab_size = 20, -- Set the fixed width of tabs
					diagnostics = false,
					always_show_bufferline = true,
					show_tab_indicators = true,
					buffer_close_icon = "", -- Icon to close buffer
					modified_icon = "●", -- Icon for modified buffers
					close_icon = "", -- Close all buffers icon
					left_trunc_marker = "", -- Icon for truncated buffers on the left
					right_trunc_marker = "", -- Icon for truncated buffers on the right
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "left",
							separator = true,
						},
					},
				},
				highlights = {
					fill = {
						fg = "#ffffff", -- Foreground color
						bg = "#1e1e2e", -- Background color
					},
					buffer_selected = {
						fg = "#d1e3ff",
						bg = "#4a4a4a",
						bold = true,
						italic = false,
					},
					separator = {
						fg = "#1e1e2e",
						bg = "#1e1e2e",
					},
					separator_selected = {
						fg = "#1e1e2e",
						bg = "#1e1e2e",
					},
					background = {
						fg = "#6272a4",
						bg = "#1e1e2e",
					},
				},
			})
			-- vim.o.showtabline = 2
		end,
	},
	{
		"smoka7/multicursors.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvimtools/hydra.nvim",
		},
		opts = {},
		cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
		keys = {
			{
				mode = { "v", "n" },
				"<Leader>m",
				"<cmd>MCstart<cr>",
				desc = "Create a selection for selected text or word under the cursor",
			},
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			win = {
				enabled = true,
				border = "rounded",
			},
			bigfile = {
				enabled = true,
				size = 1.5 * 1024 * 1024, -- 1.5MB
			},
			dashboard = {
				enabled = true,
			},
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			quickfile = {
				enabled = true,
			},
			statuscolumn = {
				enabled = true,
			},
			words = {
				enabled = true,
			},
			zen = {
				enabled = true,
				toggles = {
					dim = false,
				},
			},
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
		},
		keys = {
			{
				"<lt>.",
				function()
					Snacks.scratch()
				end,
				desc = "Snacks Toggle Scratch Buffer",
			},
			{
				"<lt>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Snacks Select Scratch Buffer",
			},
			{
				"<lt>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Snacks Notification History",
			},
			{
				"<lt>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Snacks Delete Buffer",
			},
			{
				"<lt>cR",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "Snacks Rename File",
			},
			{
				"<lt>gB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Snacks Git Browse",
			},
			{
				"<lt>gb",
				function()
					Snacks.git.blame_line()
				end,
				desc = "Snacks Git Blame Line",
			},
			{
				"<lt>gf",
				function()
					Snacks.lazygit.log_file()
				end,
				desc = "Snacks Lazygit Current File History",
			},
			{
				"<lt>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Snacks Lazygit",
			},
			{
				"<lt>gl",
				function()
					Snacks.lazygit.log()
				end,
				desc = "Snacks Lazygit Log (cwd)",
			},
			{
				"<lt>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Snacks Dismiss All Notifications",
			},
			{
				"<c-\\>",
				function()
					Snacks.terminal()
				end,
				desc = "Snacks Toggle Terminal",
			},
			{
				";;",
				function()
					Snacks.words.jump(vim.v.count1, true)
				end,
				desc = "Snacks Next Reference",
				mode = { "n", "t" },
			},
			{
				";[",
				function()
					Snacks.words.jump(-vim.v.count1, true)
				end,
				desc = "Snacks Prev Reference",
				mode = { "n", "t" },
			},
			{
				"<lt>N",
				desc = "Snacks Neovim News",
				function()
					Snacks.win({
						file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							signcolumn = "yes",
							statuscolumn = " ",
							conceallevel = 3,
						},
					})
				end,
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					-- Create some toggle mappings
					Snacks.toggle.option("spell", { name = "Snacks Spelling" }):map("<lt>us")
					Snacks.toggle.option("wrap", { name = "Snacks Wrap" }):map("<lt>uw")
					Snacks.toggle.option("relativenumber", { name = "Snacks Relative Number" }):map("<lt>uL")
					Snacks.toggle.diagnostics({ name = "Snacks Diagnostics" }):map("<lt>ud")
					Snacks.toggle.line_number({ name = "" }):map("<lt>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<lt>uc")
					Snacks.toggle.treesitter({ name = "Snacks Treesitter" }):map("<lt>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<lt>ub")
					Snacks.toggle.inlay_hints({ name = "Snacks Inlay Hints" }):map("<lt>uh")
				end,
			})
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
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("noice").setup({
				debug = false,
				cmdline = {
					enabled = true, -- enables the Noice cmdline UI
					view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
					opts = {}, -- global options for the cmdline. See section on views
					format = {
						cmdline = { pattern = "^:", icon = "", lang = "vim" },
						search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
						search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
						filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
						lua = {
							pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
							icon = "",
							lang = "lua",
						},
						help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
						input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
						-- lua = false, -- to disable a format, set to `false`
					},
				},
				lsp = {
					progress = {
						enabled = false,
					},
					override = {
						-- override the default lsp markdown formatter with Noice
						["vim.lsp.util.convert_input_to_markdown_lines"] = false,
						-- override the lsp markdown formatter with Noice
						["vim.lsp.util.stylize_markdown"] = false,
						-- override cmp documentation with Noice (needs the other options to work)
						["cmp.entry.get_documentation"] = false,
					},
					hover = {
						enabled = true,
						silent = false, -- set to true to not show a message if hover is not available
						view = nil, -- when nil, use defaults from documentation
						---@type NoiceViewOptions
						opts = {}, -- merged with defaults from documentation
					},
					signature = {
						enabled = true,
						auto_open = {
							enabled = true,
							trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
							luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
							throttle = 50, -- Debounce lsp signature help request by 50ms
						},
						view = nil, -- when nil, use defaults from documentation
						---@type NoiceViewOptions
						opts = {}, -- merged with defaults from documentation
					},
					message = {
						-- Messages shown by lsp servers
						enabled = true,
						view = "notify",
						opts = {},
					},
					-- defaults for hover and signature help
					documentation = {
						view = "hover",
						---@type NoiceViewOptions
						opts = {
							lang = "markdown",
							replace = true,
							render = "plain",
							format = { "{message}" },
							win_options = { concealcursor = "n", conceallevel = 3 },
						},
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = true, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
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
					view_error = "notify", -- view for errors
					view_warn = "notify", -- view for warnings
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

			vim.keymap.set("n", "<lt>qg", function()
				require("telescope.builtin").live_grep({
					cwd = Snacks.git.get_root(),
				})
			end, {
				noremap = true,
				silent = true,
				desc = "Telescope grep git root dir",
			})

			vim.keymap.set("n", "<lt>qf", function()
				require("telescope.builtin").live_grep({
					cwd = vim.api.nvim_buf_get_name(0):match("(.*/)"),
				})
			end, {
				noremap = true,
				silent = true,
				desc = "Telescope grep buffer dir",
			})

			vim.keymap.set("n", "<lt>f", function()
				require("telescope.builtin").find_files({
					cwd = Snacks.git.get_root(),
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
