return {
  -- Diagnostics
  {
    "folke/trouble.nvim",
    branch = "main",
    -- event = "VeryLazy",
    dependencies = "kyazdani42/nvim-web-devicons",
    cmd = { "Trouble" },
    opts = {},
    keys = {
      { "<leader>dt", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", silent = true },
      { "<leader>dT", "<cmd>Trouble diagnostics toggle<cr>", silent = true },
    },
  },
}
