local config_util = require("yen3.util.config")

local M = {}

function M._packer_check_install()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
  end
end

function M.packer()
  M._packer_check_install()

  vim.cmd([[ packadd packer.nvim ]])

  return require("packer").startup(M.packer_plugins)
end

function M.packer_plugins(use)
  use "wbthomason/packer.nvim"

  use "nathom/filetype.nvim"

  -- Color scheme
  use "tjdevries/colorbuddy.nvim"

  -- Apperence
  use { "alvarosevilla95/luatab.nvim", requires = "kyazdani42/nvim-web-devicons" }
  use "kyazdani42/nvim-web-devicons"
  use { "wsdjeg/vim-todo", opt = true, cmd = {'OpenTodo'}, }
  use { "majutsushi/tagbar", opt = true, cmd = { 'TagbarOpen' },
    requires = "tenfyzhong/tagbar-makefile.vim"
  }
  use "rcarriga/nvim-notify"
  use { "mtdl9/vim-log-highlighting", ft = { 'log' } }

  -- Status line
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  }

  -- Tree sitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use { "nvim-treesitter/nvim-treesitter-textobjects" }
  use { "nvim-treesitter/playground", run = ":TSInstall query" }
  -- use {'nvim-treesitter/nvim-treesitter-refactor'}

  -- Generic
  use "aymericbeaumet/vim-symlink"
  use { "vim-test/vim-test", opt = true, cmd = { 'TestNearest', 'TestFile' },
    requires = "benmills/vimux" }
  use "kamykn/spelunker.vim"
  use "farmergreg/vim-lastplace"
  use {"norcalli/nvim-colorizer.lua", event = "BufReadPost",
    config = function()
      vim.opt.termguicolors = true
      require("colorizer").setup()
    end
  }
  use "embear/vim-localvimrc"

  -- File browser
  use "voldikss/vim-floaterm"
  use { "ptzz/lf.vim", opt = true, cmd = { 'Lf', 'Lfcd', 'LfCurrentDirectory' }, }

  -- Edit
  use "MarcWeber/vim-addon-mw-utils"
  use "tpope/vim-abolish"
  use "tpope/vim-endwise"
  use "9mm/vim-closer"
  use "tpope/vim-rhubarb"
  use {"tpope/vim-speeddating", event = "BufReadPost", }
  use {"tpope/vim-surround", event = "BufReadPost", }
  use "junegunn/vim-easy-align"
  use {"lukas-reineke/indent-blankline.nvim", event = "BufReadPre",
    config = function()
      require("indent_blankline").setup({
        filetype_exclude = {
            "help",
            "dashboard",
            "dashpreview",
            "LuaTree",
            "vista",
            "sagahover",
            "NvimTree",
            "fzf",
            "floaterm",
            "startify",
            "packer",
            "toggleterm",
        },
        space_char_blankline = " ",
        show_current_context = false,
        show_current_context_start = false,
      })
    end
  }
  use {"numToStr/Comment.nvim", event = "BufReadPost", config = function () require("Comment").setup() end}
  use "windwp/nvim-autopairs"
  use "ntpeters/vim-better-whitespace"

  use { "kevinhwang91/nvim-bqf", branch = "main" }
  use "google/vim-searchindex"

  use { "anufrievroman/vim-angry-reviewer", opt = true, cmd = { "AngryReviewer" }}

  -- CSV
  use { "chrisbra/csv.vim", ft = "csv" }

  -- Nix
  use { "LnL7/vim-nix", ft = "nix" }

  -- TOML
  use { "cespare/vim-toml", ft = { "toml" } }

  -- Haskell
  use { "yen3/haskell-vim", ft = "haskell", branch = "record-color" }
  -- use {'alx741/vim-hindent', ft = 'haskell'}
  use { "alx741/vim-stylishask", ft = "haskell" }
  use { "ndmitchell/ghcid", ft = "haskell", rtp = "plugins/nvim" }
  use { "monkoose/fzf-hoogle.vim", ft = { "haskell" }, requires = { "junegunn/fzf.vim" } }

  -- LaTeX
  use { "lervag/vimtex", ft = "tex" }

  -- Rust
  use { "rust-lang/rust.vim", ft = "rust" }
  use { "Chiel92/vim-autoformat", ft = "rust" }

  -- Markdown
  use { "plasticboy/vim-markdown", ft = "markdown" }
  use { "iamcco/markdown-preview.nvim", ft = "markdown", run = "cd app && yarn install" }

  -- Python
  use { "vim-python/python-syntax", ft = "python" }
  use { "psf/black", ft = "python" }
  use { "jeetsukumaran/vim-pythonsense", ft = "python" }
  if vim.fn.executable("stack") == 1 then
    use {
      "https://gitlab.com/yen3/pyimport-sort-cdm.git",
      ft = "python",
      run = "stack install",
    }
  end

  -- Rescript
  -- use {'rescript-lang/vim-rescript'}

  -- JavaScript/TypeScript
  local js_types = { "javascript", "typescript", "typescriptreact" }
  use { "alvan/vim-closetag", ft = js_types }
  use { "pangloss/vim-javascript", ft = js_types }
  use { "mxw/vim-jsx", ft = js_types }
  use { "othree/yajs.vim", ft = js_types }
  use { "HerringtonDarkholme/yats.vim", ft = js_types, run = "rm -rf UltiSnips" }
  use { "turbio/bracey.vim", ft = js_types, run = "npm install --prefix server" }
  use { "prettier/vim-prettier", ft = js_types }

  -- Git
  use { "tpope/vim-fugitive", opt = true, cmd = { 'Git' }, }
  use { "tpope/vim-dispatch" , opt = true, cmd = { 'Dispatch' } }
  use { "lambdalisue/gina.vim" , opt = true, cmd = { 'Gina' }, }
  use { "junegunn/gv.vim", opt = true, cmd = { 'GV' }, requires = { "tpope/vim-fugitive", opt = true } }
  use { "lewis6991/gitsigns.nvim", event = "BufReadPre", branch = "main", requires = { "nvim-lua/plenary.nvim" },
    config = function() require('gitsigns').setup() end
  }
  use { "TimUntersberger/neogit", requires = { "sindrets/diffview.nvim", "nvim-lua/plenary.nvim" } }

  -- Github
  -- use { "skanehira/gh.vim" }
  use { "pwntester/octo.nvim", opt = true, cmd = { 'Octo' }, config = function() require('octo').setup() end }

  -- Tmux
  use "christoomey/vim-tmux-navigator"
  use "tmux-plugins/vim-tmux-focus-events"

  -- Search
  use { "junegunn/fzf.vim", requires = { { "junegunn/fzf", run = "./install --all" }, } }
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      "nvim-telescope/telescope-github.nvim",
      { "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sql.nvim" } },
      { "AckslD/nvim-neoclip.lua",
        requires = { {'tami5/sqlite.lua', module = 'sqlite'}, },
        config = function() require('neoclip').setup { enable_persistant_history = true, } end,
      },
    },
  }

  -- Snippet
  use "hrsh7th/cmp-vsnip"
  use "hrsh7th/vim-vsnip"
  use "rafamadriz/friendly-snippets"

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    requires = {
      { "tami5/lspsaga.nvim", branch = "main" },
      { "ray-x/lsp_signature.nvim" },
      { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
      { "nvim-lua/lsp-status.nvim" },
      -- { 'jubnzv/virtual-types.nvim' }
    },
  }
  use {
    "hrsh7th/nvim-cmp",
    branch = "main",
    requires = {
      { "andersevenrud/cmp-tmux", branch = "main" },
      { "hrsh7th/cmp-nvim-lsp", branch = "main" },
      { "hrsh7th/cmp-buffer", branch = "main" },
      { "hrsh7th/cmp-path", branch = "main" },
      { "onsails/lspkind-nvim", branch = "master" },
    },
  }

  -- Diagnostics
  use {
    "folke/trouble.nvim", opt = true, cmd = { 'TroubleToggle' },
    config = function() require("trouble").setup {} end,
    requires = "kyazdani42/nvim-web-devicons",
  }
  use { "jose-elias-alvarez/null-ls.nvim", branch = "main" }

  -- Misc
  use { "tweekmonster/startuptime.vim", cmd = "StartupTime" }
  -- use { "dstein64/vim-startuptime", cmd = "StartupTime" }
