return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"norcalli/nvim-colorizer.lua",
		lazy = false,
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		lazy = false,
		priority = 1000,
		dir = vim.fn.expand("~/code/chalk.nvim"),
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
