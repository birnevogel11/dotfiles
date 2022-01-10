local M = {}
local opt = vim.opt

local config_util = require('yen3.util.config')

function M.setup_color()
  opt.termguicolors = true

  -- vim.cmd([[ syntax enable ]])
  require('yen3.sunsetshiba').setup()
end

function M.setup_options()
  vim.g.mapleader = ","

  vim.cmd([[ imap jk <Esc> ]])

  opt.number = true
  opt.relativenumber = true
  opt.autoread = true     -- Auto reload file when the file content is changed
  opt.ruler = true        -- Show the cursor position all the time
  vim.cmd([[ filetype on ]])
  vim.cmd([[ filetype plugin on ]])
  vim.cmd([[ filetype indent on ]])

  opt.laststatus = 2
  opt.showmode = true     -- Show current input mode in status line
  opt.cursorline = true   -- Show Cursor Line in Underline
  opt.colorcolumn = '80'
  opt.backup = false
  opt.swapfile = false

  opt.diffopt = "internal,filler,indent-heuristic,algorithm:histogram"

  opt.title = true
  opt.titlestring = "%F - %{hostname()}"

  opt.fileencoding = "utf-8"
  opt.fileformat = 'unix'

  opt.errorbells = false
  opt.visualbell = false

  opt.timeoutlen = 500

  opt.ignorecase = true
  opt.incsearch = true
  opt.showmatch = true
  opt.smartcase = true

  config_util.map_n('<leader>du', ':nohl<cr>')

  opt.autoindent = true
  opt.shiftwidth = 4
  opt.softtabstop = 4
  opt.tabstop = 4
  opt.expandtab = true
end

function M.edit_keymapping()
  config_util.map_n('<tab>', 'v>')
  config_util.map_n('<s-tab>', 'v<')
  config_util.create_keymap('v', '<tab>', '>gv')
  config_util.create_keymap('v', '<s-tab>', '<gv')
end

function M.tab_keymapping()
  opt.listchars = 'tab:>-'
  config_util.map_n('<leader>tc', ':tabnew<cr>')
  config_util.map_n('<leader>te', ':tabedit<space>')
  config_util.map_n('<leader>tm', ':tabmove<space>')
  config_util.map_n('<C-N>', ':tabnext<cr>')
  config_util.map_n('<C-P>', ':tabprev<cr>')
end

function M.buffer_keymapping()
  config_util.map_n('bj', ':bnext<cr>')
  config_util.map_n('bk', ':bprev<cr>')
end

function M.disable_read_only_warning()
  vim.cmd [[ augroup no_ro_warn                    ]]
  vim.cmd [[     au!                               ]]
  vim.cmd [[     au FileChangedRO * set noreadonly ]]
  vim.cmd [[ augroup END                           ]]
end

function M.show_cursor_line_in_current_window_only()
  -- Only show cursorline in the current window
  vim.cmd [[ augroup cline                                                               ]]
  vim.cmd [[   au!                                                                       ]]
  vim.cmd [[   au VimEnter,WinEnter,BufWinEnter * setlocal cursorline                    ]]
  vim.cmd [[   au WinLeave * if &filetype !=# 'denite' | setlocal nocursorline | endif   ]]
  vim.cmd [[ augroup END                                                                 ]]
end

function M.resize_splits_when_window_changes()
-- Resize splits when the Vim window is resized
  vim.cmd [[ augroup vim_resized           ]]
  vim.cmd [[   au!                         ]]
  vim.cmd [[   au VimResized * :wincmd =   ]]
  vim.cmd [[ augroup END                   ]]
end

function M.remove_trailing_space()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local rtrim_lines = {}
  for i, line in ipairs(lines) do
    rtrim_lines[i] = vim.fn.substitute(line, '\\s\\+$', '', '')
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, rtrim_lines)
end


function M.remove_trailing_end_lines()
  vim.cmd [[ :%s#\($\n\s*\)\+\%$## ]]
end

function M.remove_redundant_space()
  M.remove_trailing_space()
  M.remove_trailing_end_lines()
end

function M.remove_extra_spaces_before_save()
  -- augroup remove_unnecessary_space
  --   au!
  --   autocmd FileType c,cpp,python,yaml,json,txt,markdown,vim,haskell,javascript,rust,go
  --     \ autocmd BufWritePre <buffer>
  --     \ :silent! call s:yen3_remove_unncessary_space()
  -- augroup END

end

function M.setup()
  M.setup_color()
  M.setup_options()

  M.tab_keymapping()
  M.edit_keymapping()
  M.buffer_keymapping()

  -- Autocmds
  M.disable_read_only_warning()
  M.show_cursor_line_in_current_window_only()
  M.resize_splits_when_window_changes()

  vim.cmd [[ source ~/.config/nvim/vim/general.vim ]]
end

return M
