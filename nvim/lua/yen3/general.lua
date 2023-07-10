local M = {}

local keymap = require("yen3.lib.keymap").keymap
local keymap_n = require("yen3.lib.keymap").keymap_n

local setup_options = function()
  vim.g.mapleader = ","

  -- keymap("i", "jk", "<ESC>")

  vim.o.termguicolors = true
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.autoread = true
  vim.o.ruler = true

  -- vim.o.ls = 1
  -- vim.o.ch = 0
  vim.o.laststatus = 3
  vim.o.showmode = true
  vim.o.cursorline = true
  vim.o.colorcolumn = "79,119"
  vim.o.backup = false
  vim.o.swapfile = false

  vim.o.diffopt = "internal,filler,indent-heuristic,algorithm:histogram"

  vim.o.title = true
  vim.o.titlestring = "%F - %{hostname()}"

  vim.o.fileencoding = "utf-8"
  vim.o.fileformat = "unix"

  vim.o.errorbells = false
  vim.o.visualbell = false

  vim.o.timeoutlen = 500

  vim.o.ignorecase = true
  vim.o.incsearch = true
  vim.o.showmatch = true
  vim.o.smartcase = true
  vim.o.hlsearch = true

  keymap_n("<leader>du", ":nohl<cr>")

  vim.o.autoindent = true
  vim.o.shiftwidth = 4
  vim.o.softtabstop = 4
  vim.o.tabstop = 4
  vim.o.expandtab = true
  vim.o.breakindent = true

  vim.o.scrolloff = 3
  vim.wo.signcolumn = "yes"

  vim.o.updatetime = 250

  vim.o.mouse = ""

  -- vim.o.spell = true

end

local edit_keymapping = function()
  keymap("v", "<tab>", ">gv")
  keymap("v", "<s-tab>", "<gv")
  keymap_n("<tab>", "v>")
  keymap_n("<s-tab>", "v<")

  keymap_n("<C-d>", "<C-d>zz")
  keymap_n("<C-u>", "<C-u>zz")

  keymap_n("n", "nzzzv")
  keymap_n("N", "Nzzzv")

  vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

  -- Remap for dealing with word wrap
  vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
end

local tab_keymapping = function()
  vim.o.listchars = "tab:>-"
  keymap_n("<leader>tc", ":tabnew<cr>")
  keymap_n("<leader>te", ":tabedit<space>")
  keymap_n("<leader>tm", ":tabmove<space>")
  keymap_n("<C-N>", ":tabnext<cr>")
  keymap_n("<C-P>", ":tabprev<cr>")
end

local buffer_keymapping = function()
  keymap_n("<leader>bj", ":bnext<cr>")
  keymap_n("<leader>bk", ":bprev<cr>")
end

local disable_read_only_warning = function()
  vim.api.nvim_create_autocmd("FileChangedRO", {
    group = vim.api.nvim_create_augroup("yen3_NoReadOnlyWarning", { clear = true }),
    command = "set noreadonly",
  })
end

local show_cursor_line_in_current_window_only = function()
  local group = vim.api.nvim_create_augroup("yen3_SetCursorLineCurrentWindow", { clear = true })
  vim.api.nvim_create_autocmd(
    { "VimEnter", "WinEnter", "BufWinEnter" },
    { command = "setlocal cursorline", group = group }
  )
  vim.api.nvim_create_autocmd("WinLeave", { command = "setlocal nocursorline", group = group })
end

local resize_splits_when_window_changes = function()
  vim.api.nvim_create_autocmd("VimResized", {
    command = ":wincmd =",
    group = vim.api.nvim_create_augroup("yen3_ResizeWindow", { clear = true }),
  })
end

local highlight_yanked_region = function()
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("yen3_highlight_yank", { clear = true }),
    callback = function()
      vim.highlight.on_yank({ higroup="HighlightedyankRegion", timeout=100 })
    end,
  })
end

local ftdetect = function()
  vim.filetype.add({
    extension = {
      purs = "purescript",
      racket = "racket",
    },
    patterns = {
      ["Dockerfile.*"] = "Dockerfile",
      [".*/playbooks/.*.yml"] = "yaml.ansible",
      [".*/playbooks/.*.yaml"] = "yaml.ansible",
    },
  })
end

local quickfix_keymapping = function()
  keymap_n("<leader>qf", function()
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
  end, "Toggle quickfix win")
  keymap_n("]q", "<cmd>execute v:count1 . 'cnext'<cr>")
  keymap_n("[q", "<cmd>execute v:count1 . 'cprevious'<cr>")
end

local reload_config_keymapping = function()
  keymap_n("<leader>pr", function()
    for name,_ in pairs(package.loaded) do
      if name:match('^cnull') then
        package.loaded[name] = nil
      end
    end

    dofile(vim.env.MYVIMRC)
    require("yen3.lib.notify").notify("Neovim", "Realod the neovim config")
  end, "Reload neovim config")
end

local disable_providers = function()
  vim.api.nvim_set_var("loaded_python3_provider", 0)
  vim.api.nvim_set_var("loaded_ruby_provider", 0)
  vim.api.nvim_set_var("loaded_perl_provider", 0)
  vim.api.nvim_set_var("loaded_node_provider", 0)
end

local show_current_file_path_mapping = function()
  keymap_n("<leader>fp", function() print(vim.fn.expand('%:p')) end)
end

local toggle_relative_number = function()
  keymap_n("<leader>nn", function()
    vim.o.relativenumber = not vim.o.relativenumber
  end)
end

M.setup = function()
  -- Config vim general options
  setup_options()
  disable_providers()

  -- keymapping
  tab_keymapping()
  edit_keymapping()
  buffer_keymapping()
  quickfix_keymapping()
  -- reload_config_keymapping()
  show_current_file_path_mapping()
  toggle_relative_number()

  -- Autocmds
  disable_read_only_warning()
  show_cursor_line_in_current_window_only()
  resize_splits_when_window_changes()
  highlight_yanked_region()

  -- filetype detect
  ftdetect()

  -- Colorscheme config
  require("yen3.sunsetshiba").setup()
end

return M
