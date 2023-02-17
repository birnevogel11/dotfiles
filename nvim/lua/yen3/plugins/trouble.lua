return {
  -- Diagnostics
  { "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    cmd = { "TroubleToggle" },
    keys = { "<leader>dt" },
    config = function()
      require("trouble").setup({})
      require("yen3.lib.keymap").keymap_n("<leader>dt", "<cmd>TroubleToggle document_diagnostics<cr>")

    end,
  },
}
