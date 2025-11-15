return {
	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = function()
			local harpoon = require("harpoon")

			-- Helper: Get current file and cursor position
			local function get_current_spot()
				return {
					file = vim.api.nvim_buf_get_name(0),
					row = vim.api.nvim_win_get_cursor(0)[1],
				}
			end

			-- Helper: Find index of matching spot in list
			local function find_spot_index(list, target)
				for i, item in ipairs(list.items) do
					--- @type HarpoonSpotValue
					local v = item.value --[[@as HarpoonSpotValue]]
					if v and v.file == target.file and v.row == target.row then
						return i
					end
				end
				return nil
			end

			-- Helper: Remove item at index without leaving nulls
			local function remove_item_at(list, index)
				local new_items = {}
				for i, item in ipairs(list.items) do
					if i ~= index then
						table.insert(new_items, item)
					end
				end
				list.items = new_items
				list._length = #new_items
			end

			-- Helper: Schedule UI redraw
			local function schedule_redraw()
				vim.schedule(function()
					vim.cmd("redraw!")
				end)
			end

			return {
				-- Toggle add/remove a "spot" (file+row) at the current cursor
				{
					"<C-'>",
					function()
						local list = harpoon:list("spots")
						local target = get_current_spot()
						local found_index = find_spot_index(list, target)

						if found_index then
							remove_item_at(list, found_index)
							harpoon:sync()
						else
							-- create_list_item below will read the current cursor for us
							list:add()
						end

						-- Refresh statuscolumn harpoon indicators
						require("statuscolumn").refresh_harpoon_cache()

						schedule_redraw()
					end,
					desc = "Harpoon spot: toggle here",
				},
				-- Previous / next spot
				{
					"!",
					function()
						require("harpoon"):list("spots"):prev({ ui_nav_wrap = true })
					end,
					desc = "Harpoon prev",
				},
				{
					"@",
					function()
						require("harpoon"):list("spots"):next({ ui_nav_wrap = true })
					end,
					desc = "Harpoon next",
				},
			}
		end,
		config = function()
			local harpoon = require("harpoon")

			-- Helper: Schedule UI redraw
			local function schedule_redraw()
				vim.schedule(function()
					vim.cmd("redraw!")
				end)
			end

			--- @class HarpoonSpotValue
			--- @field file string
			--- @field row number

			--- @class HarpoonSpotItem
			--- @field value HarpoonSpotValue

			harpoon:setup({
				-- keep the popup width dynamic (from the README)
				menu = { width = vim.api.nvim_win_get_width(0) - 4 }, -- :contentReference[oaicite:1]{index=1}
				-- make list state persist when the UI closes
				settings = { sync_on_ui_close = true }, -- :contentReference[oaicite:2]{index=2}

				-- custom list that stores file + line number
				["spots"] = {
					create_list_item = function(_, _)
						local file = vim.api.nvim_buf_get_name(0)
						local row = vim.api.nvim_win_get_cursor(0)[1]
						return { value = { file = file, row = row } }
					end,
					display = function(li)
						return string.format("%s:%d", vim.fn.fnamemodify(li.value.file, ":."), li.value.row)
					end,
					equals = function(a, b)
						if not a or not b or not a.value or not b.value then
							return false
						end
						return a.value.file == b.value.file and a.value.row == b.value.row
					end,
					select = function(li)
						if not li or not li.value then
							return
						end
						vim.cmd.edit(vim.fn.fnameescape(li.value.file))
						pcall(vim.api.nvim_win_set_cursor, 0, { li.value.row, 0 })
					end,
					encode = function(item)
						return item.value
					end,
					decode = function(obj)
						return { value = obj }
					end,
				},
			})

			-- Telescope UI (pattern matches the official example, but with our custom entries)
			local conf = require("telescope.config").values
			local function open_spots_picker(list)
				local results = {}
				for _, item in ipairs(list.items) do
					if item.value then
						table.insert(results, item.value) -- README iterates `harpoon_files.items` and uses `item.value` :contentReference[oaicite:3]{index=3}
					end
				end

				local entry_maker = function(entry)
					local short = string.format("%s:%d", vim.fn.fnamemodify(entry.file, ":."), entry.row)
					return {
						value = entry,
						display = short,
						ordinal = short,
						filename = entry.file,
						lnum = entry.row,
						col = 1,
					}
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon (spots)",
						finder = require("telescope.finders").new_table({
							results = results,
							entry_maker = entry_maker,
						}),
						previewer = conf.grep_previewer({}),
						sorter = conf.generic_sorter({}),
						on_close = schedule_redraw,
						attach_mappings = function(prompt_bufnr)
							local actions = require("telescope.actions")
							local action_state = require("telescope.actions.state")

							-- open selection at stored line
							actions.select_default:replace(function()
								local sel = action_state.get_selected_entry()
								if sel and sel.value then
									actions.close(prompt_bufnr)
									vim.cmd.edit(vim.fn.fnameescape(sel.value.file))
									pcall(vim.api.nvim_win_set_cursor, 0, { sel.value.row, 0 })
									schedule_redraw()
								end
							end)

							return true
						end,
					})
					:find()
			end

			-- Open the Telescope picker for the "spots" list
			vim.keymap.set("n", "<lt>H", function()
				open_spots_picker(harpoon:list("spots"))
			end, { desc = "Open Harpoon spots picker" })
		end,
	},
}
