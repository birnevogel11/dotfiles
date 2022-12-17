local M = {}
local opt = vim.opt

local keymap = require('yen3.lib.keymap').keymap
local keymap_n = require('yen3.lib.keymap').keymap_n

local setup_color = function()
  opt.termguicolors = true

  local colorbuddy_ok, _ = pcall(require, "colorbuddy")
  if colorbuddy_ok then
    require('yen3.sunsetshiba').setup()
  end
end

local setup_options = function()
  vim.g.mapleader = ","

  keymap("i", "jk", "<ESC>")

  opt.number = true
  opt.relativenumber = true
  opt.autoread = true
  opt.ruler = true

  opt.laststatus = 3
  opt.showmode = true
  opt.cursorline = true
  opt.colorcolumn = '79,119'
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

  keymap_n('<leader>du', ':nohl<cr>')

  opt.autoindent = true
  opt.shiftwidth = 4
  opt.softtabstop = 4
  opt.tabstop = 4
  opt.expandtab = true

  opt.isfname:append("@-@")

  opt.updatetime = 50

  opt.mouse = ''

  -- opt.spell = true

  vim.o.ls = 1
  vim.o.ch = 0
end

local edit_keymapping = function()
  keymap_n('<tab>', 'v>')
  keymap_n('<s-tab>', 'v<')
  keymap('v', '<tab>', '>gv')
  keymap('v', '<s-tab>', '<gv')

  keymap('v', 'J', ":m '>+1<CR>gv=gv")
  keymap('v', 'K', ":m '<-2<CR>gv=gv")
  keymap('i', 'J', "mzJ`z")

  keymap_n("<C-d>", "<C-d>zz")
  keymap_n("<C-u>", "<C-u>zz")

  keymap_n("n", "nzzzv")
  keymap_n("N", "Nzzzv")

  vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
end

local tab_keymapping = function()
  opt.listchars = 'tab:>-'
  keymap_n('<leader>tc', ':tabnew<cr>')
  keymap_n('<leader>te', ':tabedit<space>')
  keymap_n('<leader>tm', ':tabmove<space>')
  keymap_n('<C-N>', ':tabnext<cr>')
  keymap_n('<C-P>', ':tabprev<cr>')
end

local buffer_keymapping = function()
  keymap_n('<leader>bj', ':bnext<cr>')
  keymap_n('<leader>bk', ':bprev<cr>')
end

local disable_read_only_warning = function()
  vim.api.nvim_create_autocmd("FileChangedRO", {
    group = vim.api.nvim_create_augroup("yen3_NoReadOnlyWarning", { clear = true } ),
    command = "set noreadonly",
  })
end

local show_cursor_line_in_current_window_only = function()
  local group = vim.api.nvim_create_augroup("yen3_SetCursorLineCurrentWindow", { clear = true })
  vim.api.nvim_create_autocmd(
    {"VimEnter", "WinEnter", "BufWinEnter"},
    { command = "setlocal cursorline", group = group }
  )
  vim.api.nvim_create_autocmd(
    "WinLeave",
    { command = "setlocal nocursorline", group = group }
  )
end

local resize_splits_when_window_changes = function()
  vim.api.nvim_create_autocmd("VimResized", {
    command = ":wincmd =",
    group = vim.api.nvim_create_augroup("yen3_ResizeWindow", { clear = true }),
  })
end

local remove_extra_spaces_before_save = function()
  vim.api.nvim_create_autocmd(
    "BufWritePre", {
      group = vim.api.nvim_create_augroup("yen3_remove_unnecessary_space", { clear = true }),
      callback = function()
        -- Remove trailing space for each line
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        local rtrim_lines = {}
        for i, line in ipairs(lines) do
          rtrim_lines[i] = vim.fn.substitute(line, '\\s\\+$', '', '')
        end

        vim.api.nvim_buf_set_lines(0, 0, -1, false, rtrim_lines)
      end,
      -- buffer = 0,
    }
  )
end

local ftdetect = function()
  vim.filetype.add({
    extension = {
      purs = 'purescript',
      racket = 'racket',
    },
    patterns = {
      ['Dockerfile*'] = 'Dockerfile',
      ['*/playbooks/*.yml'] = 'yaml.ansible',
      ['*/playbooks/*.yaml'] = 'yaml.ansible',
    }
  })
end

local quickfix_keymapping = function()
  keymap_n("<leader>qf",
    function()
      -- ref: https://www.reddit.com/r/neovim/comments/ol2vx4/how_to_toggle_quickfix_with_lua/
      local qf_exists = false
      for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
          qf_exists = true
        end
      end

      if qf_exists then
        vim.fn.execute("cclose")
      else
        vim.fn.execute("copen 10")
      end
    end,
  "Toggle quickfix win"
  )
  keymap_n("]q", "<cmd>execute v:count1 . 'cnext'<cr>")
  keymap_n("[q", "<cmd>execute v:count1 . 'cprevious'<cr>")
end

M.setup = function()
  -- Enable sunsetshiba_color
  setup_color()

  -- Config vim general options
  setup_options()

  -- keymapping
  tab_keymapping()
  edit_keymapping()
  buffer_keymapping()
  quickfix_keymapping()

  -- Autocmds
  disable_read_only_warning()
  show_cursor_line_in_current_window_only()
  resize_splits_when_window_changes()
  remove_extra_spaces_before_save()

  -- filetype detect
  ftdetect()
end

return M
