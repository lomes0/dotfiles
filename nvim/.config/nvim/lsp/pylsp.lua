return {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
	},
	settings = {
		pylsp = {
			plugins = {
				-- ruff
				ruff = {
					enabled = true,
					formatEnabled = true,
				},
				mypy = { enabled = true },
				pylint = { enabled = true },
				-- disable default linters
				pyflakes = { enabled = false },
				pycodestyle = { enabled = false },
				mccabe = { enabled = false },
				black = { enabled = false },
				isort = { enabled = false },
				autopeop8 = { enabled = false },
			},
		},
	},
}
