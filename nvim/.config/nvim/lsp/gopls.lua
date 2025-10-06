return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork" },
	root_dir = vim.fs.root(0, { "go.mod", "go.work", ".git" }),
	settings = {
		gopls = {
			gofumpt = true,
			staticcheck = true,
			usePlaceholders = true,
		},
	},
}
