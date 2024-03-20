local M = {}

local keymap = require("yen3.lib.keymap").keymap
local keymap_n = require("yen3.lib.keymap").keymap_n

local setup_options = function()
  vim.o.guicursor = ""

  vim.o.termguicolors = true
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.autoread = true
  vim.o.ruler = true
  vim.o.splitright = true

  -- vim.o.ls = 1
  -- vim.o.ch = 0
  vim.o.laststatus = 3
  vim.o.showmode = true
  vim.o.cursorline = true
  vim.o.colorcolumn = "80,120"

  vim.o.swapfile = false
  vim.o.backup = false
  vim.o.undodir = os.getenv("HOME") .. "/.local/nvim/undrodir"
  vim.o.undofile = true

  vim.o.diffopt = "internal,filler,indent-heuristic,algorithm:histogram"

  vim.o.title = true
  vim.o.titlestring = "%F - %{hostname()}"

  vim.o.fileencoding = "utf-8"
  vim.o.fileformat = "unix"

  vim.o.errorbells = false
  vim.o.visualbell = false

  vim.o.timeoutlen = 500

  vim.o.hlsearch = true
  vim.o.incsearch = true
  vim.o.ignorecase = true
  vim.o.showmatch = true
  vim.o.smartcase = true

  keymap_n("<leader>du", ":nohl<cr>")

  vim.o.autoindent = true
  vim.o.shiftwidth = 4
  vim.o.softtabstop = 4
  vim.o.tabstop = 4
  vim.o.expandtab = true
  vim.o.breakindent = true

  vim.o.scrolloff = 3
  vim.o.signcolumn = "yes"

  vim.o.updatetime = 50

  vim.o.mouse = ""

  -- vim.o.spell = true

  -- vim.o.listchars = "tab:>-"

  vim.opt.pumheight = 10
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
  require("yen3.lib.set").set_variables({
    -- loaded_python3_provider = 0,
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
    vim.o.relativenumber = not vim.o.relativenumber
  end, "Toogle relative number")

  keymap_n("<leader>wm", function()
    local value = vim.o.mouse
    if value == "nvi" then
      vim.o.mouse = ""
      require("yen3.lib.notify").notify("Mouse mode", "Disable mouse")
    else
      vim.o.mouse = "nvi"
      require("yen3.lib.notify").notify("Mouse mode", "Enable mouse - nvi")
    end
  end, "Toggle mouse mode")

  keymap_n("<leader>ww", function()
    -- vim.lsp.inlay_hint(vim.api.nvim_get_current_buf(), nil)
    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
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

  -- Colorscheme config
  require("yen3.sunsetshiba").setup()
end

return M
