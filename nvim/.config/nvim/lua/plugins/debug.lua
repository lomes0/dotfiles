return {
	{
		"mfussenegger/nvim-dap",
		lazy = false,
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"williamboman/mason.nvim",
			-- "igorlfs/nvim-dap-view",
		},
		config = function()
			local dap = require("dap")
			require("nvim-dap-virtual-text").setup({})

			dap.adapters.lldb = {
				type = "executable",
				command = "lldb-dap",
				name = "lldb",
			}

			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "lldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
					runInTerminal = false,
					autoReload = {
						enabled = true,
					},
				},
			}

			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp

			vim.keymap.set("n", "<F5>", function()
				require("dap").continue()
			end, { silent = true, noremap = true, desc = "Dap continue" })

			vim.keymap.set("n", "<M-l>", function()
				require("dap").step_over()
			end, { silent = true, noremap = true, desc = "Dap step over" })

			vim.keymap.set("n", "<M-k>", function()
				require("dap").step_into()
			end, { silent = true, noremap = true, desc = "Dap step into" })

			vim.keymap.set("n", "<M-j>", function()
				require("dap").step_out()
			end, { silent = true, noremap = true, desc = "Dap step out" })

			vim.keymap.set("n", "<F9>", function()
				require("dap").toggle_breakpoint()
			end, { silent = true, noremap = true, desc = "Dap toggle breakpoint" })

			vim.keymap.set("n", "<F8>", function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { silent = true, noremap = true, desc = "Dap set breakpoint with msg" })

			vim.keymap.set("n", "<Leader>dr", function()
				require("dap").repl.open()
			end, { silent = true, noremap = true, desc = "Dap repl open" })

			vim.keymap.set("n", "<F6>", function()
				require("dap").run_last()
			end, { silent = true, noremap = true, desc = "Dap run last" })

			vim.keymap.set({ "n", "v" }, "<F8>", function()
				require("dap.ui.widgets").preview()
			end, { silent = true, noremap = true, desc = "Dap ui widgets preview" })

			-------
			-- Now use .vscode/launch.json:
			-------
			-- [[
			-- 	{
			-- 	  "version": "0.2.0",
			-- 	  "configurations": [
			-- 	    {
			-- 	      "name": "Launch debugger",
			-- 	      "type": "codelldb",
			-- 	      "request": "launch",
			-- 	      "cwd": "${workspaceFolder}",
			-- 	      "program": "path/to/executable"
			-- 	    }
			-- 	  ]
			-- 	}
			-- ]]

			-- vim.keymap.set("n", "<lt>dt", require("dapui").toggle, {
			-- 	silent = true,
			-- 	noremap = true,
			-- 	desc = "Dapui toggle",
			-- })
		end,
	},
	-- {
	-- 	"igorlfs/nvim-dap-view",
	-- 	lazy = false,
	-- 	---@module 'dap-view'
	-- 	---@type dapview.Config
	-- 	opts = {
	-- 		winbar = {
	-- 			show = true,
	-- 			-- You can add a "console" section to merge the terminal with the other views
	-- 			sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
	-- 			-- Must be one of the sections declared above (except for "console")
	-- 			default_section = "watches",
	-- 			-- Configure each section individually
	-- 			base_sections = {
	-- 				breakpoints = {
	-- 					keymap = "B",
	-- 					label = "Breakpoints [B]",
	-- 					short_label = " [B]",
	-- 					action = function()
	-- 						require("dap-view.views").switch_to_view("breakpoints")
	-- 					end,
	-- 				},
	-- 				scopes = {
	-- 					keymap = "S",
	-- 					label = "Scopes [S]",
	-- 					short_label = "󰂥 [S]",
	-- 					action = function()
	-- 						require("dap-view.views").switch_to_view("scopes")
	-- 					end,
	-- 				},
	-- 				exceptions = {
	-- 					keymap = "E",
	-- 					label = "Exceptions [E]",
	-- 					short_label = "󰢃 [E]",
	-- 					action = function()
	-- 						require("dap-view.views").switch_to_view("exceptions")
	-- 					end,
	-- 				},
	-- 				watches = {
	-- 					keymap = "W",
	-- 					label = "Watches [W]",
	-- 					short_label = "󰛐 [W]",
	-- 					action = function()
	-- 						require("dap-view.views").switch_to_view("watches")
	-- 					end,
	-- 				},
	-- 				threads = {
	-- 					keymap = "T",
	-- 					label = "Threads [T]",
	-- 					short_label = "󱉯 [T]",
	-- 					action = function()
	-- 						require("dap-view.views").switch_to_view("threads")
	-- 					end,
	-- 				},
	-- 				repl = {
	-- 					keymap = "R",
	-- 					label = "REPL [R]",
	-- 					short_label = "󰯃 [R]",
	-- 					action = function()
	-- 						require("dap-view.repl").show()
	-- 					end,
	-- 				},
	-- 				console = {
	-- 					keymap = "C",
	-- 					label = "Console [C]",
	-- 					short_label = "󰆍 [C]",
	-- 					action = function()
	-- 						require("dap-view.term").show()
	-- 					end,
	-- 				},
	-- 			},
	-- 			-- Add your own sections
	-- 			custom_sections = {},
	-- 			controls = {
	-- 				enabled = false,
	-- 				position = "right",
	-- 				buttons = {
	-- 					"play",
	-- 					"step_into",
	-- 					"step_over",
	-- 					"step_out",
	-- 					"step_back",
	-- 					"run_last",
	-- 					"terminate",
	-- 					"disconnect",
	-- 				},
	-- 				icons = {
	-- 					play = "",
	-- 					pause = "",
	-- 					step_into = "",
	-- 					step_over = "",
	-- 					step_out = "",
	-- 					step_back = "",
	-- 					run_last = "",
	-- 					terminate = "",
	-- 					disconnect = "",
	-- 				},
	-- 				custom_buttons = {},
	-- 			},
	-- 		},
	-- 		windows = {
	-- 			height = 0.75,
	-- 			position = "right",
	-- 			terminal = {
	-- 				width = 0.4,
	-- 				position = "below",
	-- 				-- List of debug adapters for which the terminal should be ALWAYS hidden
	-- 				hide = {},
	-- 				-- Hide the terminal when starting a new session
	-- 				start_hidden = true,
	-- 			},
	-- 		},
	-- 		help = {
	-- 			border = nil,
	-- 		},
	-- 		-- Controls how to jump when selecting a breakpoint or navigating the stack
	-- 		switchbuf = "usetab",
	-- 		auto_toggle = true,
	-- 	},
	-- },
}
