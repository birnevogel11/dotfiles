local keymap_n = require('yen3.lib.keymap').keymap_n
-- local neotest = require("neotest")

local neotest_setup = function()
  require("neotest").setup({
    adapters = {
      require("neotest-haskell"),
      require("neotest-python")({
        dap = { justMyCode = false },
        runner = "pytest",
        args = {"--log-level", "DEBUG", "-svv"},
      }),
    }
  })
end

local neotest_keymap = function()
  local neotest = require("neotest")

  keymap_n("<leader>rr", function() neotest.run.run() end, "Neotest: run nearest")
  keymap_n("<leader>rf", function() neotest.run.run(vim.fn.expand("%")) end, "Neotest: run the file")
  keymap_n("<leader>rs", neotest.summary.toggle, "Neotest: show Test summary")
  keymap_n("<leader>ro", neotest.output_panel.toggle, "Neotest: show output pannel")
  keymap_n("<leader>rt", function() neotest.output.open({ enter = true }) end, "Neotest: show float output window")
  keymap_n("<leader>rd", function() neotest.run.run({strategy = "dap"}) end, "Neotest: debug the test case")
end

local test_setup = function()
  neotest_setup()
  neotest_keymap()
end

return {
  -- Test
  { "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-neotest/neotest-python" },
      { "MrcJkb/neotest-haskell" },
      { "antoinemadec/FixCursorHold.nvim" },
    },
    keys = { "<leader>rr", "<leader>rt", "<leader>rf", "<leader>rs", "<leader>ro", "<leader>rd", "<leader>et" },
    config = function()
      test_setup()
    end
  },
}
