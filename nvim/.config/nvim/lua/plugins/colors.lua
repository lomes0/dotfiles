return {
	{
		"thesimonho/kanagawa-paper.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			-- enable undercurls for underlined text
			undercurl = true,
			-- transparent background
			transparent = false,
			-- highlight background for the left gutter
			gutter = false,
			-- background for diagnostic virtual text
			diag_background = true,
			-- dim inactive windows. Disabled when transparent
			dim_inactive = false,
			-- set colors for terminal buffers
			terminal_colors = true,
			-- cache highlights and colors for faster startup.
			-- see Cache section for more details.
			cache = false,

			styles = {
				-- style for comments
				comment = { italic = true },
				-- style for functions
				functions = { italic = false },
				-- style for keywords
				keyword = { italic = false, bold = false },
				-- style for statements
				statement = { italic = false, bold = false },
				-- style for types
				type = { italic = false },
			},
			-- override default palette and theme colors
			colors = {
				palette = {},
				theme = {
					ink = {},
					canvas = {},
				},
			},
			-- adjust overall color balance for each theme [-1, 1]
			color_offset = {
				ink = { brightness = 0, saturation = 0 },
				canvas = { brightness = 0, saturation = 0 },
			},
			-- override highlight groups
			overrides = function(colors)
				return {}
			end,

			-- uses lazy.nvim, if installed, to automatically enable needed plugins
			auto_plugins = true,
			-- enable highlights for all plugins (disabled if using lazy.nvim)
			all_plugins = package.loaded.lazy == nil,
			-- manually enable/disable individual plugins.
			-- check the `groups/plugins` directory for the exact names
			plugins = {
				-- examples:
				-- rainbow_delimiters = true
				-- which_key = false
			},

			-- enable integrations with other applications
			integrations = {
				-- automatically set wezterm theme to match the current neovim theme
				wezterm = {
					enabled = false,
					-- neovim will write the theme name to this file
					-- wezterm will read from this file to know which theme to use
					path = (os.getenv("TEMP") or "/tmp") .. "/nvim-theme",
				},
			},
		},
	},
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {},
	-- },
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- },
	{
		"norcalli/nvim-colorizer.lua",
		lazy = false,
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"lomes0/chalk.nvim",
		-- dir = vim.fn.expand("~/code/chalk.nvim"),
		lazy = false,
		priority = 1000,
		config = function()
			require("chalk").setup({
				style = "light",
				transparent = true,
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = false },
					functions = {},
					variables = {},
				},
			})
			vim.cmd.colorscheme("chalk")
		end,
	},
}
