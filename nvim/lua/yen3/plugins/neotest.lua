local neotest_setup = function()
  require("neotest").setup({
    adapters = {
      require("neotest-haskell"),
      require("neotest-python")({
        dap = { justMyCode = false },
        runner = "pytest",
        args = { "--log-level", "DEBUG", "-svv" },
      }),
      require("neotest-rust")({
        dap = { justMyCode = false },
      }),
    },
  })
end

local neotest_keymap = function()
  local neotest = require("neotest")
  local keymap_n = require("yen3.lib.keymap").keymap_n

  keymap_n("<leader>rr", neotest.run.run, "Neotest: run nearest")
  keymap_n("<leader>rf", function()
    neotest.run.run(vim.fn.expand("%"))
  end, "Neotest: run the file")
  keymap_n("<leader>rs", neotest.summary.toggle, "Neotest: show Test summary")
  keymap_n("<leader>ro", neotest.output_panel.toggle, "Neotest: show output pannel")
  keymap_n("<leader>rt", function()
    neotest.output.open({ enter = true })
  end, "Neotest: show float output window")
  -- <leader>rd - debug for the test case. defined in lua/yen3/plugins/dap/base.lua
end

local test_setup = function()
  neotest_setup()
  neotest_keymap()
end

return {
  -- Test
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-neotest/neotest-python" },
      { "MrcJkb/neotest-haskell" },
      { "rouge8/neotest-rust" },
      { "antoinemadec/FixCursorHold.nvim" },
    },
    -- keys = {
    --   "<leader>rr",
    --   "<leader>rt",
    --   "<leader>rf",
    --   "<leader>rs",
    --   "<leader>ro",
    --   "<leader>rd",
    --   "<leader>et",
    -- },
    event = "VeryLazy",
    config = function()
      test_setup()
    end,
  },
}
