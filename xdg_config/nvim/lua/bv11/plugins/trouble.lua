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
      { "<leader>dt", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: toggle buffer"},
      { "<leader>dT", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: toggle workspace" },
      { "<leader>dr", "<cmd>Trouble lsp_references toggle auto_jump=false<cr>", desc = "LSP: Reference" },
    },
  },

}
