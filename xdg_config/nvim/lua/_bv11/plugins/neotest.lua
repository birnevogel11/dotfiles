return {

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-neotest/neotest-python" },
      { "rouge8/neotest-rust" },
      { "antoinemadec/FixCursorHold.nvim" },
      { "nvim-neotest/nvim-nio" },
    },
    event = "VeryLazy",
    keys = {
      {"<leader>tt", function() require("neotest").run.run() end, desc = "Neotest: run nearest"},
      {"<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest: run the file"},
      {"<leader>ts", function() require("neotest").summary.toggle() end, desc = "Neotest: show Test summary"},
      {"<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Neotest: show output pannel"},
      {"<leader>tw", function() require("neotest").output.open({ enter = true }) end, desc = "Neotest: show float output window"},
    },
    config = function()
      ---@diagnostic disable: missing-fields
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
            args = { "--log-level", "DEBUG", "-svv", "-p no:flaky" },
          }),
          require("rustaceanvim.neotest")({
            dap = { justMyCode = false },
          }),
        },
      })
    end,
  },

}
