return {
	{
		"marko-cerovac/material.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("material").setup({
				contrast = {
					terminal = false, -- Enable contrast for the built-in terminal
					sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
					floating_windows = false, -- Enable contrast for floating windows
					cursor_line = false, -- Enable darker background for the cursor line
					lsp_virtual_text = false, -- Enable contrasted background for lsp virtual text
					non_current_windows = false, -- Enable contrasted background for non-current windows
					filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
				},
				styles = { -- Give comments style such as bold, italic, underline etc.
					comments = { --[[ italic = true ]]
					},
					strings = { --[[ bold = true ]]
					},
					keywords = { --[[ underline = true ]]
					},
					functions = { --[[ bold = true, undercurl = true ]]
					},
					variables = {},
					operators = {},
					types = {},
				},
				plugins = { -- Uncomment the plugins that you use to highlight them
					-- Available plugins:
					-- "coc",
					-- "colorful-winsep",
					-- "dap",
					-- "dashboard",
					-- "eyeliner",
					-- "fidget",
					-- "flash",
					-- "gitsigns",
					-- "harpoon",
					-- "hop",
					-- "illuminate",
					-- "indent-blankline",
					-- "lspsaga",
					-- "mini",
					-- "neogit",
					-- "neotest",
					-- "neo-tree",
					-- "neorg",
					-- "noice",
					-- "nvim-cmp",
					-- "nvim-navic",
					-- "nvim-tree",
					-- "nvim-web-devicons",
					-- "rainbow-delimiters",
					-- "sneak",
					-- "telescope",
					-- "trouble",
					-- "which-key",
					-- "nvim-notify",
				},
				disable = {
					colored_cursor = false, -- Disable the colored cursor
					borders = false, -- Disable borders between vertically split windows
					background = true, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
					term_colors = false, -- Prevent the theme from setting terminal colors
					eob_lines = false, -- Hide the end-of-buffer lines
				},
				high_visibility = {
					lighter = false, -- Enable higher contrast text for lighter style
					darker = false, -- Enable higher contrast text for darker style
				},
				lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
				async_loading = true, -- Load parts of the theme asynchronously for faster startup (turned on by default)
				custom_colors = nil, -- If you want to override the default colors, set this to a function
				custom_highlights = {}, -- Overwrite highlights with your own
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true, -- disables setting the background color.
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

			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
				end,
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
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()

				end,
			})
		end,
	},
}
