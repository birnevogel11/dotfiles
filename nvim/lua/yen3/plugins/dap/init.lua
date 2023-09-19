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
  },
  -- keys = { "<leader>ee", "<leader>et" },
  event = "VeryLazy",
  config = function()
    require("yen3.plugins.dap.base").dap_setup()
  end,
}

if os.getenv("NVIM_DAP_DEBUG_ENABLE") ~= nil then
  pkg_config.event = nil
end

return { pkg_config }
