return {
	-- cmd = { "clangd", "--background-index" },
	cmd = { "clangd", "--all-scopes-completion", "--index-file=clangd.index" },
	root_markers = { "clangd.index", "compile_commands.json", "compile_flags.txt" },
	filetypes = { "c", "cpp" },
}
