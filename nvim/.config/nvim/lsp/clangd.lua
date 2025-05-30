return {
	cmd = { "clangd", "--background-index", "--all-scopes-completion" },
	root_markers = { "clangd.index", "compile_commands.json", "compile_flags.txt" },
	filetypes = { "c", "cpp" },
}
