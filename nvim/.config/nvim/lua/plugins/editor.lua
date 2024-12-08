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
		keys = { "<lt>r" },
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

			vim.keymap.set("n", "<lt>r", Format, {
				noremap = true,
				silent = true,
				desc = "Conform format",
			})
			vim.keymap.set("n", "<lt>d", FormatDiff, {
				noremap = true,
				silent = true,
				desc = "Conform format diff",
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
				onload = function()
					vim.api.nvim_set_option_value("scrolloff", 5, {})
				end,
			})
			vim.keymap.set("n", "<F1>", fh.toggle, {
				noremap = true,
				silent = true,
				desc = "Help nvim",
			})

			vim.keymap.set("n", "<F3>", function()
				fh.open("t=cppman", vim.fn.expand("<cword>"))
			end, {
				noremap = true,
				silent = true,
				desc = "Help cpp",
			})

			vim.keymap.set("n", "<F4>", function()
				fh.open("t=man", vim.fn.expand("<cword>"))
			end, {
				noremap = true,
				silent = true,
				desc = "Help unix",
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
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({})

			vim.keymap.set("n", "`", function()
				require('nvim-tree.api').tree.toggle({ focus = false })
			end, { noremap = true, silent = true, desc = "NvimTree toggle" })

			vim.keymap.set("n", "U", function()
				require("nvim-tree").change_dir("..")
			end, { noremap = true, silent = true, desc = "NvimTree cwd up" })
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
					show_buffer_icons = false,
					show_buffer_close_icons = false,
					show_close_icon = false,
					tab_size = 20, -- Set the fixed width of tabs
					diagnostics = false,
					always_show_bufferline = true,
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "left",
							separator = true,
						},
					},
				},
			})
			vim.o.showtabline = 1
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
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
		},
		keys = {
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch Buffer",
			},
			{
				"<leader>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>cR",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "Rename File",
			},
			{
				"<leader>gB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse",
			},
			{
				"<leader>gb",
				function()
					Snacks.git.blame_line()
				end,
				desc = "Git Blame Line",
			},
			{
				"<leader>gf",
				function()
					Snacks.lazygit.log_file()
				end,
				desc = "Lazygit Current File History",
			},
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>gl",
				function()
					Snacks.lazygit.log()
				end,
				desc = "Lazygit Log (cwd)",
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
			{
				"<c-\\>",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
			},
			{
				";;",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},
			{
				";[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
				mode = { "n", "t" },
			},
			{
				"<leader>N",
				desc = "Neovim News",
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
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")
					Snacks.toggle.treesitter():map("<leader>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")
					Snacks.toggle.inlay_hints():map("<leader>uh")
				end,
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
}
