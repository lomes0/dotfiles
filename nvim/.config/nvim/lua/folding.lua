--
-- folding
--

local M = {}

function Custom_foldtext()
	local fs = vim.v.foldstart

	while vim.fn.getline(fs):match("^%s*$") do
		fs = vim.fn.nextnonblank(fs + 1)
	end

	local line
	if fs > vim.v.foldend then
		line = vim.fn.getline(vim.v.foldstart)
	else
		line = vim.fn.getline(fs):gsub("\t", string.rep(" ", vim.o.tabstop))
	end

	local foldSize = 1 + vim.v.foldend - vim.v.foldstart
	local foldSizeStr = " " .. foldSize .. " lines "
	local expansionString = string.rep(" ", vim.api.nvim_win_get_width(0) - #line - #foldSizeStr - 4)
	return line .. expansionString .. foldSizeStr
end

function M.init()
	vim.opt.foldmethod = "expr"
	vim.opt.foldenable = false
	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.opt.foldlevel = 99
	vim.opt.foldtext = "v:lua.Custom_foldtext()"
end

return M

--
-- folding
--
-- vim.cmd([[
-- set nofoldenable
-- set foldlevel=99
-- set fillchars=fold:\
-- set foldtext=CustomFoldText()
-- setlocal foldmethod=expr
-- setlocal foldexpr=GetPotionFold(v:lnum)
--
-- function! GetPotionFold(lnum)
--   if getline(a:lnum) =~? '\v^\s*$'
--     return '-1'
--   endif
--
--   let this_indent = IndentLevel(a:lnum)
--   let next_indent = IndentLevel(NextNonBlankLine(a:lnum))
--
--   if next_indent == this_indent
--     return this_indent
--   elseif next_indent < this_indent
--     return this_indent
--   elseif next_indent > this_indent
--     return '>' . next_indent
--   endif
-- endfunction
--
-- function! IndentLevel(lnum)
--     return indent(a:lnum) / &shiftwidth
-- endfunction
--
-- function! NextNonBlankLine(lnum)
--   let numlines = line('$')
--   let current = a:lnum + 1
--
--   while current <= numlines
--       if getline(current) =~? '\v\S'
--           return current
--       endif
--
--       let current += 1
--   endwhile
--
--   return -2
-- endfunction
--
-- function! CustomFoldText()
--   " get first non-blank line
--   let fs = v:foldstart
--
--   while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
--   endwhile
--
--   if fs > v:foldend
--       let line = getline(v:foldstart)
--   else
--       let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
--   endif
--
--   let foldSize = 1 + v:foldend - v:foldstart
--   let foldSizeStr = " " . foldSize . " lines "
--   let expansionString = repeat(" ", winwidth(0)-len(line)-len(foldSizeStr)-4)
--   return line . expansionString . foldSizeStr
-- endfunction
-- ]])
