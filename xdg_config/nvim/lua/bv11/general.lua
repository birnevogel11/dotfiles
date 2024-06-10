local M = {}

local keymap = require("bv11.lib.keymap").keymap
local keymap_n = require("bv11.lib.keymap").keymap_n
local opt = vim.opt

local setup_options = function()
  opt.guicursor = ""

  opt.termguicolors = true
  opt.number = true
  opt.relativenumber = true
  opt.autoread = true
  opt.ruler = true
  opt.splitright = true

  -- opt.ls = 1
  -- opt.ch = 0
  opt.laststatus = 3
  opt.showmode = true
  opt.cursorline = true
  opt.colorcolumn = "80,120"

  opt.swapfile = false
  opt.backup = false
  opt.undodir = os.getenv("HOME") .. "/.local/nvim/undrodir"
  opt.undofile = true

  opt.diffopt = "internal,filler,indent-heuristic,algorithm:histogram"

  opt.title = true
  opt.titlestring = "%F - %{hostname()}"

  opt.fileencoding = "utf-8"
  opt.fileformat = "unix"

  opt.errorbells = false
  opt.visualbell = false

  opt.timeoutlen = 500

  opt.hlsearch = true
  opt.incsearch = true
  opt.ignorecase = true
  opt.showmatch = true
  opt.smartcase = true
  opt.inccommand = "split"

  keymap_n("<leader>du", ":nohl<cr>")

  opt.autoindent = true
  opt.shiftwidth = 4
  opt.softtabstop = 4
  opt.tabstop = 4
  opt.expandtab = true
  opt.breakindent = true

  opt.scrolloff = 3
  opt.signcolumn = "yes"

  opt.updatetime = 50

  opt.mouse = ""

  -- opt.spell = true

  -- opt.listchars = "tab:>-"

  opt.pumheight = 10
end

local edit_keymapping = function()
  keymap("v", ">", ">gv")
  keymap("v", "<", "<gv")
  keymap_n(">", "v>")
  keymap_n("<", "v<")

  keymap_n("<C-f>", "<C-f>zz")
  keymap_n("<C-b>", "<C-b>zz")
  keymap_n("<C-d>", "<C-d>zz")
  keymap_n("<C-u>", "<C-u>zz")

  keymap_n("n", "nzzzv")
  keymap_n("N", "Nzzzv")

  keymap_n("<leader>wa", "=ap")
  keymap("v", "<leader>wa", "=")

  keymap_n("Q", "<nop>")
  vim.keymap.set("n", "<leader>wr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
  vim.keymap.set("x", "<leader>p", [["_dP]])
  keymap_n("<leader>x", "<cmd>!chmod +x %<CR>")
  vim.keymap.set("i", "<C-c>", "<Esc>")

  -- Diff merge keys, gu: right, gh: left
  -- vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
  -- vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
end

local tab_keymapping = function()
  keymap_n("<leader>tc", ":tabnew<cr>")
  keymap_n("<leader>tj", ":+tabmove<cr>")
  keymap_n("<leader>tk", ":-tabmove<cr>")
  keymap_n("<C-N>", ":tabnext<cr>")
  keymap_n("<C-P>", ":tabprev<cr>")
end

local buffer_keymapping = function()
  keymap_n("<leader>bj", ":bnext<cr>")
  keymap_n("<leader>bk", ":bprev<cr>")
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
    for _, win in pairs(vim.fn.getwininfo() or {}) do
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

local disable_providers = function()
  require("bv11.lib.set").set_variables({
    loaded_python3_provider = 0,
    loaded_ruby_provider = 0,
    loaded_perl_provider = 0,
    loaded_node_provider = 0,
  })
end

local misc_key_mapping = function()
  keymap_n("<leader>wp", function()
    print(vim.fn.expand("%:p"))
  end, "Show current file path")

  keymap_n("<leader>wn", function()
    opt.relativenumber = not opt.relativenumber
  end, "Toogle relative number")

  keymap_n("<leader>wm", function()
    local value = opt.mouse
    if value == "nvi" then
      opt.mouse = ""
      require("bv11.lib.notify").notify("Mouse mode", "Disable mouse")
    else
      opt.mouse = "nvi"
      require("bv11.lib.notify").notify("Mouse mode", "Enable mouse - nvi")
    end
  end, "Toggle mouse mode")

  keymap_n("<leader>ww", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, "Toogle inlay_hint")
end

M.setup = function()
  -- Config vim general options
  disable_providers()
  setup_options()

  -- keymapping
  tab_keymapping()
  edit_keymapping()
  buffer_keymapping()
  quickfix_keymapping()
  misc_key_mapping()

  -- filetype detect
  ftdetect()
end

return M
