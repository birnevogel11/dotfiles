local M = {}

local setup_options = function()
  local opt = vim.opt
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
  -- opt.titlestring = "%F - %{hostname()}"

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

  -- fold
  -- source: https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/
  opt.foldmethod = "expr"
  opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  opt.foldcolumn = "0"
  opt.foldtext = ""
  opt.foldlevel = 99
  opt.foldlevelstart = 99
  -- opt.foldnestmax = 4

  -- vim.o.autocomplete = true

  require("vim._core.ui2").enable()
end

local edit_keymapping = function()
  vim.keymap.set("n", "<leader>du", ":nohl<cr>")

  vim.keymap.set("v", ">", ">gv")
  vim.keymap.set("v", "<", "<gv")
  vim.keymap.set("n", ">", "v>")
  vim.keymap.set("n", "<", "v<")

  vim.keymap.set("n", "<C-f>", "<C-f>zz")
  vim.keymap.set("n", "<C-b>", "<C-b>zz")

  vim.keymap.set("n", "n", "nzzzv")
  vim.keymap.set("n", "N", "Nzzzv")

  vim.keymap.set("n", "Q", "<nop>")
  vim.keymap.set(
    "n",
    "<leader>wr",
    ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    { desc = "Replace current word" }
  )
  vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Past word" })
  vim.keymap.set("i", "<C-c>", "<Esc>")
end

local tab_keymapping = function()
  vim.keymap.set("n", "<leader>tc", ":tabnew<cr>", { desc = "Tab: new" })
  vim.keymap.set("n", "<leader>tj", ":+tabmove<cr>", { desc = "Tab: move next" })
  vim.keymap.set("n", "<leader>tk", ":-tabmove<cr>", { desc = "Tab: move prev" })
  vim.keymap.set("n", "<C-N>", ":tabnext<cr>", { desc = "Tab: switch to next" })
  vim.keymap.set("n", "<C-P>", ":tabprev<cr>", { desc = "Tab: switch to prev" })
end

local ftdetect = function()
  vim.filetype.add({
    patterns = {
      ["Dockerfile.*"] = "Dockerfile",
      [".*/playbooks/.*.yml"] = "yaml.ansible",
      [".*/playbooks/.*.yaml"] = "yaml.ansible",
    },
  })
end

local disable_providers = function()
  vim.api.nvim_set_var("loaded_python3_provider", 0)
  vim.api.nvim_set_var("loaded_ruby_provider", 0)
  vim.api.nvim_set_var("loaded_perl_provider", 0)
  vim.api.nvim_set_var("loaded_node_provider", 0)
end

local misc_key_mapping = function()
  local opt = vim.opt

  vim.keymap.set("n", "<leader>wv", function() vim.cmd.restart() end)

  vim.keymap.set("n", "<leader>xr", "<cmd>!chmod +x %<CR>", { desc = "Chmod executable" })

  vim.keymap.set("n", "<leader>wp", function()
    print(vim.fn.expand("%:p"))
  end, { desc = "Show current file path" })

  vim.keymap.set("n", "<leader>wn", function()
    ---@diagnostic disable-next-line: undefined-field
    opt.relativenumber = not opt.relativenumber._value
  end, { desc = "Toogle relative number" })

  vim.keymap.set("n", "<leader>wm", function()
    ---@diagnostic disable-next-line: undefined-field
    local value = vim.opt.mouse._value
    if value == "nvi" then
      opt.mouse = ""
      require("bv11.lib.notify").notify("Mouse mode", "Disable mouse")
    else
      opt.mouse = "nvi"
      require("bv11.lib.notify").notify("Mouse mode", "Enable mouse - nvi")
    end
  end, { desc = "Toggle mouse mode" })

  vim.keymap.set("n", "<leader>wl", "<cmd>luafile %<CR>", { desc = "Source current lua file" })

  vim.keymap.set("n", "<leader>wf", function()
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
  end, { desc = "Toggle quickfix win" })
end

M.setup = function()
  -- Config vim general options
  disable_providers()
  setup_options()

  -- keymapping
  tab_keymapping()
  edit_keymapping()
  misc_key_mapping()

  -- filetype detect
  ftdetect()
end

return M