end

function M.vim_better_whitespace()
  config_util.set_variables {
    better_whitespace_enabled = 1,
    strip_whitespace_on_save = 1,
    strip_whitelines_at_eof = 1,
    show_spaces_that_precede_tabs = 1,
    strip_whitespace_confirm = 0,
    strip_max_file_size = 1000,
  }
end

function M.vim_markdown()
  config_util.set_variables {
    vim_markdown_folding_disabled = 1,
    vim_markdown_folding_style_pythonic = 1,
    vim_markdown_override_foldtext = 0,
    vim_markdown_new_list_item_indent = 0,
    vim_markdown_auto_insert_bullets = 1,
    vim_markdown_conceal = 0,
    vim_markdown_conceal_code_blocks = 0,
  }
end

function M.tagbar()
  config_util.set_variables {
    tagbar_map_openfold = { "zo", "l" },
    tagbar_map_closeallfolds = "zm",
    tagbar_map_openallfolds = "zr",

    tagbar_width = 40,
    tagbar_autofocus = 1, -- Keep focus on tagbar window
    tagbar_sort = 1, -- Sort tags alphabetically
    tagbar_compact = 1,
    tagbar_indent = 1,
    tagbar_autopreview = 0, -- Don't autopreview, enable it with P
    tagbar_previewwin_pos = "belowright",

    tagbar_type_python = {
      kinds = {
        "i:modules:1:0",
        "c:classes",
        "f:functions",
        "m:members",
        "v:variables:0:0",
        "x:unknowns",
      },
    },
  }

  config_util.map_n("<leader>tb", ":TagbarOpen jc<cr>")
