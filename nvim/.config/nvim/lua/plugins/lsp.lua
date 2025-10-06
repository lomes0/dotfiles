return {
	{
		"williamboman/mason.nvim",
		enabled = true,
		config = function()
			require("mason").setup({})
		end,
	},
	-- Faster, modern replacement for neodev.nvim
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			-- Pull in luv/uv types when you use vim.uv
			library = { { path = "luvit-meta/library", words = { "vim%.uv" } } },
		},
	},
	{
		"Bilal2453/luvit-meta",
		lazy = false,
	}, -- provides luv (vim.uv) annotations
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
}
