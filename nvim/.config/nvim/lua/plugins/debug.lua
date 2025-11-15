return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"igorlfs/nvim-dap-view",
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

			dap.configurations.rust = {
				{
					name = "Default",
					type = "lldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
					end,
					cwd = "",
					args = { "exe" },
					stopOnEntry = false,
					autoReload = {
						enable = true,
					},
				},
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

			vim.keymap.set("n", "<F5>", dap.continue)
			vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)
			vim.keymap.set("n", "<M-l>", dap.step_over)
			vim.keymap.set("n", "<M-j>", dap.step_into)
			vim.keymap.set("n", "<M-k>", dap.step_out)

			-- dap.configurations.cpp = {
			-- 	{
			-- 		name = "fwk",
			-- 		type = "codelldb",
			-- 		request = "attach",
			-- 		pid = 11076,
			-- 		initCommands = {
			-- 			"platform select remote-linux",
			-- 			"platform connect connect://172.23.53.48:3444",
			-- 			"process handle SIGWINCH -p true -n false -s false",
			-- 			"settings append target.source-map /local_ckp/src/cpis/jess_main/release.dynamic.x64 /u/eransa/code/cpas_profiling/mt/cpis",
			-- 			"settings append target.source-map /local_ckp/src/kiss_apps/jess_main/debug.dynamic.x32 /u/eransa/code/cpas_profiling/mt/kiss_apps",
			-- 			"settings append target.source-map /local_ckp/src/streaming/jess_main/debug.dynamic /u/eransa/code/cpas_profiling/mt/streaming",
			-- 			"settings append target.source-map /local_ckp/src/mux/jess_main/debug.dynamic /u/eransa/code/cpas_profiling/mt/mux",
			-- 			"settings append target.source-map /local_ckp/src/ws/jess_main/debug.dynamic /u/eransa/code/cpas_profiling/mt/ws",
			-- 			"settings append target.source-map /local_ckp/src/fw1/jess_main/debug.dynamic.x32 /u/eransa/code/cpas_profiling/mt/fw1",
			-- 		},
			-- 	},
			-- }

			vim.keymap.set("n", "<F5>", function()
				require("dap").continue()
			end, { silent = true, noremap = true, desc = "Dap continue" })

			vim.keymap.set("n", "<F9>", function()
				require("dap").toggle_breakpoint()
			end, { silent = true, noremap = true, desc = "Dap toggle breakpoint" })

			vim.keymap.set("n", "<F8>", function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { silent = true, noremap = true, desc = "Dap set breakpoint with msg" })

			vim.keymap.set("n", "<F6>", function()
				require("dap").run_last()
			end, { silent = true, noremap = true, desc = "Dap run last" })

			vim.keymap.set({ "n", "v" }, "<F8>", function()
				require("dap.ui.widgets").preview()
			end, { silent = true, noremap = true, desc = "Dap ui widgets preview" })

			vim.keymap.set("n", "<M-l>", function()
				require("dap").step_over()
			end, { silent = true, noremap = true, desc = "Dap step over" })

			vim.keymap.set("n", "<M-k>", function()
				require("dap").step_into()
			end, { silent = true, noremap = true, desc = "Dap step into" })

			vim.keymap.set("n", "<M-j>", function()
				require("dap").step_out()
			end, { silent = true, noremap = true, desc = "Dap step out" })

			vim.keymap.set("n", "<Leader>dr", function()
				require("dap").repl.open()
			end, { silent = true, noremap = true, desc = "Dap repl open" })

			vim.keymap.set("n", "<M-l>", dap.step_over)
			vim.keymap.set("n", "<M-j>", dap.step_into)
			vim.keymap.set("n", "<M-k>", dap.step_out)

			-------
			-- Now use .vscode/launch.json:
			-------
			-- {
			--     // Use IntelliSense to learn about possible attributes.
			--     // Hover to view descriptions of existing attributes.
			--     // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
			--     "version": "0.2.0",
			--     "configurations": [
			--     {
			--       "name": "Load Core dump",
			--       "type": "lldb",
			--       "request": "attach",
			--       "stopOnEntry": true,
			--       "processCreateCommands": [],
			--       "targetCreateCommands": [
			--         "target create -c <core> <exe>"
			--       ],
			--     },
			--     ]
			-- }
		end,
	},
	{
		"igorlfs/nvim-dap-view",
		lazy = true,
		---@module 'dap-view'
		---@type dapview.Config
		opts = {
			winbar = {
				show = true,
				-- You can add a "console" section to merge the terminal with the other views
				sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
				-- Must be one of the sections declared above
				default_section = "watches",
				-- Configure each section individually
				base_sections = {
					breakpoints = {
						keymap = "B",
						label = "Breakpoints [B]",
						short_label = " [B]",
						action = function()
							require("dap-view.views").switch_to_view("breakpoints")
						end,
					},
					scopes = {
						keymap = "S",
						label = "Scopes [S]",
						short_label = "󰂥 [S]",
						action = function()
							require("dap-view.views").switch_to_view("scopes")
						end,
					},
					exceptions = {
						keymap = "E",
						label = "Exceptions [E]",
						short_label = "󰢃 [E]",
						action = function()
							require("dap-view.views").switch_to_view("exceptions")
						end,
					},
					watches = {
						keymap = "W",
						label = "Watches [W]",
						short_label = "󰛐 [W]",
						action = function()
							require("dap-view.views").switch_to_view("watches")
						end,
					},
					threads = {
						keymap = "T",
						label = "Threads [T]",
						short_label = "󱉯 [T]",
						action = function()
							require("dap-view.views").switch_to_view("threads")
						end,
					},
					repl = {
						keymap = "R",
						label = "REPL [R]",
						short_label = "󰯃 [R]",
						action = function()
							require("dap-view.repl").show()
						end,
					},
					sessions = {
						keymap = "K", -- I ran out of mnemonics
						label = "Sessions [K]",
						short_label = " [K]",
						action = function()
							require("dap-view.views").switch_to_view("sessions")
						end,
					},
					console = {
						keymap = "C",
						label = "Console [C]",
						short_label = "󰆍 [C]",
						action = function()
							require("dap-view.views").switch_to_view("console")
						end,
					},
				},
				-- Add your own sections
				custom_sections = {},
				controls = {
					enabled = false,
					position = "right",
					buttons = {
						"play",
						"step_into",
						"step_over",
						"step_out",
						"step_back",
						"run_last",
						"terminate",
						"disconnect",
					},
					custom_buttons = {},
				},
			},
			windows = {
				height = 0.25,
				position = "below",
				terminal = {
					width = 0.5,
					position = "left",
					-- List of debug adapters for which the terminal should be ALWAYS hidden
					hide = {},
					-- Hide the terminal when starting a new session
					start_hidden = true,
				},
			},
			icons = {
				disabled = "",
				disconnect = "",
				enabled = "",
				filter = "󰈲",
				negate = " ",
				pause = "",
				play = "",
				run_last = "",
				step_back = "",
				step_into = "",
				step_out = "",
				step_over = "",
				terminate = "",
			},
			help = {
				border = nil,
			},
			-- Controls how to jump when selecting a breakpoint or navigating the stack
			-- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
			-- Only a subset of the options is available: newtab, useopen, usetab and uselast
			-- Can also be a function that takes the current winnr and the bufnr that will jumped to
			-- If a function, should return the winnr of the destination window
			switchbuf = "usetab,uselast",
			-- Auto open when a session is started and auto close when all sessions finish
			auto_toggle = false,
			-- Reopen dapview when switching to a different tab
			-- Can also be a function to dynamically choose when to follow, by returning a boolean
			-- If a function, receives the name of the adapter for the current session as an argument
			follow_tab = false,
		},
	},
}
