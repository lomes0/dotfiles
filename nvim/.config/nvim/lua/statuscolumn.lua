local statuscolumn = {
	level = 1,
}

-- statuscolumn.number = function(user_config)
-- 	-- As a failsafe we will return an empty string if something breaks
-- 	local text = ""
--
-- 	-- This is how plugins set the default options for a configuration table(an empty table is used if the user config is nil)
-- 	-- This merges the default values and the user provided values so that you don't need to have all the keys in your config table
-- 	local config = vim.tbl_extend("keep", user_config or {}, {
-- 		colors = nil,
-- 		mode = "normal",
-- 	})
--
-- 	-- islist() was previously called tbl_islist() so use that if you are using an older version
-- 	if config.colors ~= nil and vim.islist(config.colors) == true then
-- 		for rel_num, hl in ipairs(config.colors) do
-- 			-- Only 1 highlight group
-- 			if (vim.v.relnum + 1) == rel_num then
-- 				text = "%#" .. colors .. "#"
-- 				break
-- 			end
-- 		end
--
-- 		-- If the string is still empty then use the last color
-- 		if text == "" then
-- 			text = "%#" .. config.colors[#config.colors] .. "#"
-- 		end
-- 	end
--
-- 	if config.mode == "normal" then
-- 		text = text .. vim.v.lnum
-- 	elseif config.mode == "relative" then
-- 		text = text .. vim.v.relnum
-- 	elseif config.mode == "hybrid" then
-- 		return vim.v.relnum == 0 and text .. vim.v.lnum or text .. vim.v.relnum
-- 	end
--
-- 	return text
-- end

-- statuscolumn.setHl = function()
-- 	local colors =
-- 		{ "#caa6f7", "#c1a6f1", "#b9a5ea", "#b1a4e4", "#aba3dc", "#a5a2d4", "#9fa0cc", "#9b9ec4", "#979cbc", "#949ab3" }
--
-- 	for i, color in ipairs(colors) do
-- 		vim.api.nvim_set_hl(0, "Gradient_" .. i, { fg = color })
-- 	end
-- end

-- statuscolumn.border = function()
-- 	-- See how the characters is larger then the rest? That's how we make the border look like a single line
-- 	-- NOTE: lua tables start at 1 but relnum starts at 0, so we add 1 to it to get the highlight group
-- 	if vim.v.relnum < 9 then
-- 		return "%#Gradient_" .. (vim.v.lnum + 1) .. "#│"
-- 	else
-- 		return "%#Gradient_10#│"
-- 	end
-- end

statuscolumn.setHl = function()
	vim.api.nvim_set_hl(0, "FoldSign", { fg = "#ffffff" })
end

statuscolumn.folds = function()
	local foldlevel = vim.fn.foldlevel(vim.v.lnum)
	-- local foldlevel_before = vim.fn.foldlevel((vim.v.lnum - 1) >= 1 and vim.v.lnum - 1 or 1)
	-- local foldlevel_after =
	-- 	vim.fn.foldlevel((vim.v.lnum + 1) <= vim.fn.line("$") and (vim.v.lnum + 1) or vim.fn.line("$"))

	local foldclosed = vim.fn.foldclosed(vim.v.lnum)

	-- Line has nothing to do with folds so we will skip it
	if foldlevel == 0 then
		return " "
	end

	-- Line is a closed fold(I know second condition feels unnecessary but I will still add it)
	if foldclosed ~= -1 and foldclosed == vim.v.lnum then
		if foldlevel >= statuscolumn.level then
			return "%#FoldSign#·"
		end
		return "%#FoldSign# "
		-- return "%#FoldSign#"
	end

	return " "
	-- I didn't use ~= because it couldn't make a nested fold have a lower level than it's parent fold and it's not something I would use
	-- if foldlevel > foldlevel_before then
	-- 	return "▽"
	-- end
	--
	-- -- The line is the last line in the fold
	-- if foldlevel > foldlevel_after then
	-- 	return "╰"
	-- end
	--
	-- -- Line is in the middle of an open fold
	-- return "╎"
end

statuscolumn.statuscolumn = function()
	local text = ""
	statuscolumn.setHl()

	text = table.concat({
		"%s%=%{v:relnum?v:relnum:v:lnum}",
		" ",
		statuscolumn.folds(),
		" ",
	})

	return text
end

vim.keymap.set("n", "z=", function()
	statuscolumn.level = statuscolumn.level + 1
	vim.api.nvim_command("normal! zx")
	print(statuscolumn.level)
end)

vim.keymap.set("n", "z-", function()
	if statuscolumn.level >= 2 then
		statuscolumn.level = statuscolumn.level - 1
	end
	vim.api.nvim_command("normal! zx")
	print(statuscolumn.level)
end)

return statuscolumn
