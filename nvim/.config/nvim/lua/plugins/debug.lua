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

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "~/.local/share/nvim/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}


			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
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

			vim.keymap.set("n", "<lt>u", require("dapui").toggle, {
				silent = true,
				noremap = true,
				desc = "Dapui toggle",
			})
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("dapui").setup()
		end,
	},
	{
		"julianolf/nvim-dap-lldb",
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("nvim-dap-lldb").setup({
				codelldb_path = "~/.local/share/nvim/mason/bin/codelldb",
			})
		end,
	},
}
