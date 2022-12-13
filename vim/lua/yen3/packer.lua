local M = {}

local _packer_check_install = function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
  end
end

local _packer_keymap = function()
  -- local map_n = require("yen3.util.config").map_n
  local config_util = require("yen3.util.config")
  config_util.map_call_n("<leader>pc",
    function()
      vim.fn.execute(":PackerCompile")
      config_util.notify("Packer", "Generate packer_compiled.lua")
    end,
    "Packer compile"
  )
  config_util.map_n("<leader>ps", ":PackerSync<cr>")
end

local packer_plugins = function(use)
  use "wbthomason/packer.nvim"

  use "lewis6991/impatient.nvim"

  -- Color scheme
  use "tjdevries/colorbuddy.nvim"

  -- Generic
  use {"aymericbeaumet/vim-symlink", event = "BufRead"}
  use {"farmergreg/vim-lastplace", event = "BufReadPre",
    config = function() require('yen3.plugin_setup').vim_lastplace() end
  }
  use {"klen/nvim-config-local", config = function()
      require('config-local').setup({
        config_files = { ".vimrc.lua", ".vimrc", ".lvimrc", ".lvimrc.lua" },
        silent = true,
      }) end
  }
  -- TODO: try it
  -- use { "miversen33/netman.nvim", branch = "v1.1" }

  -- Apperence
  use { "alvarosevilla95/luatab.nvim", requires = "kyazdani42/nvim-web-devicons",
    config = function() require('yen3.plugin_setup').luatab_nvim() end
  }
  use { "majutsushi/tagbar", opt = true, cmd = { 'TagbarOpen' }, keys = {"<leader>tb"},
    config = function() require('yen3.plugin_setup').tagbar() end
  }
  use { "wsdjeg/vim-todo", opt = true, cmd = {'OpenTodo'}, }
  use { "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#272b33",
        stages = 'fade',
        timeout = 1000,
      })
    end
  }
  use {'shortcuts/no-neck-pain.nvim',
    keys = { "<leader>zz" },
    config = function()
      require("no-neck-pain").setup({ width = 120 })
      require('yen3.util.config').map_call_n("<leader>zz", require("no-neck-pain").start, "centralize the buffer")
    end
  }
  use { "norcalli/nvim-colorizer.lua", event = "BufRead",
    config = function()
      vim.opt.termguicolors = true
      require("colorizer").setup()
      vim.cmd [[ ColorizerAttachToBuffer ]]
    end
  }
  use { "lukas-reineke/indent-blankline.nvim",
    event = {"BufReadPost"},
    config = function() require('yen3.plugin_setup').indent_blankline() end
  }

  -- Status line
  use { "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function() require('yen3.status_line').lualine_setup() end
  }


  -- Tree sitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate",
    event = { "BufRead" },
    config = function() require('yen3.treesitter').nvim_treesitter() end
  }
  use { "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufRead" },
    requires = "nvim-treesitter/nvim-treesitter",
  }
  use { "nvim-treesitter/playground", run = ":TSInstall query",
    event = { "BufRead" },
    requires = "nvim-treesitter/nvim-treesitter",
  }
  -- {'nvim-treesitter/nvim-treesitter-refactor'},

  -- Edit
  use { "tpope/vim-rhubarb", event = "BufReadPost"}
  use { "tpope/vim-speeddating", event = "BufReadPost", }
  use { "tpope/vim-surround", event = "BufReadPost", }
  use { "numToStr/Comment.nvim", event = "BufReadPost", config = function () require("Comment").setup() end}
  use { "RRethy/nvim-treesitter-endwise", event= "InsertEnter",
    config = function()
      require('nvim-treesitter.configs').setup { endwise = { enable = true, }, }
    end
  }
  use { "junegunn/vim-easy-align", event = "InsertEnter",
    config = function() require('yen3.plugin_setup').vim_easy_align() end
  }
  use { "windwp/nvim-autopairs", event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup {
        disable_filetype = { "TelescopePrompt", "vim" },
      }
    end
  }
  use { "ntpeters/vim-better-whitespace", event = "BufReadPost",
    config = function() require('yen3.plugin_setup').vim_better_whitespace() end
  }
  use { "anufrievroman/vim-angry-reviewer",
    cmd = { "AngryReviewer" }, keys = { "<leader>ar" },
    config = function() require('yen3.plugin_setup').vim_angry_reviewer() end
  }

  -- File browser
  use { "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim"
    },
    cmd = { "Neotree", "NeoTreeFocusToggle", "NeoTreeRevealToggle" },
    keys = { "<leader>fv", "<leader>fV" },
    config = function() require('yen3.search').neo_tree_nvim() end
  }

  -- Search
  use { "junegunn/fzf.vim", event = "BufReadPost", requires = { { "junegunn/fzf", run = "./install --all" }, } }
  use { "nvim-telescope/telescope.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      "nvim-telescope/telescope-github.nvim",
      { "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sql.nvim" } },
      { "AckslD/nvim-neoclip.lua",
        requires = { {'tami5/sqlite.lua', module = 'sqlite'}, },
      },
      "octarect/telescope-menu.nvim",
      {"aloussase/scout", rtp = "vim"},
    },
    config = function() require('yen3.search').telescope.setup() end,
    -- keys = {
    --   "<c-]>",
    --   "<leader>cc",
    --   "<leader>fG",
    --   "<leader>fJ",
    --   "<leader>fb",
    --   "<leader>fd",
    --   "<leader>ff",
    --   "<leader>fg",
    --   "<leader>fj",
    --   "<leader>fj",
    --   "<leader>fk",
    --   "<leader>fm",
    --   "<leader>fn",
    --   "<leader>fr",
    --   "<leader>fs",
    --   "<leader>ft",
    --   "<leader>fu",
    --   "<leader>fuu",
    --   "<leader>fx",
    --   "<leader>fy",
    --   "<leader>fz",
    --   "<leader>gc",
    -- },
  }

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    requires = {
      { "glepnir/lspsaga.nvim", branch = "main",
        config = function() require('yen3.lsp').lspsaga_setup() end
      },
      { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
      { "nvim-lua/lsp-status.nvim",
        config = function() require('yen3.lsp').lsp_status() end
      },
      {"folke/neodev.nvim"},
      {"MrcJkb/haskell-tools.nvim"},
      {"nvim-lua/plenary.nvim"},
    },
    config = function() require('yen3.lsp').lsp_config_setup() end
  }
  use {
    "williamboman/mason-lspconfig.nvim",
    requires = {
      { "jayp0521/mason-null-ls.nvim" },
      {"williamboman/mason.nvim"},
      { "jose-elias-alvarez/null-ls.nvim", branch = "main" }
    },
    event = "BufReadPre",
    config = function()  require('yen3.mason').mason_setup() end
  }
  -- use { "j-hui/fidget.nvim", ft = "lua", config = function() require("fidget").setup({ }) end}

  -- Autocomplete
  use { "hrsh7th/vim-vsnip",
    requires = {
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-vsnip",
    },
    event = "InsertEnter",
    config = function() require('yen3.cmp').vsnip_setup() end
  }
  use { "hrsh7th/nvim-cmp",
    branch = "main",
    requires = {
      { "hrsh7th/cmp-nvim-lsp", branch = "main" },
      { "andersevenrud/cmp-tmux", branch = "main" },
      { "hrsh7th/cmp-buffer", branch = "main" },
      { "hrsh7th/cmp-path", branch = "main" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", branch = "main" },
      { "hrsh7th/cmp-vsnip" },
      { "camilledejoye/nvim-lsp-selection-range" },
      { "hrsh7th/cmp-cmdline", branch = "main" },
      { "rcarriga/cmp-dap" },
    },
    config = function()
      require('yen3.cmp').nvim_cmp_setup()
    end
  }

  -- Diagnostics
  use { "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    cmd = { 'TroubleToggle' }, keys = { "<leader>dt" },
    config = function() require('yen3.diagnostic').trouble_setup() end,
  }

  -- Git
  use { "tpope/vim-fugitive", config = function() require('yen3.git').fugitive() end }
  use { "lewis6991/gitsigns.nvim", event = "BufReadPre", branch = "main", requires = { "nvim-lua/plenary.nvim" },
    config = function() require('gitsigns').setup() end
  }
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim',
    cmd = { 'DiffviewFileHistory', 'DiffviewOpen' }
  }
  -- Github
  use { "pwntester/octo.nvim", cmd = { 'Octo' },
    config = function() require('yen3.git').octo_setup() end
  }

  -- Test
  -- use {
  --   "nvim-neotest/neotest",
  --   requires = {
  --     "nvim-neotest/neotest-python",
  --     "nvim-neotest/neotest-plenary",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "antoinemadec/FixCursorHold.nvim",
  --     "nvim-neotest/neotest-python",
  --   },
  --   config = function()
  --     require("neotest").setup({
  --       adapters = {
  --          require("neotest-python")({
  --           dap = { justMyCode = false },
  --           runner = "pytest",
  --          }),
  --          require("neotest-plenary"),
  --       }
  --     })
  --   end
  -- }

  -- Tmux
  use { "alexghergh/nvim-tmux-navigation",
    config = function()
        require'nvim-tmux-navigation'.setup {
            disable_when_zoomed = false,
            keybindings = {
                left = "<C-h>",
                down = "<C-j>",
                up = "<C-k>",
                right = "<C-l>",
                last_active = "<C-\\>",
                next = "<C-Space>",
            }
        }
    end
  }
  use { "tmux-plugins/vim-tmux-focus-events", event = "InsertEnter" }

  -- Debug
  use {"mfussenegger/nvim-dap-python",
    requires = {
      "mfussenegger/nvim-dap",
      "theHamsta/nvim-dap-virtual-text",
      { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} },
      "nvim-telescope/telescope-dap.nvim",
      "Weissle/persistent-breakpoints.nvim",
      { 'Joakker/lua-json5', run = './install.sh' },
    },
    keys = { '<leader>qq', '<leader>qQ' },
    config = function() require('yen3.dap').setup() end
  }

  -- Misc
  use { "tweekmonster/startuptime.vim", cmd = "StartupTime" }
  -- use { "dstein64/vim-startuptime", cmd = "StartupTime" }

  -- Bitbake
  use { "kergoth/vim-bitbake", ft = {'bitbake'} }

  -- CSV
  -- use { "chrisbra/csv.vim", ft = "csv" }

  -- Dhall
  use { "vmchale/dhall-vim", ft = "dhall" }

  -- Haskell
  -- use { "alx741/vim-stylishask", ft = "haskell" }
  -- use { "ndmitchell/ghcid", ft = "haskell", rtp = "plugins/nvim" }

  -- JavaScript/TypeScript
  local js_types = { "javascript", "typescript", "typescriptreact" }
  use { "alvan/vim-closetag", ft = js_types }
  use { "pangloss/vim-javascript", ft = js_types }
  use { "mxw/vim-jsx", ft = js_types }
  use { "othree/yajs.vim", ft = js_types }
  use { "HerringtonDarkholme/yats.vim", ft = js_types, run = "rm -rf UltiSnips" }
  use { "turbio/bracey.vim", ft = js_types, run = "npm install --prefix server" }
  use { "prettier/vim-prettier", ft = js_types }

  -- LaTeX
  -- use { "lervag/vimtex", ft = "tex" }
  -- use { "f3fora/nvim-texlabconfig",
  --   config = function() require('texlabconfig').setup({}) end,
  --   ft = { 'tex', 'bib' },
  --   cmd = { 'TexlabInverseSearch' },
  -- }

  -- Log
  use { "mtdl9/vim-log-highlighting", ft = { 'log' } }

  -- Lua
  use { "folke/lua-dev.nvim", ft = "lua" }

  -- Markdown
  use { "plasticboy/vim-markdown", ft = "markdown",
    config = function() require('yen3.plugin_setup').vim_markdown() end
  }
  use { "iamcco/markdown-preview.nvim", ft = "markdown", run = "cd app && yarn install" }
  -- use { "jakewvincent/mkdnflow.nvim",
  --   rocks = "luautf8",
  --   ft = "markdown",
  --   config = function() require('mkdnflow').setup({}) end
  -- }

  -- Purescript
  use { "purescript-contrib/purescript-vim", ft = { "purescript" } }

  -- Yaml
  use { "pearofducks/ansible-vim", ft = {"yaml", "ansible", "yaml.ansible"} }

  -- TOML
  use { "cespare/vim-toml", ft = "toml" }

  -- Racket
  use { "wlangstroth/vim-racket", ft = "racket" }

  -- Rust
  use { "rust-lang/rust.vim", ft = "rust" }
  use { "Chiel92/vim-autoformat", ft = "rust" }
end

M.packer = function()
  _packer_keymap()

  _packer_check_install()
  vim.cmd([[ packadd packer.nvim ]])
  require("packer").startup(packer_plugins)
end


return M
