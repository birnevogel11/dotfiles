return {
  -- Edit
  { "tpope/vim-rhubarb", event = "VeryLazy" },
  { "tpope/vim-speeddating", event = "VeryLazy" },
  { "tpope/vim-surround", event = "VeryLazy" },
  { "numToStr/Comment.nvim", event = "VeryLazy", config = function() require("Comment").setup() end, },
  { "RRethy/nvim-treesitter-endwise", event = "VeryLazy",
    config = function() require("nvim-treesitter.configs").setup({ endwise = { enable = true } }) end,
  },
  { "junegunn/vim-easy-align", event = "VeryLazy",
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      vim.cmd([[ xmap ga <Plug>(EasyAlign)]])

      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.cmd([[ nmap ga <Plug>(EasyAlign)]])
    end,
  },
  { "windwp/nvim-autopairs", event = "VeryLazy",
    config = function() require("nvim-autopairs").setup({ disable_filetype = { "TelescopePrompt", "vim" }, }) end,
  },
  {
    "luukvbaal/statuscol.nvim",
    config = function() require("statuscol").setup() end,
    event = "VeryLazy",
  },
}
