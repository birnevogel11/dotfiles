return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- { "igorlfs/nvim-dap-view" },  -- TODO: test until it's mature
      { "LiadOz/nvim-dap-repl-highlights" },
      { "mfussenegger/nvim-dap-python" },
      { "nvim-neotest/nvim-nio" },
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      -- { "Weissle/persistent-breakpoints.nvim" },
      -- { "rcarriga/cmp-dap" },  -- WIP: adapt it for blink-cmp
    },
    event = "VeryLazy",
    config = require("bv11.plugins.dap.lib").dap_setup,
  }
}
