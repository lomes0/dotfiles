return {
	{
		"swaits/zellij-nav.nvim",
		lazy = true,
		event = "VeryLazy",
		keys = {
			{ "<C-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" } },
			{ "<C-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
			{ "<C-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
			{ "<C-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
		},
		opts = {},
	},
	{
		"mikavilpas/yazi.nvim",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("yazi").setup({
				open_for_directories = false,
			})
		end,
		keys = {
			{
				"\\",
				function()
					require("yazi").yazi()
				end,
				desc = "Open the file manager",
			},
		},
		opts = {
			-- enable this if you want to open yazi instead of netrw.
			-- Note that if you enable this, you need to call yazi.setup() to
			-- initialize the plugin. lazy.nvim does this for you in certain cases.
			open_for_directories = false,
			floating_window_scaling_factor = 0.85,
			-- the transparency of the yazi floating window (0-100). See :h winblend
			yazi_floating_window_winblend = 0,

			log_level = vim.log.levels.OFF,
			yazi_floating_window_border = "none",
		},
	},
}

-----------------------------------------
-------------- Navigation ---------------
-----------------------------------------
-- {
-- 	"lomes0/vim-tmux-navigator",
-- 	cmd = {
-- 		"TmuxNavigateLeft",
-- 		"TmuxNavigateDown",
-- 		"TmuxNavigateUp",
-- 		"TmuxNavigateRight",
-- 	},
-- 	keys = {
-- 		{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
-- 		{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
-- 		{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
-- 		{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
-- 	},
-- },

-- {
-- 	"ThePrimeagen/harpoon",
-- 	lazy = false,
-- 	branch = "harpoon2",
-- 	dependencies = { "nvim-lua/plenary.nvim" },
-- 	config = function()
-- 		local harpoon = require("harpoon")
--
-- 		-- REQUIRED
-- 		harpoon:setup()
-- 		-- REQUIRED
--
-- 		vim.keymap.set("n", "<leader>a", function()
-- 			harpoon:list():add()
-- 		end)
--
-- 		vim.keymap.set("n", "<C-h>", function()
-- 			harpoon:list():select(1)
-- 		end)
-- 		vim.keymap.set("n", "<C-t>", function()
-- 			harpoon:list():select(2)
-- 		end)
-- 		vim.keymap.set("n", "<C-n>", function()
-- 			harpoon:list():select(3)
-- 		end)
-- 		vim.keymap.set("n", "<C-s>", function()
-- 			harpoon:list():select(4)
-- 		end)
--
-- 		-- Toggle previous & next buffers stored within Harpoon list
-- 		-- vim.keymap.set("n", "", function()
-- 		-- 	harpoon:list():prev()
-- 		-- end)
-- 		-- vim.keymap.set("n", "", function()
-- 		-- 	harpoon:list():next()
-- 		-- end)
--
-- 		-- basic telescope configuration
-- 		local conf = require("telescope.config").values
-- 		local function toggle_telescope(harpoon_files)
-- 			local file_paths = {}
-- 			for _, item in ipairs(harpoon_files.items) do
-- 				table.insert(file_paths, item.value)
-- 			end
--
-- 			require("telescope.pickers")
-- 				.new({}, {
-- 					prompt_title = "Harpoon",
-- 					finder = require("telescope.finders").new_table({
-- 						results = file_paths,
-- 					}),
-- 					previewer = conf.file_previewer({}),
-- 					sorter = conf.generic_sorter({}),
-- 				})
-- 				:find()
-- 		end
--
-- 		vim.keymap.set("n", "<lt>h", function()
-- 			toggle_telescope(harpoon:list())
-- 		end, { desc = "Open harpoon window" })
-- 	end,
-- },
