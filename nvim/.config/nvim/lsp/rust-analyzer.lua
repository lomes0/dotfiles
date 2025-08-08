return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
	settings = {
		["rust-analyzer"] = {
			cargo = { loadOutDirsFromCheck = true },
			checkOnSave = { command = "clippy" },
			-- avoid using rust-project.json if possible
		},
	},
}
