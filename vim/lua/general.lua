local M = {}

local opt = vim.api.nvim_set_option
local cmd = vim.api.nvim_command
local map = vim.api.nvim_set_keymap
local exec = vim.api.nvim_exec

function map_s(mode, key, value)
  map(mode, key, value, { noremap = true, silent = true })
end

function M.general_setting()
  -- Set true color and color scheme
  opt("termguicolors", true)  -- true color
  cmd("colorscheme onedarkishii")

  cmd("syntax enable")

  opt("ttyfast", true)
  opt("autoread", true)     -- Auto reload file when the file content is changed
  opt("ruler", true)        -- Show the cursor position all the time
  cmd("filetype on")        -- Enable filetype detection
  cmd("filetype plugin on") -- Enable filetype-specific plugins
  cmd("filetype indent on") -- Enable filetype-specific indenting

  opt("laststatus", 2)
  opt("showmode", true)     -- Show current input mode in status line
  opt("cursorline", true)   -- Show Cursor Line in Underline
  opt("wildmenu", true)     -- Show autocomplete menus.

  opt("number", true)
  opt("colorcolumn", "80")

  opt("diffopt", "internal,filler,indent-heuristic,algorithm:histogram")

  -- Title
  opt("title", true)
  cmd([[ set titlestring=%F\ -\ %{hostname()} ]])

  -- Encoding
  opt("encoding", "utf-8")
  opt("fileencoding", "utf-8")

  -- Disable bleep
  opt("errorbells", false)
  opt("visualbell", false)
  opt("tm", 500)

  -- Search
  opt("showcmd", true)
  opt("incsearch", true)
  opt("showmatch", true)
  opt("ignorecase", true)
  opt("smartcase", true)
  opt("hlsearch", true)

  -- Indent
  opt("backspace", "indent,eol,start")
  opt("autoindent", true)
  opt("smarttab", true)
  opt("expandtab", true)
  opt("shiftwidth", 4)
  opt("softtabstop", 4)
  opt("tabstop", 4)

  -- Restore cursor to file position in previous editing session
  cmd([[ set viminfo='10,\"100,:20,%,n~/.viminfo ]])
  cmd([[ au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm'\"")|else|exe "norm $"|endif|endif ]])

  -- Disable preview by default
  cmd([[ set completeopt-=preview ]])
end

function M.set_resize_window()
   -- Resize splits when the Vim window is resized
   exec([[
    augroup vim_resized
      au!
      au VimResized * :wincmd =
    augroup END
   ]], true)
end

function M.show_cursorline_window()
  -- Only show cursorline in the current window
  exec([[
    augroup cline
      au!
      au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
      au WinLeave * if &filetype !=# 'denite' | setlocal nocursorline | endif
    augroup END
  ]], true)
end

function M.keymap()
  map_s('i', 'jk', '<esc>')

  map_s('n', '<leader>rv', ':source $MYVIMRC<cr>')

  map_s('n', '<esc>u', ':nohl<cr>')

  -- Indent key mapping
  map_s('n', '<tab>', 'v>')
  map_s('n', '<s-tab>', 'v<')
  map_s('v', '<tab>', '>gv')
  map_s('v', '<s-tab>', '<gv')

  -- Tab setting
  map_s('n', '<leader>tc', ":tabnew<cr>")
  map_s('n', '<leader>te', ":tabedit<cr>")
  map_s('n', '<leader>tm', ":tabmove<cr>")

  map_s('n', '<C-N>', ":tabnext<cr>")
  map_s('n', 'tj', ":tabnext<cr>")
  map_s('n', 'tk', ":tabprev<cr>")
end

function M.disable_read_warning()
  -- Disable readonly warning
  exec([[
    augroup no_ro_warn
        au!
        au FileChangedRO * set noreadonly
    augroup END
  ]], true)
end

function M.set_fix_window()
  exec([[
    command! -bang -nargs=? QFix call QFixToggle(<bang>0)

    function! QFixToggle(forced)
      if exists("g:qfix_win") && a:forced == 0
        cclose
        unlet g:qfix_win
      else
        copen 10
        let g:qfix_win = bufnr("$")
      endif
    endfunction
  ]], true)

  map_s('n', '<leader>qf', ':QFix<cr>')
  cmd([[ nnoremap <silent> ]q :<C-U>execute v:count1 . 'cnext'<CR> ]])
  cmd([[ nnoremap <silent> [q :<C-U>execute v:count1 . 'cprevious'<CR> ]])
end

function M.set_git_commit_format()
  cmd([[ autocmd Filetype gitcommit setlocal spell textwidth=72 colorcolumn=72 ]])
end

M.general_setting()
M.keymap()
M.set_resize_window()
M.disable_read_warning()
M.show_cursorline_window()
M.set_fix_window()
M.set_git_commit_format()
