return {
  -- Diagnostics
  {
    "folke/trouble.nvim",
    -- event = "VeryLazy",
    dependencies = "kyazdani42/nvim-web-devicons",
    cmd = { "TroubleToggle" },
    opts = {},
    keys = {
      { "<leader>dt", "<cmd>TroubleToggle document_diagnostics<cr>", silent = true },
    },
  },
}
