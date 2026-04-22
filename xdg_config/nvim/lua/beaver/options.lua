vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.opt.guicursor = ""

vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.autoread = true
vim.opt.ruler = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.laststatus = 3
vim.opt.showmode = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80,120"
vim.opt.signcolumn = "yes"
vim.opt.winborder = "solid"

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.undofile = true
vim.opt.undolevels = 10000

vim.opt.diffopt = "internal,filler,indent-heuristic,algorithm:histogram"

vim.opt.title = true
-- vim.opt.titlestring = "%F - %{hostname()}"

vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = "unix"

vim.opt.errorbells = false
vim.opt.visualbell = false

vim.opt.timeoutlen = 500

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.breakindent = true

vim.opt.scrolloff = 3
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.mouse = ""

vim.opt.pumheight = 10

-- fold
-- source: https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
-- vim.opt.foldnestmax = 4

-- Misc
vim.opt.autoread = true
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.shortmess:append("I")
vim.opt.timeoutlen = 300

-- Disable providers
vim.api.nvim_set_var("loaded_python3_provider", 0)
vim.api.nvim_set_var("loaded_ruby_provider", 0)
vim.api.nvim_set_var("loaded_perl_provider", 0)
vim.api.nvim_set_var("loaded_node_provider", 0)

-- Filetype
vim.filetype.add({
  patterns = {
    ["Dockerfile.*"] = "Dockerfile",
    [".*/playbooks/.*.yml"] = "yaml.ansible",
    [".*/playbooks/.*.yaml"] = "yaml.ansible",
  },
})
