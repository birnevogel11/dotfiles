local keymap_n = require('yen3.lib.keymap').keymap_n
local neotest = require("neotest")

local M = {}

-- local load_required_pacakges = function()
--   require("lazy").load('nvim-treesitter')
--   require("lazy").load('FixCursorHold.nvim')
--   require("lazy").load('neotest-python')
--   require("lazy").load('neotest-haskell')
-- end

local neotest_setup = function()
  neotest.setup({
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
  keymap_n("<leader>rr", function() neotest.run.run() end, "Neotest: run nearest")
  keymap_n("<leader>rf", function() neotest.run.run(vim.fn.expand("%")) end, "Neotest: run the file")
  keymap_n("<leader>rs", neotest.summary.toggle, "Neotest: show Test summary")
  keymap_n("<leader>ro", neotest.output_panel.toggle, "Neotest: show output pannel")
  keymap_n("<leader>rt", function() neotest.output.open({ enter = true }) end, "Neotest: show float output window")
  keymap_n("<leader>rd", function() neotest.run.run({strategy = "dap"}) end, "Neotest: debug the test case")
end

M.setup = function()
  -- load_required_pacakges()
  neotest_setup()
  neotest_keymap()
end

return M
