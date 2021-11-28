local M = {}
local opt = vim.opt

local config_util = require('util.config')

function M.setup_color()
  opt.termguicolors = true

  vim.cmd([[ syntax enable ]])
  require('yen3.onedarkishii').setup()
end

function M.setup_options()
  vim.g.mapleader = ","

  vim.cmd([[ imap jk <Esc> ]])

  opt.ttyfast = true
  opt.number = true
  opt.relativenumber = true
  opt.autoread = true  -- auto reload file when the file content is changed
  opt.ruler = true  -- show the cursor position all the time
  vim.cmd([[ filetype on ]])
  vim.cmd([[ filetype plugin on ]])
  vim.cmd([[ filetype indent on ]])

  opt.laststatus = 2
  opt.showmode = true  -- Show current input mode in status line
  opt.cursorline = true  -- Show Cursor Line in Underline
  opt.wildmenu = true
  opt.colorcolumn = '80'
  opt.backup = false
  opt.swapfile = false

  opt.diffopt = "internal,filler,indent-heuristic,algorithm:histogram"

  opt.title = true
  opt.titlestring = "%F - %{hostname()}"

  opt.encoding = "utf-8"
  opt.fileencoding = "utf-8"

  opt.errorbells = false
  opt.visualbell = false

  opt.timeoutlen = 500

  opt.hlsearch = true
  opt.ignorecase = true
  opt.incsearch = true
  opt.showcmd = true
  opt.showmatch = true
  opt.smartcase = true

  config_util.map_n('<leader>du', ':nohl<cr>')

  opt.backspace = "indent,eol,start"
  opt.autoindent = true
  opt.smarttab = true   -- insert tabs on the start of a line according to context
  opt.shiftwidth = 4
  opt.softtabstop = 4
  opt.tabstop = 4
  opt.expandtab = true

  config_util.map_n('<tab>', 'v>')
  config_util.map_n('<s-tab>', 'v<')
  config_util.create_keymap('v', '<tab>', '>gv')
  config_util.create_keymap('v', '<s-tab>', '<gv')

  opt.listchars = 'tab:>-'
  config_util.map_n('<leader>tc', ':tabnew<cr>')
  config_util.map_n('<leader>te', ':tabedit<space>')
  config_util.map_n('<leader>tm', ':tabmove<space>')
  config_util.map_n('<C-N>', ':tabnext<cr>')
  config_util.map_n('<C-M>', ':tabprev<cr>')

  config_util.map_n('bj', ':bnext<cr>')
  config_util.map_n('bk', ':bprev<cr>')
end

function M.setup()
  M.setup_color()
  M.setup_options()

  vim.cmd([[ source ~/.config/nvim/vim/general.vim ]])
end

return M
