return {
	{
		"xiyaowong/transparent.nvim",
		dependencies = {
			"folke/tokyonight.nvim",
			"catppuccin/nvim",
		},
		lazy = false,
	},
	{
		"norcalli/nvim-colorizer.lua",
		lazy = false,
		config = function()
			vim.api.nvim_command("set termguicolors")
			require("colorizer").setup({
				"*", -- Highlight all files, but customize some others.
				"!vim", -- Exclude vim from highlighting.
				-- Exclusion Only makes sense if '*' is specified!
			})
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {    
			compile = false,             -- enable compiling the colorscheme
			undercurl = true,            -- enable undercurls
    		commentStyle = { italic = true },
    		functionStyle = {},
    		keywordStyle = { italic = true},
    		statementStyle = { bold = true },
    		typeStyle = {},
    		transparent = true,         -- do not set background color
    		dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    		terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    		colors = {                   -- add/modify theme and palette colors
    		    palette = {},
    		    theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    		},
    		overrides = function(colors) -- add/modify highlights
    		    return {}
    		end,
    		theme = "wave",              -- Load "wave" theme when 'background' option is not set
    		background = {               -- map the value of 'background' option to a theme
    		    dark = "wave",           -- try "dragon" !
    		    light = "lotus"
    		},
		}
	},
}
