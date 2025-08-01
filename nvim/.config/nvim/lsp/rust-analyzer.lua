-- ~/.config/nvim/lsp/rust-analyzer.lua
return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
	single_file_support = true,
	on_attach = function(client, bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		-- setup your keymaps here, e.g. jump to definitions, code actions, etc.
	end,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	settings = {
		["rust-analyzer"] = {
			diagnostics = { enable = false },
			checkOnSave = { command = "clippy" },
			cargo = { loadOutDirsFromCheck = true }, -- customize as needed
		},
	},
	before_init = function(init_params, config)
		if config.settings and config.settings["rust-analyzer"] then
			init_params.initializationOptions = config.settings["rust-analyzer"]
		end
	end,
}
