return {
  -- Edit
  { "tpope/vim-rhubarb", event = "VeryLazy" },
  { "tpope/vim-speeddating", event = "VeryLazy" },
  { "tpope/vim-surround", event = "VeryLazy" },
  -- { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },
  { "RRethy/nvim-treesitter-endwise", event = "InsertEnter", },

  {
    "cappyzawa/trim.nvim",
    event = "InsertEnter",
    config = function()
      require("trim").setup({
        ft_blocklist = { "TelescopePrompt", "Trouble", "help", "bitbake" },
        trim_on_write = true,
        trim_trailing = true,
        trim_last_line = true,
        trim_first_line = false,
        -- patterns = {[[%s/\(\n\n\)\n\+/\1/]]}, -- Only one consecutive bl
      })

      -- Set traiing space highlight
      vim.cmd([[ match DiffDelete /\s\+$/ ]])
    end,
  },

  {
    "junegunn/vim-easy-align",
    event = "VeryLazy",
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      vim.cmd([[ xmap ga <Plug>(EasyAlign)]])

      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.cmd([[ nmap ga <Plug>(EasyAlign)]])
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "InsertEnter",
    opts = {
      snippet_engine = "luasnip",
      languages = {
        python = {
          template = {
            annotation_convention = "reST",
          },
        },
      },
    },
    keys = {
      {"<leader>wd", function() require("neogen").generate() end, desc = "Generate annotation comment"}
    }
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    opts = {
      -- mapping = { "jk", "jj" },
      timeout = 300,
    },
  },
  {
    "mbbill/undotree",
    event = "BufReadPre",
    keys = {
      { "<leader>fu", vim.cmd.UndotreeToggle, desc = "Undo Tree", silent = true },
    },
  },
  {
    "godlygeek/tabular",
    event = "InsertEnter",
  },

  -- {
  --   "barrett-ruth/live-server.nvim",
  --   build = "pnpm add -g live-server",
  --   cmd = { "LiveServerStart", "LiveServerStop" },
  --   opts = {
  --     args = { "--port=10089", "--browser=firefox" },
  --   }
  --   keys = {
  --     { "<leaderdl>",  ":LiveServerStart<cr>", desc = "Start the live server"} }
  --   }
  --   event = "VeryLazy",
  -- },

  {
    "MagicDuck/grug-far.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>wo", "<cmd>GrugFar<cr>", desc = "Replace string in multiple files" }
    },
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    config = function()
      require("refactoring").setup({})

      vim.keymap.set({ "n", "x" }, "<leader>re", function() return require('refactoring').refactor('Extract Function') end, { expr = true, desc = "Extract Function" })
      vim.keymap.set({ "n", "x" }, "<leader>rf", function() return require('refactoring').refactor('Extract Function To File') end, { expr = true, desc = "Extract Function To File"})
      vim.keymap.set({ "n", "x" }, "<leader>rv", function() return require('refactoring').refactor('Extract Variable') end, { expr = true, desc = "Extract Variable" })
      vim.keymap.set({ "n", "x" }, "<leader>rI", function() return require('refactoring').refactor('Inline Function') end, { expr = true, desc = "Inline Function" })
      vim.keymap.set({ "n", "x" }, "<leader>ri", function() return require('refactoring').refactor('Inline Variable') end, { expr = true, desc = "Inline Variable" })

      -- vim.keymap.set({ "n", "x" }, "<leader>rbb", function() return require('refactoring').refactor('Extract Block') end, { expr = true })
      -- vim.keymap.set({ "n", "x" }, "<leader>rbf", function() return require('refactoring').refactor('Extract Block To File') end, { expr = true })

    end,
  },
}
