local M = {}
local opt = vim.opt

local config_util = require('yen3.util.config')

M.setup_color = function()
  opt.termguicolors = true
  require('yen3.sunsetshiba').setup()
end

M.setup_options = function()
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

M.edit_keymapping = function()
  config_util.map_n('<tab>', 'v>')
  config_util.map_n('<s-tab>', 'v<')
  config_util.create_keymap('v', '<tab>', '>gv')
  config_util.create_keymap('v', '<s-tab>', '<gv')
end

M.tab_keymapping = function()
  opt.listchars = 'tab:>-'
  config_util.map_n('<leader>tc', ':tabnew<cr>')
  config_util.map_n('<leader>te', ':tabedit<space>')
  config_util.map_n('<leader>tm', ':tabmove<space>')
  config_util.map_n('<C-N>', ':tabnext<cr>')
  config_util.map_n('<C-P>', ':tabprev<cr>')
end

M.buffer_keymapping = function()
  config_util.map_n('bj', ':bnext<cr>')
  config_util.map_n('bk', ':bprev<cr>')
end

M.disable_read_only_warning = function()
  local group = vim.api.nvim_create_augroup("yen3_NoReadOnlyWarning", { clear = true} )
  vim.api.nvim_create_autocmd("FileChangedRO", { command = "set noreadonly", group = group})
end

M.show_cursor_line_in_current_window_only = function()
  local group = vim.api.nvim_create_augroup("yen3_SetCursorLineCurrentWindow", { clear = true })
  vim.api.nvim_create_autocmd(
    {"VimEnter","WinEnter","BufWinEnter"},
    { command = "setlocal cursorline", group = group }
  )
  vim.api.nvim_create_autocmd(
    "WinLeave",
    { command = "setlocal nocursorline", group = group }
  )
end

M.resize_splits_when_window_changes = function()
  local group = vim.api.nvim_create_augroup("yen3_ResizeWindow", { clear = true })
  vim.api.nvim_create_autocmd("VimResized", { command = ":wincmd =", group = group })
end

M.remove_extra_spaces_before_save = function()
  local group = vim.api.nvim_create_augroup("yen3_remove_unnecessary_space", { clear = true })
  vim.api.nvim_create_autocmd(
    "BufWritePre",
    { callback = function()
        -- Remove trailing space for each line
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        local rtrim_lines = {}
        for i, line in ipairs(lines) do
          rtrim_lines[i] = vim.fn.substitute(line, '\\s\\+$', '', '')
        end

        vim.api.nvim_buf_set_lines(0, 0, -1, false, rtrim_lines)

        -- Remove trailng end lines
        -- vim.cmd [[ :%s#\($\n\s*\)\+\%$## ]]
      end,
      buffer = 0,
      group = group,
    }
  )
end

M.ftdetect = function()
  -- purescript-vim ftdetect does not work so add here manually ...
  vim.cmd [[ au BufNewFile,BufRead *.purs setf purescript ]]
  vim.cmd [[ au BufNewFile,BufRead *.racket setf racket   ]]
end

M._qfix_window_open = false

M.qfix_window_toggle = function()
  if M._qfix_window_open then
    vim.cmd [[ cclose ]]
    M._qfix_window_open = false
  else
    vim.cmd [[ copen 10 ]]
    M._qfix_window_open = true
  end
end

M.quickfix_keymapping = function()
  config_util.map_n("<leader>qf", "<cmd>lua require('yen3.general').qfix_window_toggle()<cr>")
  config_util.map_n("]q", "<cmd>execute v:count1 . 'cnext'<cr>")
  config_util.map_n("[q", "<cmd>execute v:count1 . 'cprevious'<cr>")
end

M.setup = function()
  -- Enable sunsetshiba_color
  M.setup_color()

  -- Config vim general options
  M.setup_options()

  -- keymapping
  M.tab_keymapping()
  M.edit_keymapping()
  M.buffer_keymapping()
  M.quickfix_keymapping()

  -- Autocmds
  M.disable_read_only_warning()
  M.show_cursor_line_in_current_window_only()
  M.resize_splits_when_window_changes()
  M.remove_extra_spaces_before_save()

  -- Workaround
  M.ftdetect()
end

return M
