local pkg_config = {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "mfussenegger/nvim-dap-python" },
    { "theHamsta/nvim-dap-virtual-text" },
    { "rcarriga/nvim-dap-ui" },
    { "Weissle/persistent-breakpoints.nvim" },
    { "nvim-telescope/telescope-dap.nvim" },
    { "rcarriga/cmp-dap" },
    { "LiadOz/nvim-dap-repl-highlights" },
    -- { "igorlfs/nvim-dap-view" },  -- WIP: wait until it's mature.
  },
  -- keys = { "<leader>ee", "<leader>et" },
  event = "VeryLazy",
  config = require("bv11.plugins.dap.base").dap_setup,
}

if os.getenv("NVIM_DAP_DEBUG_ENABLE") ~= nil then
  pkg_config.event = nil
end

return { pkg_config }
