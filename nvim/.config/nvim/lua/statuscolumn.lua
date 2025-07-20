local statuscolumn = {
	levels = { true, true, true, true, true },
	max_level = 5,
	complement = true,
	fold = "",
	-- fold = " ",
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
	-- Initialize cache if not exists
	if not statuscolumn.cache then
		statuscolumn.cache = {
			foldlevel = {},
			foldclosed = {},
			last_lnum = -1,
			last_result = "",
		}
	end

	local lnum = vim.v.lnum

	-- Use cache if line hasn't changed
	if statuscolumn.cache.last_lnum == lnum and statuscolumn.cache.last_result ~= "" then
		return statuscolumn.cache.last_result
	end

	-- Cache foldlevel and foldclosed calls
	local foldlevel = statuscolumn.cache.foldlevel[lnum]
	if not foldlevel then
		foldlevel = vim.fn.foldlevel(lnum)
		statuscolumn.cache.foldlevel[lnum] = foldlevel
	end

	local foldclosed = statuscolumn.cache.foldclosed[lnum]
	if not foldclosed then
		foldclosed = vim.fn.foldclosed(lnum)
		statuscolumn.cache.foldclosed[lnum] = foldclosed
	end

	local result = " "
	if (foldlevel > 0) and (foldclosed ~= -1) and (foldclosed == lnum) then
		-- line is a closed fold
		result = statuscolumn.foldMark(foldlevel)
	end

	-- Cache the result
	statuscolumn.cache.last_lnum = lnum
	statuscolumn.cache.last_result = result

	return result
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
	-- Schedule UI updates to avoid blocking
	vim.schedule(function()
		-- Clear cache when updating
		if statuscolumn.cache then
			statuscolumn.cache.foldlevel = {}
			statuscolumn.cache.foldclosed = {}
			statuscolumn.cache.last_lnum = -1
			statuscolumn.cache.last_result = ""
		end

		vim.cmd("redraw!")

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

		-- Schedule notification separately
		vim.schedule(function()
			vim.cmd("Noice dismiss")
			Snacks.notify.info(zvals)
		end)
	end)
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
