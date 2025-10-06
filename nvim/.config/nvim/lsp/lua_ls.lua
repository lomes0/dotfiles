return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" }, -- Neovim uses LuaJIT
			diagnostics = { globals = { "vim" } }, -- silence "vim" undefined
			workspace = { checkThirdParty = false }, -- avoid prompts
			hint = { enable = true },
			telemetry = { enable = false },
		},
	},
}
