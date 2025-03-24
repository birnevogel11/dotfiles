return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- { "igorlfs/nvim-dap-view" },  -- WIP: wait until it's mature.
      { "LiadOz/nvim-dap-repl-highlights" },
      { "Weissle/persistent-breakpoints.nvim" },
      { "mfussenegger/nvim-dap-python" },
      { "nvim-neotest/nvim-nio" },
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      -- { "rcarriga/cmp-dap" },  -- WIP: adapt it for blink-cmp
    },
    event = "VeryLazy",
    config = require("bv11.plugins.dap.lib").dap_setup,
  }
}
