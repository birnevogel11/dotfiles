local M = {}

local config_util = require("yen3.util.config")
local map_call_n = config_util.map_call_n

local plugin_setup = function()
  require("dapui").setup()
  require("nvim-dap-virtual-text").setup()
  require('dap-python').setup()
end

M.init_keymap = function()
  local dap = require("dap")
  map_call_n("<leader>dg",
    function()
      map_call_n("<leader>u", require('dapui').toggle)
      map_call_n("<leader>c", dap.continue)
      map_call_n("<leader>b", dap.toggle_breakpoint)
      map_call_n("<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
      map_call_n("<leader>s", dap.step_over)
      map_call_n("<leader>i", dap.step_into)
      map_call_n("<leader>o", dap.step_out)
      map_call_n("<leader>l", dap.repl_open)
      -- map_call_n("<leader>dll", dap.run_last)
      -- map_call_n("<leader>tf", require('dap-python').test_method)
      -- map_call_n("<leader>tc", require('dap-python').test_class)
    end
  )
end

M.setup = function()
  plugin_setup()
  M.init_keymap()
end

return M
