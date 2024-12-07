local M = {}

local opts = {
	{ "neovide_position_animation_length", 0 },
	{ "neovide_cursor_animation_length", 0.00 },
	{ "neovide_cursor_trail_size", 0 },
	{ "neovide_cursor_animate_in_insert_mode", false },
	{ "neovide_cursor_animate_command_line", false },
	{ "neovide_scroll_animation_far_lines", 0 },
	{ "neovide_scroll_animation_length", 0.00 },

	{ "neovide_transparency", 0.94 }, -- Adjust transparency level
	{ "neovide_background_color", "#1e1e1e" }, -- Set a background color to prevent transparency issues

	{ "terminal_color_0", "#000000" }, -- black
	{ "terminal_color_1", "#ff5555" }, -- red
	{ "terminal_color_2", "#50fa7b" }, -- green
	{ "terminal_color_3", "#f1fa8c" }, -- yellow
	{ "terminal_color_4", "#bd93f9" }, -- blue
	{ "terminal_color_5", "#ff79c6" }, -- magenta
	{ "terminal_color_6", "#8be9fd" }, -- cyan
	{ "terminal_color_7", "#bbbbbb" }, -- white
	{ "terminal_color_8", "#44475a" }, -- bright black (grey)
	{ "terminal_color_9", "#ff6e6e" }, -- bright red
	{ "terminal_color_10", "#69ff94" }, -- bright green
	{ "terminal_color_11", "#ffffa5" }, -- bright yellow
	{ "terminal_color_12", "#d6acff" }, -- bright blue
	{ "terminal_color_13", "#ff92df" }, -- bright magenta
	{ "terminal_color_14", "#a4ffff" }, -- bright cyan
	{ "terminal_color_15", "#ffffff" }, -- bright white
}

local function neovide_register_opts(opts)
	for _, e in ipairs(opts) do
		vim.api.nvim_set_var(e[1], e[2])
	end
end

M.init = function()
	if vim.g.neovide then
		vim.keymap.set("v", "<C-c>", '"+y') -- Copy
		vim.keymap.set("v", "<C-v>", '"+P') -- Paste visual mode
		vim.keymap.set("c", "<C-v>", "<C-R>+") -- Paste command mode
		vim.keymap.set("i", "<C-v>", '<ESC>"+Pi<Right>') -- Paste insert mode

		neovide_register_opts(opts)
	end
end

M.init()
