vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt
opt.guicursor = ""

opt.termguicolors = true

opt.number = true
opt.relativenumber = true

opt.autoread = true
opt.ruler = true

opt.splitright = true
opt.splitbelow = true

opt.laststatus = 3
opt.showmode = true
opt.cursorline = true
opt.colorcolumn = "80,120"
opt.signcolumn = "yes"
opt.winborder = "solid"

opt.swapfile = false
opt.backup = false

opt.undofile = true
opt.undolevels = 10000

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

-- Misc
opt.autoread = true
opt.exrc = true
opt.secure = true
opt.shortmess:append("I")
opt.timeoutlen = 300

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
