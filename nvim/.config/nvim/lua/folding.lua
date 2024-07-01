--
-- folding
--
-- https://essais.co/better-folding-in-neovim/
vim.cmd([[
set nofoldenable
set foldlevel=99
set fillchars=fold:\
set foldtext=CustomFoldText()
setlocal foldmethod=expr
setlocal foldexpr=GetPotionFold(v:lnum)

function! GetPotionFold(lnum)
  if getline(a:lnum) =~? '\v^\s*$'
    return '-1'
  endif

  let this_indent = IndentLevel(a:lnum)
  let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

  if next_indent == this_indent
    return this_indent
  elseif next_indent < this_indent
    return this_indent
  elseif next_indent > this_indent
    return '>' . next_indent
  endif
endfunction

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
  let numlines = line('$')
  let current = a:lnum + 1

  while current <= numlines
      if getline(current) =~? '\v\S'
          return current
      endif

      let current += 1
  endwhile

  return -2
endfunction

function! CustomFoldText()
  " get first non-blank line
  let fs = v:foldstart

  while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile

  if fs > v:foldend
      let line = getline(v:foldstart)
  else
      let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . foldSize . " lines "
  let expansionString = repeat(" ", winwidth(0)-len(line)-len(foldSizeStr)-4)
  return line . expansionString . foldSizeStr
endfunction
]])

--local vim = vim
--vim.opt.foldmethod = "expr"
--vim.opt.foldcolumn = "0"
--vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--vim.opt.foldlevel = 99
--vim.opt.foldlevelstart = 1
--vim.opt.foldnestmax = 4

---- function to create a list of commands and convert them to autocommands
---------- This function is taken from https://github.com/norcalli/nvim_utils
--local opt = vim.opt
--local api = vim.api
--local M = {}
--function M.nvim_create_augroups(definitions)
--    for group_name, definition in pairs(definitions) do
--        api.nvim_command('augroup '..group_name)
--        api.nvim_command('autocmd!')
--        for _, def in ipairs(definition) do
--            local command = table.concat(vim.tbl_flatten{ 'autocmd', def }, ' ')
--            api.nvim_command(command)
--        end
--        api.nvim_command('augroup END')
--    end
--end
--
--local autoCommands = {
--    -- other autocommands
--    open_folds = {
--        --{ "BufReadPost,FileReadPost", "*", "normal zR" }
--    }
--}
--
--M.nvim_create_augroups(autoCommands)