end

function M.vim_angry_reviewer()
  config_util.set_variables {
    AngryReviewerEnglish = "american",
  }

  config_util.map_n("<leader>ar", ":AngryReviewer<cr>")
end

function M.vim_test()
  config_util.set_variables {
    ["test#strategy"] = "vimux",
    ["test#python#runner"] = "nose",
    ["test#python#nose#options"] = { nearest = "-sv --config /dev/null" },
  }
  config_util.map_n("<leader>rt", ":TestNearest<cr>")
  config_util.map_n("<leader>rT", ":TestFile<cr>")
end

function M.black_python()
  config_util.set_variables {
    black_linelength = 120,
    black_virtualenv = "~/.local/share/nvim/black",
  }
end

function M.python_black_format()
  vim.cmd([[ :PyImportSortCDM ]])
  vim.cmd([[ :w!              ]])
  vim.cmd([[ :Black           ]])
end

function M.vim_lastplace()
  config_util.set_variables {
    lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit",
    lastplace_ignore_buftype = "quickfix,nofile,help",
  }
end

function M.luatab_nvim()
  local luatab = require('luatab')
  local helpers = luatab.helpers

  local title = function(bufnr)
    local name = helpers.title(bufnr)
    if name ~= '[No Name]' then
      name = '[' .. name .. ']'
    end
    return name
  end

  local cell = function(index)
    local isSelected = vim.fn.tabpagenr() == index
    local buflist = vim.fn.tabpagebuflist(index)
    local winnr = vim.fn.tabpagewinnr(index)
    local bufnr = buflist[winnr]
    local hl = (isSelected and '%#TabLineSel#' or '%#TabLine#')

    return hl .. '%' .. index .. 'T' .. ' ' ..
        index .. ':' ..
        title(bufnr) .. ' ' ..
        helpers.modified(bufnr)
  end

  luatab.setup { cell = cell }
end

function M.indent_blankline()
  require("indent_blankline").setup{
    filetype_exclude = {
        "help",
        "dashboard",
        "dashpreview",
        "LuaTree",
        "vista",
        "sagahover",
        "NvimTree",
        "fzf",
        "floaterm",
        "startify",
        "packer",
        "toggleterm",
    },
    space_char_blankline = " ",
    show_current_context = false,
    show_current_context_start = false,
  }
end

function M.packer_keymap()
  config_util.map_n("<leader>pc", ":PackerCompile<cr>")
  config_util.map_n("<leader>pl", ":PackerClean<cr>")
  config_util.map_n("<leader>pi", ":PackerInstall<cr>")
  config_util.map_n("<leader>pu", ":PackerUpdate<cr>")
end

function M.nvim_autopair()
  require('nvim-autopairs').setup {
    disable_filetype = { "TelescopePrompt" , "vim" },
  }
end

function M.local_vimrc()
  config_util.set_variables {
    localvimrc_sandbox = 0,
    localvimrc_persistent = 1,
  }
end

function M.vim_easy_align()
  -- Start interactive EasyAlign in visual mode (e.g. vipga)
  vim.cmd [[ xmap ga <Plug>(EasyAlign) ]]

  -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
  vim.cmd [[ nmap ga <Plug>(EasyAlign) ]]
end

function M.general_plugin_config()
  M.black_python()
  M.tagbar()
  M.vim_better_whitespace()
  M.vim_lastplace()
  M.vim_markdown()
  M.vim_test()
  M.vim_angry_reviewer()
  M.luatab_nvim()
  M.packer_keymap()
  M.nvim_autopair()
  M.local_vimrc()
  M.vim_easy_align()
end

function M.plugin_config()
  M.general_plugin_config()

  local config_module_names = {
    'git',
    'diagnostic',
    'status_line',
    'search',
    'lsp_status',
    'lsp',
    'cmp',
    'treesitter',
    'spell',
  }
  for _, name in ipairs(config_module_names) do
    require('yen3.' .. name).setup()
  end
end

function M.setup()
  M.packer()
  M.plugin_config()
end

return M
