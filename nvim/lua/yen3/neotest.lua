local keymap_n = require('yen3.lib.keymap').keymap_n
local neotest = require("neotest")

local M = {}

M.setup = function()
  neotest.setup({
    adapters = {
       require("neotest-python")({
        dap = { justMyCode = false },
        runner = "pytest",
        args = {"--log-level", "DEBUG", "-svv"},
       }),
    }
  })

  keymap_n("<leader>rr", function() neotest.run.run() end, "Neotest: run nearest")
  keymap_n("<leader>rf", function() neotest.run.run(vim.fn.expand("%")) end, "Neotest: run the file")
  keymap_n("<leader>rs", neotest.summary.toggle, "Neotest: show Test summary")
  keymap_n("<leader>ro", neotest.output_panel.toggle, "Neotest: show output pannel")
  keymap_n("<leader>rt", function() neotest.output.open({ enter = true }) end, "Neotest: show float output window")

  -- keymap_n("<leader>ro", function()
  --   local line_nr = vim.api.nvim_win_get_cursor(0)[1]
  --   local tree = neotest.run.get_tree_from_args({}, true)
  --   local lib = require('neotest.lib.positions')
  --   local position_node = lib.nearest(tree, line_nr)
  --   neotest.output.open({position_id=position_node:data().id, enter = true})
  -- end)
end

return M
