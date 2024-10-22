return {
	{
		"mfussenegger/nvim-dap",
		lazy = false,
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			require("dapui").setup({})
			require("nvim-dap-virtual-text").setup({})

			dap.adapters.lldb = {
				type = "executable",
				command = "/u/eransa/.vscode-server/extensions/vadimcn.vscode-lldb-1.11.4/adapter/codelldb",
			}

			dap.configurations.cpp = {
				{
					name = "fwk",
					type = "codelldb",
					request = "attach",
					pid = 11076,
					initCommands = {
						"platform select remote-linux",
						"platform connect connect://172.23.53.48:3444",
						"process handle SIGWINCH -p true -n false -s false",
						"settings append target.source-map /local_ckp/src/cpis/jess_main/release.dynamic.x64 /u/eransa/code/cpas_profiling/mt/cpis",
						"settings append target.source-map /local_ckp/src/kiss_apps/jess_main/debug.dynamic.x32 /u/eransa/code/cpas_profiling/mt/kiss_apps",
						"settings append target.source-map /local_ckp/src/streaming/jess_main/debug.dynamic /u/eransa/code/cpas_profiling/mt/streaming",
						"settings append target.source-map /local_ckp/src/mux/jess_main/debug.dynamic /u/eransa/code/cpas_profiling/mt/mux",
						"settings append target.source-map /local_ckp/src/ws/jess_main/debug.dynamic /u/eransa/code/cpas_profiling/mt/ws",
						"settings append target.source-map /local_ckp/src/fw1/jess_main/debug.dynamic.x32 /u/eransa/code/cpas_profiling/mt/fw1",
					},
				},
			}

			dap.configurations.rust = dap.configurations.cpp

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

			vim.keymap.set("n", "<lt>dt", require("dapui").toggle, {
				silent = true,
				noremap = true,
				desc = "Dapui toggle",
			})
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = false,
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("dapui").setup()
		end,
	},
}
