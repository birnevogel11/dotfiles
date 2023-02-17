return {
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
}
