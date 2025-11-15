return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				-- Git base navigation and hunk iteration functionality
				-- Key mappings for changing git base and iterating through files with hunks
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				signcolumn = true,
				sign_priority = 6,
				update_debounce = 150, -- ms
				max_file_length = 20000, -- lines
				preview_config = {
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				watch_gitdir = {
					follow_files = true,
				},
				attach_to_untracked = false,
				current_line_blame = false,
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")
					vim.keymap.set("n", "<Space><Space>", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							--[[@diagnostic disable-next-line:param-type-mismatch]]
							gitsigns.nav_hunk("next", { wrap = true })
						end
					end, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns next change",
					})

					vim.keymap.set("n", "<Space>r", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							--[[@diagnostic disable-next-line:param-type-mismatch]]
							gitsigns.nav_hunk("prev", { wrap = true })
						end
					end, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns prev change",
					})

					-- stage
					vim.keymap.set("n", "ca", gitsigns.stage_hunk, {
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns stage",
					})
					vim.keymap.set("v", "ca", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, {
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns stage selection",
					})

					-- reset
					vim.keymap.set("n", "cR", gitsigns.reset_buffer, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns reset buffer",
					})

					-- reset
					vim.keymap.set("n", "cr", gitsigns.reset_hunk, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns reset hunk",
					})

					-- preview
					vim.keymap.set("n", "cp", gitsigns.preview_hunk, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns preview hunk",
					})

					-- blame
					vim.keymap.set("n", "cb", gitsigns.toggle_current_line_blame, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns toggle blame",
					})

					-- diff
					vim.keymap.set("n", "cd", gitsigns.diffthis, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns diffthis",
					})

					-- git base navigation
					-- Track base state per buffer
					if not vim.b.gitsigns_base_level then
						vim.b.gitsigns_base_level = 0
					end

					vim.keymap.set("n", "c=", function()
						vim.b.gitsigns_base_level = vim.b.gitsigns_base_level + 1
						local new_base = "HEAD~" .. vim.b.gitsigns_base_level
						gitsigns.change_base(new_base, true)
						vim.notify("Git base changed to: " .. new_base)
					end, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns increase base (go further back)",
					})

					vim.keymap.set("n", "c-", function()
						if vim.b.gitsigns_base_level > 0 then
							vim.b.gitsigns_base_level = vim.b.gitsigns_base_level - 1
							if vim.b.gitsigns_base_level == 0 then
								gitsigns.change_base(nil, true)
								vim.notify("Git base reset to HEAD")
							else
								local new_base = "HEAD~" .. vim.b.gitsigns_base_level
								gitsigns.change_base(new_base, true)
								vim.notify("Git base changed to: " .. new_base)
							end
						else
							vim.notify("Already at HEAD")
						end
					end, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns decrease base (go closer to HEAD)",
					})

					-- reset git base to HEAD
					vim.keymap.set("n", "c0", function()
						vim.b.gitsigns_base_level = 0
						gitsigns.change_base(nil, true)
						vim.notify("Git base reset to HEAD")
					end, {
						noremap = true,
						silent = true,
						buffer = bufnr,
						desc = "Gitsigns reset base to HEAD",
					})
				end,
			})

			-- Get git staged files and open them in quickfix window
			vim.keymap.set("n", "<lt>hq", function()
				local handle = io.popen("git diff HEAD --name-only")
				if not handle then
					vim.notify("Failed to execute git command", vim.log.levels.ERROR)
					return
				end

				local staged_files = {}
				for file in handle:lines() do
					if file ~= "" then
						table.insert(staged_files, {
							filename = file,
							text = "Staged file",
						})
					end
				end
				handle:close()

				if #staged_files == 0 then
					vim.notify("No staged files found", vim.log.levels.INFO)
					return
				end

				vim.fn.setqflist(staged_files, "r")
				vim.cmd("copen")
				vim.notify(string.format("Found %d staged files", #staged_files), vim.log.levels.INFO)
			end, { desc = "Send Git staged files to quickfix" })

			vim.keymap.set("n", "<lt>hl", function()
				require("gitsigns").setloclist(0, "all")
			end, { desc = "Send Git hunks to loclist" })
		end,
	},
	{
		"sindrets/diffview.nvim",
		lazy = true,
		cmd = { "DiffviewOpen" },
		config = function()
			require("diffview").setup({
				diff_binaries = false, -- Show diffs for binaries
				enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
				git_cmd = { "git" }, -- The git executable followed by default args.
				hg_cmd = { "hg" }, -- The hg executable followed by default args.
				use_icons = true, -- Requires nvim-web-devicons
				show_help_hints = true, -- Show hints for how to open the help panel
				watch_index = true, -- Update views and index buffers when the git index changes.
				icons = { -- Only applies when use_icons is true.
					folder_closed = "",
					folder_open = "",
				},
				signs = {
					fold_closed = "",
					fold_open = "",
					done = "✓",
				},
				view = {
					-- Configure the layout and behavior of different types of views.
					-- Available layouts:
					--  'diff1_plain'
					--    |'diff2_horizontal'
					--    |'diff2_vertical'
					--    |'diff3_horizontal'
					--    |'diff3_vertical'
					--    |'diff3_mixed'
					--    |'diff4_mixed'
					-- For more info, see |diffview-config-view.x.layout|.
					default = {
						-- Config for changed files, and staged files in diff views.
						layout = "diff2_horizontal",
						disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = false, -- See |diffview-config-view.x.winbar_info|
					},
					merge_tool = {
						-- Config for conflicted files in diff views during a merge or rebase.
						layout = "diff3_horizontal",
						disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = true, -- See |diffview-config-view.x.winbar_info|
					},
					file_history = {
						-- Config for changed files in file history views.
						layout = "diff2_horizontal",
						disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = false, -- See |diffview-config-view.x.winbar_info|
					},
				},
				file_panel = {
					listing_style = "list", -- One of 'list' or 'tree'
					-- tree_options = { -- Only applies when listing_style is 'tree'
					-- 	flatten_dirs = true, -- Flatten dirs that only contain one single dir
					-- 	folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
					-- },
					win_config = { -- See |diffview-config-win_config|
						position = "left",
						width = 37,
						win_opts = {},
					},
				},
				file_history_panel = {
					log_options = { -- See |diffview-config-log_options|
						git = {
							single_file = {
								diff_merges = "combined",
							},
							multi_file = {
								diff_merges = "first-parent",
							},
						},
						hg = {
							single_file = {},
							multi_file = {},
						},
					},
					win_config = { -- See |diffview-config-win_config|
						position = "bottom",
						height = 16,
						win_opts = {},
					},
				},
				commit_log_panel = {
					win_config = {}, -- See |diffview-config-win_config|
				},
				default_args = { -- Default args prepended to the arg-list for the listed commands
					DiffviewOpen = {},
					DiffviewFileHistory = {},
				},
				hooks = {
					view_opened = function(view)
						-- Automatically select and focus on the first file entry
						vim.schedule(function()
							-- Give diffview time to fully initialize
							vim.defer_fn(function()
								-- Move focus to the file panel (left window)
								vim.cmd([[
								wincmd h
								wincmd h
								]])
							end, 200)
						end)
					end,
				},
			})
		end,
	},
}
