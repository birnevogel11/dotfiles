local M = {}

local plugins = {
  "nvim-lua/plenary.nvim",

  -- Generic
  { "aymericbeaumet/vim-symlink", event = "BufRead" },
  { "ethanholz/nvim-lastplace",
    event = "BufReadPre",
    config = function()
      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
        lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
        lastplace_open_folds = true
      }
    end
  },
  { "klen/nvim-config-local",
    config = function()
      require("config-local").setup({
        config_files = { ".vimrc.lua", ".vimrc", ".lvimrc", ".lvimrc.lua" },
        silent = true,
      })
    end,
  },
  -- TODO: try it
  -- { "miversen33/netman.nvim", branch = "v1.1" }

  -- Apperence
  { "alvarosevilla95/luatab.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = function() require("yen3.plugin_setup").luatab_nvim() end,
  },
  { "majutsushi/tagbar",
    cmd = { "TagbarOpen" },
    keys = { "<leader>tb" },
    config = function() require("yen3.plugin_setup").tagbar() end,
  },
  { "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#272b33",
        stages = "fade",
        timeout = 1000,
      })
    end,
  },
  { "shortcuts/no-neck-pain.nvim",
    keys = { "<leader>zz" },
    config = function()
      require("no-neck-pain").setup({ width = 120 })
      require("yen3.lib.keymap").keymap_n("<leader>zz", "<cmd>NoNeckPain<cr>", "centralize the buffer")
    end,
  },
  { "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require("colorizer").setup()
      require("colorizer").attach_to_buffer(0)
    end,
  },
  { "lukas-reineke/indent-blankline.nvim",
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
  },
  { 'stevearc/dressing.nvim',
    event = { "InsertEnter" },
    config = function() require('dressing').setup() end
  },
  -- {
  --   "luukvbaal/statuscol.nvim",
  --   config = function()
  --     vim.o.mouse = "nvi"
  --     require("statuscol").setup()
  --   end
  -- },

  -- Status line
  { "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function() require("yen3.status_line").lualine_setup() end,
  },

  -- Tree sitter
  { "nvim-treesitter/nvim-treesitter",
    config = function() require("yen3.treesitter").nvim_treesitter() end,
    build = function() pcall(require("nvim-treesitter.install").update({ with_sync = true })) end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = { "BufReadPost" } },
  { "nvim-treesitter/playground", build = ":TSInstall query", event = { "BufReadPost" }, },

  -- Test
  { "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-neotest/neotest-python" },
      { "MrcJkb/neotest-haskell" },
      { "antoinemadec/FixCursorHold.nvim" },
    },
    keys = { "<leader>rr", "<leader>rt", "<leader>rf", "<leader>rs", "<leader>ro", "<leader>rd", "<leader>et" },
    config = function()
      require('yen3.neotest').setup()
    end
  },

  -- Edit
  { "tpope/vim-rhubarb", event = "BufReadPost" },
  { "tpope/vim-speeddating", event = "BufReadPost" },
  { "tpope/vim-surround", event = "BufReadPost" },
  { "numToStr/Comment.nvim", event = "BufReadPost", config = function() require("Comment").setup() end, },
  { "RRethy/nvim-treesitter-endwise", event = "InsertEnter",
    config = function() require("nvim-treesitter.configs").setup({ endwise = { enable = true } }) end,
  },
  { "junegunn/vim-easy-align", event = "InsertEnter",
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      vim.cmd([[ xmap ga <Plug>(EasyAlign)]])

      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.cmd([[ nmap ga <Plug>(EasyAlign)]])
    end,
  },
  { "windwp/nvim-autopairs", event = "InsertEnter",
    config = function() require("nvim-autopairs").setup({ disable_filetype = { "TelescopePrompt", "vim" }, }) end,
  },
  { 'ojroques/nvim-osc52', event = "BufReadPost",
    config = function()
      vim.keymap.set('n', '<leader>yy', require('osc52').copy_operator, {expr = true})
      vim.keymap.set('n', '<leader>yc', '<leader>yy_', {remap = true})
      vim.keymap.set('x', '<leader>yy', require('osc52').copy_visual)
    end
  },

  -- File browser
  { "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    after = { "nui.nvim" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Neotree", "NeoTreeFocusToggle", "NeoTreeRevealToggle" },
    keys = { "<leader>fv", "<leader>fV" },
    config = function() require("yen3.search").neo_tree_nvim() end,
  },

  -- Search
  -- { "junegunn/fzf", build = "./install --all", event = "BufReadPost" }
  { "nvim-telescope/telescope.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      { "nvim-lua/popup.nvim" },
      { "nvim-telescope/telescope-fzy-native.nvim" },
      { "nvim-telescope/telescope-frecency.nvim", dependencies = { "tami5/sql.nvim" } },
      { "octarect/telescope-menu.nvim" },
      -- "nvim-telescope/telescope-github.nvim",
      -- { "AckslD/nvim-neoclip.lua", dependencies = { { "tami5/sqlite.lua", module = "sqlite" } } },
      { "psiska/telescope-hoogle.nvim", ft = "haskell" },
    },
    config = function()
      require("yen3.search").telescope.setup()
    end,
    keys = {
      "<leader>fG",
      "<leader>fd",
      "<leader>fdd",
      "<leader>ff",
      "<leader>fg",
      "<leader>fm",
      "<leader>fn",
      "<leader>fs",
      "<leader>fu",
      "<leader>fx",
      "<leader>fx",
    }
  },

  { "folke/neodev.nvim", config = function () require("neodev").setup {} end, ft = { "lua" }},

  -- LSP
  { "neovim/nvim-lspconfig",
    event = "BufRead",
    dependencies = {
      { "nvim-lua/lsp-status.nvim" },
      { "MrcJkb/haskell-tools.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("yen3.lsp").lsp_config_setup()
      require("yen3.lsp").lsp_status()
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim", branch = "main",
    event = "BufReadPost",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "jayp0521/mason-null-ls.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      require("yen3.mason").mason_setup()
    end
  },
  { "j-hui/fidget.nvim", ft = {"lua", "go", "rust"},
    config = function()
      require("fidget").setup({
        text = {
          spinner = "moon",
        },
        align = {
          bottom = true,
        },
        window = {
          relative = "editor",
        },
      })
    end
  },

  -- Autocomplete
  { "hrsh7th/nvim-cmp",
    branch = "main",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", branch = "main" },
      { "andersevenrud/cmp-tmux", branch = "main" },
      { "hrsh7th/cmp-buffer", branch = "main" },
      { "hrsh7th/cmp-path", branch = "main" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", branch = "main"},
      { "hrsh7th/cmp-cmdline", branch = "main" },
      { "hrsh7th/cmp-omni", branch = "main", ft = "tex"},
    },
    config = function() require("yen3.cmp").nvim_cmp_setup() end,
  },
  { "saadparwaiz1/cmp_luasnip",
    dependencies = "L3MON4D3/LuaSnip",
    after = { "nvim-cmp" },
    event = { "InsertEnter" },
    config = function() require("yen3.snip.luasnip").luasnip_setup() end,
  },

  -- Diagnostics
  { "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    cmd = { "TroubleToggle" },
    keys = { "<leader>dt" },
    config = function() require("yen3.diagnostic").trouble_setup() end,
  },

  -- Git
  { "tpope/vim-fugitive", config = function() require("yen3.git").fugitive_setup() end, },
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", branch = "main",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("gitsigns").setup() end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewFileHistory", "DiffviewOpen" },
  },

  -- Github
  { "pwntester/octo.nvim",
    cmd = { "Octo" },
    keys = { "<leader>go", "<leader>gk", "<leader>goo" },
    config = function() require("yen3.github").octo_setup() end,
  },

  -- Tmux
  { "alexghergh/nvim-tmux-navigation",
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
  },
  { "tmux-plugins/vim-tmux-focus-events", event = "InsertEnter" },

  -- Debug
  { "mfussenegger/nvim-dap",
    dependencies = {
      { "mfussenegger/nvim-dap-python" },
      { "theHamsta/nvim-dap-virtual-text" },
      { "rcarriga/nvim-dap-ui",
        commit = "b80227ea56a48177786904f6322abc8b2dc0bc36",
      },
      { "Weissle/persistent-breakpoints.nvim" },
      { "nvim-telescope/telescope-dap.nvim" },
      { "rcarriga/cmp-dap" },
      -- { "Joakker/lua-json5", build = "./install.sh", },
    },
    keys = { "<leader>ee", "<leader>et" },
    config = function()
      require("yen3.dap").setup()
      require("yen3.dap").repl_auto_complete_setup()
    end,
  },

  -- Misc
  { "dstein64/vim-startuptime", cmd = "StartupTime" },

  -- Bitbake
  { "kergoth/vim-bitbake", ft = { "bitbake" } },

  -- CSV
  -- { "chrisbra/csv.vim", ft = "csv" },

  -- Dhall
  -- { "vmchale/dhall-vim", ft = "dhall" },

  -- Haskell
  -- { "alx741/vim-stylishask", ft = "haskell" },
  -- { "ndmitchell/ghcid", ft = "haskell", rtp = "plugins/nvim" },

  -- JavaScript/TypeScript
  -- local js_types = { "javascript", "typescript", "typescriptreact" }
  -- { "alvan/vim-closetag", ft = js_types },
  -- { "pangloss/vim-javascript", ft = js_types },
  -- { "mxw/vim-jsx", ft = js_types },
  -- { "othree/yajs.vim", ft = js_types },
  -- { "HerringtonDarkholme/yats.vim", ft = js_types, build = "rm -rf UltiSnips" },
  -- { "turbio/bracey.vim", ft = js_types, build = "npm install --prefix server" },
  -- { "prettier/vim-prettier", ft = js_types },

  -- Log
  { "mtdl9/vim-log-highlighting", ft = { "log" } },

  -- Lua
  { "folke/lua-dev.nvim", ft = "lua" },

  -- Markdown
  { "iamcco/markdown-preview.nvim", ft = "markdown", build = "cd app && yarn install" },

  -- Purescript
  { "purescript-contrib/purescript-vim", ft = { "purescript" } },

  -- Yaml
  { "pearofducks/ansible-vim", ft = { "yaml", "ansible", "yaml.ansible" } },

  -- TeX
  { "lervag/vimtex", ft = "tex", config = function() require('yen3.plugin_setup').vimtex() end},

  -- TOML
  { "cespare/vim-toml", ft = "toml" },

  -- Go
  { "ray-x/go.nvim", ft = "go", config = function()
      require('go').setup()

      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
         require('go.format').goimport()
        end,
        group = format_sync_grp,
      })
    end
  },

  -- Racket
  -- { "wlangstroth/vim-racket", ft = "racket" },

  -- Rust
  -- { "rust-lang/rust.vim", ft = "rust" },

  -- PlantUML
  -- { "aklt/plantuml-syntax", ft = "plantuml",
  --   config = function() vim.api.nvim_set_var("plantuml_set_makeprg", 0) end
  -- },
  -- { "skanehira/preview-uml.vim", cmd = { "PreviewUML" },
  --   config = function() vim.api.nvim_set_var("preview_uml_url", "http://localhost:8080") end
  -- },
}

local lazy_config = {
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "matchparen",
        "tar",
        "tarPlugin",
        "rrhelper",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
}

M.setup = function()
  require("lazy").setup(plugins, lazy_config)
  require("yen3.lib.keymap").keymap_n("<leader>pp", "<cmd>Lazy<cr>", "Lazy")
end

return M
