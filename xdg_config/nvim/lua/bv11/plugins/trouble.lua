return {
  -- Diagnostics
  {
    "folke/trouble.nvim",
    branch = "main",
    event = "VeryLazy",
    dependencies = "kyazdani42/nvim-web-devicons",
    ---@type trouble.Config
    opts = {
      auto_preview = false,
      modes = {
        symbols = {
          win = {
            position = "left",
            width = 60,
          },
        }
      }
    },
    keys = {
      { "<leader>dt", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>"},
      { "<leader>dT", "<cmd>Trouble diagnostics toggle<cr>" },
      { "<leader>dl", "<cmd>Trouble lsp_references toggle auto_jump=false<cr>" },
    },
  },
}
