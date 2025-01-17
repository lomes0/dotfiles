local statuscolumn = {
	levels = { true, true, true, true, true },
	max_level = 5,
	complement = true,
	fold = "·",
}

statuscolumn.setHl = function()
	vim.api.nvim_set_hl(0, "FoldSign", { fg = "#ffffff" })
end

statuscolumn.foldsMarkCond = function(foldlevel)
	if statuscolumn.marksInclusive then
		return statuscolumn.level < foldlevel
	else
		return foldlevel <= statuscolumn.level
	end
end

statuscolumn.foldMark = function(foldlevel)
	if
		(foldlevel <= statuscolumn.max_level and statuscolumn.levels[foldlevel])
		or (foldlevel > statuscolumn.max_level and statuscolumn.complement)
	then
		return "%#FoldSign#" .. statuscolumn.fold
	end
	return " "
end

statuscolumn.folds = function()
	local foldlevel = vim.fn.foldlevel(vim.v.lnum)
	local foldclosed = vim.fn.foldclosed(vim.v.lnum)

	if (foldlevel > 0) and (foldclosed ~= -1) and (foldclosed == vim.v.lnum) then
		-- line is a closed fold
		return statuscolumn.foldMark(foldlevel)
	end

	return " "
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

local function statuscolumn_update()
	vim.api.nvim_command("redraw!")
	local zvals = ""
	for i = 1, statuscolumn.max_level do
		if statuscolumn.levels[i] then
			zvals = zvals .. tostring(i) .. " " .. statuscolumn.fold .. "\n"
		else
			zvals = zvals .. tostring(i) .. " " .. "\n"
		end
	end
	if statuscolumn.complement then
		zvals = zvals .. "n " .. statuscolumn.fold
	else
		zvals = zvals .. "n "
	end

	vim.api.nvim_command("Noice dismiss")
	Snacks.notify.info(zvals)
end

local function zi_update(i)
	if i <= statuscolumn.max_level then
		statuscolumn.levels[i] = not statuscolumn.levels[i]
	else
		statuscolumn.complement = not statuscolumn.complement
	end
	statuscolumn_update()
end

for i = 1, statuscolumn.max_level do
	local zi = "z" .. tostring(i)
	vim.keymap.set("n", zi, function()
		zi_update(i)
	end)
end

vim.keymap.set("n", "z0", function()
	zi_update(statuscolumn.max_level + 1)
end)

return statuscolumn
