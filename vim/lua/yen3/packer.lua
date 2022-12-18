local M = {}

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  vim.cmd([[packadd packer.nvim]])
end

local packer_keymap = function()
  local keymap_n = require("yen3.lib.keymap").keymap_n
  keymap_n("<leader>pc", function()
    vim.fn.execute(":PackerCompile")
    require("yen3.lib.notify").notify("Packer", "Generate packer_compiled.lua")
  end, "Packer compile")
  keymap_n("<leader>ps", ":PackerSync<cr>")
end

local packer_plugins = function(use)
  use("wbthomason/packer.nvim")

  use("lewis6991/impatient.nvim")

  -- Color scheme
  use("tjdevries/colorbuddy.nvim")

  -- Generic
  use({ "aymericbeaumet/vim-symlink", event = "BufRead" })
  use({ "ethanholz/nvim-lastplace",
    event = "BufReadPre",
    config = function()
      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
        lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
        lastplace_open_folds = true
      }
    end
  })
  use({
    "klen/nvim-config-local",
    config = function()
      require("config-local").setup({
        config_files = { ".vimrc.lua", ".vimrc", ".lvimrc", ".lvimrc.lua" },
        silent = true,
      })
    end,
  })
  -- TODO: try it
  -- use { "miversen33/netman.nvim", branch = "v1.1" }

  -- Apperence
  use({
    "alvarosevilla95/luatab.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function() require("yen3.plugin_setup").luatab_nvim() end,
  })
  use({
    "majutsushi/tagbar",
    opt = true,
    cmd = { "TagbarOpen" },
    keys = { "<leader>tb" },
    config = function() require("yen3.plugin_setup").tagbar() end,
  })
  use({
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#272b33",
        stages = "fade",
        timeout = 1000,
      })
    end,
  })
  use({
    "shortcuts/no-neck-pain.nvim",
    keys = { "<leader>zz" },
    config = function()
      require("no-neck-pain").setup({ width = 120 })
      require("yen3.lib.keymap").map_call_n("<leader>zz", require("no-neck-pain").start, "centralize the buffer")
    end,
  })
  use({
    "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require("colorizer").setup()
      vim.cmd [[ ColorizerAttachToBuffer ]]
    end,
  })
  use({
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost" },
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
        show_first_indent_level = false,
        show_current_context = false,
        show_current_context_start = false,
        show_current_context_start_on_current_line = false,
        context_highlight_list = false,
      })
      end,
  })
  use {'stevearc/dressing.nvim',
    event = { "InsertEnter" },
    config = function() require('dressing').setup() end
  }

  -- Status line
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function() require("yen3.status_line").lualine_setup() end,
  })

  -- Tree sitter
  use({ "nvim-treesitter/nvim-treesitter",
    -- event = { "BufRead" },
    config = function() require("yen3.treesitter").nvim_treesitter() end,
    run = function() pcall(require("nvim-treesitter.install").update({ with_sync = true })) end,
  })
  use({ "nvim-treesitter/nvim-treesitter-textobjects", event = { "BufRead" },
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })
  use({ "nvim-treesitter/playground", run = ":TSInstall query", event = { "BufRead" },
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- Test
  use { "nvim-neotest/neotest",
    requires = {
      "nvim-neotest/neotest-python",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
    after = { "nvim-treesitter" },
    key = { "<leader>rt", "<leader>rtt", "<leader>rs", "<leader>ro" },
    config = function() require('yen3.neotest').setup() end
  }

  -- Edit
  use({ "tpope/vim-rhubarb", event = "BufReadPost" })
  use({ "tpope/vim-speeddating", event = "BufReadPost" })
  use({ "tpope/vim-surround", event = "BufReadPost" })
  use({ "numToStr/Comment.nvim", event = "BufReadPost", config = function() require("Comment").setup() end, })
  use({ "RRethy/nvim-treesitter-endwise", event = "InsertEnter",
    config = function() require("nvim-treesitter.configs").setup({ endwise = { enable = true } }) end,
  })
  use({ "junegunn/vim-easy-align", event = "InsertEnter",
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      vim.cmd([[ xmap ga <Plug>(EasyAlign)]])

      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.cmd([[ nmap ga <Plug>(EasyAlign)]])
    end,
  })
  use({ "windwp/nvim-autopairs", event = "InsertEnter",
    config = function() require("nvim-autopairs").setup({ disable_filetype = { "TelescopePrompt", "vim" }, }) end,
  })

  -- File browser
  use { "MunifTanjim/nui.nvim",
    keys = { "<leader>fv", "<leader>fV" },
  }
  use { "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    after = { "nui.nvim" },
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
    },
    cmd = { "Neotree", "NeoTreeFocusToggle", "NeoTreeRevealToggle" },
    keys = { "<leader>fv", "<leader>fV" },
    config = function() require("yen3.search").neo_tree_nvim() end,
  }

  -- Search
  use { "junegunn/fzf", run = "./install --all", event = "BufReadPost" }
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      -- "nvim-telescope/telescope-github.nvim",
      { "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sql.nvim" } },
      -- { "AckslD/nvim-neoclip.lua", requires = { { "tami5/sqlite.lua", module = "sqlite" } } },
      "octarect/telescope-menu.nvim",
      { "aloussase/scout", rtp = "vim", ft = "haskell" },
    },
    config = function() require("yen3.search").telescope.setup() end,
  }

  -- LSP
  use({
    "neovim/nvim-lspconfig",
    requires = {
      { "nvim-lua/lsp-status.nvim", config = function() require("yen3.lsp").lsp_status() end, },
      { "folke/neodev.nvim" },
      { "MrcJkb/haskell-tools.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function() require("yen3.lsp").lsp_config_setup() end,
  })
  use { "jose-elias-alvarez/null-ls.nvim", branch = "main", event = "BufReadPre", }
  use { "jayp0521/mason-null-ls.nvim", event = "BufReadPre", after = "null-ls.nvim" }
  use { "williamboman/mason.nvim", event = "BufReadPre", after = "null-ls.nvim" }
  use({
    "williamboman/mason-lspconfig.nvim",
    after = { "null-ls.nvim", "mason-null-ls.nvim", "mason.nvim" },
    event = "BufReadPre",
    config = function() require("yen3.mason").mason_setup() end,
  })
  -- use {"j-hui/fidget.nvim", ft = "lua", config = function() require("fidget").setup({}) end}

  -- Autocomplete
  use({
    "hrsh7th/nvim-cmp",
    branch = "main",
    requires = {
      { "hrsh7th/cmp-nvim-lsp", branch = "main" },
      { "andersevenrud/cmp-tmux", branch = "main" },
      { "hrsh7th/cmp-buffer", branch = "main" },
      { "hrsh7th/cmp-path", branch = "main" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", branch = "main" },
      { "hrsh7th/cmp-cmdline", branch = "main" },
    },
    config = function() require("yen3.cmp").nvim_cmp_setup() end,
  })
  use({
    "saadparwaiz1/cmp_luasnip",
    requires = "L3MON4D3/LuaSnip",
    after = { "nvim-cmp" },
    event = { "InsertEnter" },
    config = function() require("yen3.snip.luasnip").luasnip_setup() end,
  })

  -- Diagnostics
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    cmd = { "TroubleToggle" },
    keys = { "<leader>dt" },
    config = function() require("yen3.diagnostic").trouble_setup() end,
  })

  -- Git
  use({ "tpope/vim-fugitive", config = function() require("yen3.git").fugitive_setup() end, })
  use({ "lewis6991/gitsigns.nvim", event = "BufReadPre", branch = "main",
    requires = { "nvim-lua/plenary.nvim" },
    config = function() require("gitsigns").setup() end,
  })
  use({
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewFileHistory", "DiffviewOpen" },
  })

  -- Github
  use({ "pwntester/octo.nvim",
    cmd = { "Octo" },
    keys = { "<leader>go", "<leader>gk", "<leader>goo" },
    config = function() require("yen3.github").octo_setup() end,
  })

  -- Tmux
  use({
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = false,
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        },
      })
    end,
  })
  use({ "tmux-plugins/vim-tmux-focus-events", event = "InsertEnter" })

  -- Debug
  use({
    "mfussenegger/nvim-dap",
    requires = {
      { "mfussenegger/nvim-dap-python", after = "nvim-dap" },
      {"theHamsta/nvim-dap-virtual-text", after = "nvim-dap" },
      { "rcarriga/nvim-dap-ui", after = "nvim-dap" },
      {"nvim-telescope/telescope-dap.nvim", after = "nvim-dap"},
      {"Weissle/persistent-breakpoints.nvim", after = "nvim-dap"},
      { "Joakker/lua-json5", run = "./install.sh", after = "nvim-dap" },
      { "rcarriga/cmp-dap", after = "nvim-dap" },
    },
    keys = { "<leader>ee" },
    config = function() require("yen3.dap").setup() end,
  })

  -- Misc
  use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })
  -- use { "dstein64/vim-startuptime", cmd = "StartupTime" }

  -- Bitbake
  use({ "kergoth/vim-bitbake", ft = { "bitbake" } })

  -- CSV
  -- use { "chrisbra/csv.vim", ft = "csv" }

  -- Dhall
  use({ "vmchale/dhall-vim", ft = "dhall" })

  -- Haskell
  -- use { "alx741/vim-stylishask", ft = "haskell" }
  -- use { "ndmitchell/ghcid", ft = "haskell", rtp = "plugins/nvim" }

  -- JavaScript/TypeScript
  local js_types = { "javascript", "typescript", "typescriptreact" }
  use({ "alvan/vim-closetag", ft = js_types })
  use({ "pangloss/vim-javascript", ft = js_types })
  use({ "mxw/vim-jsx", ft = js_types })
  use({ "othree/yajs.vim", ft = js_types })
  use({ "HerringtonDarkholme/yats.vim", ft = js_types, run = "rm -rf UltiSnips" })
  use({ "turbio/bracey.vim", ft = js_types, run = "npm install --prefix server" })
  use({ "prettier/vim-prettier", ft = js_types })

  -- Log
  use({ "mtdl9/vim-log-highlighting", ft = { "log" } })

  -- Lua
  use({ "folke/lua-dev.nvim", ft = "lua" })

  -- Markdown
  use({ "iamcco/markdown-preview.nvim", ft = "markdown", run = "cd app && yarn install" })
  -- use { "jakewvincent/mkdnflow.nvim",
  --   rocks = "luautf8",
  --   ft = "markdown",
  --   config = function() require('mkdnflow').setup({}) end
  -- }

  -- Purescript
  use({ "purescript-contrib/purescript-vim", ft = { "purescript" } })

  -- Yaml
  use({ "pearofducks/ansible-vim", ft = { "yaml", "ansible", "yaml.ansible" } })

  -- TOML
  use({ "cespare/vim-toml", ft = "toml" })

  -- Racket
  use({ "wlangstroth/vim-racket", ft = "racket" })

  -- Rust
  use({ "rust-lang/rust.vim", ft = "rust" })
  use({ "Chiel92/vim-autoformat", ft = "rust" })
end

local check_bootstrap = function()
  if is_bootstrap then
    require("packer").sync()
  end

  if is_bootstrap then
    print("==================================")
    print("    Plugins are being installed")
    print("    Wait until Packer completes,")
    print("       then restart nvim")
    print("==================================")
    return
  end
end

local auto_packer_compile_when_changed = function()
  local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    command = "source <afile> | PackerCompile",
    group = packer_group,
    pattern = vim.fn.expand("$MYVIMRC"),
  })
end

M.packer = function()
  packer_keymap()
  require("packer").startup(packer_plugins)
  check_bootstrap()
  auto_packer_compile_when_changed()
end

return M
