return {
  -- Debug
  { "mfussenegger/nvim-dap",
    dependencies = {
      { "mfussenegger/nvim-dap-python" },
      { "theHamsta/nvim-dap-virtual-text" },
      { "rcarriga/nvim-dap-ui" },
      { "Weissle/persistent-breakpoints.nvim" },
      { "nvim-telescope/telescope-dap.nvim" },
      { "rcarriga/cmp-dap" },
      -- { "Joakker/lua-json5", build = "./install.sh", },
    },
    -- keys = { "<leader>ee", "<leader>et" },
    event = "VeryLazy",
    config = function()
      require("yen3.plugins.dap.base").dap_setup()
      require("yen3.plugins.dap.base").repl_auto_complete_setup()
    end,
  },
}
