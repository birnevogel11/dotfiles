local M = {}

local yen3_local = require("yen3.local")
local config_util = require("yen3.util.config")
local map_call_n = config_util.map_call_n

local plugin_setup = function()
  require("dapui").setup({
    layouts = {
     {
       elements = {
         { id = "watches", size = 0.05},
         { id = "stacks", size = 0.25},
         { id = "breakpoints", size = 0.25},
         { id = "scopes", size = 0.45 },
       },
       size = 40, -- 40 columns
       position = "left",
     },
     {
       elements = {
         { id = "console", size = 0.7},
         { id = "repl", size = 0.3},
       },
       size = 0.25, -- 25% of total lines
       position = "bottom",
     },
    },
  })
  require("nvim-dap-virtual-text").setup()
  require('dap-python').setup()
  require('telescope').load_extension('dap')
  require('persistent-breakpoints').setup({ load_breakpoints_event = nil })

  vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

  if yen3_local.dap_python_config ~= nil then
    for _, extra_dap_python_config in ipairs(yen3_local.dap_python_config) do
      table.insert(require('dap').configurations.python, extra_dap_python_config)
    end
  end
end

local init_debug_env = function()
  local dap = require("dap")
  local dapui = require("dapui")
  local dap_python = require("dap-python")
  local pb = require('persistent-breakpoints.api')

  -- Prepare the UI
  pb.load_breakpoints()
  dapui.toggle()

  -- Enable mouse
  vim.opt.mouse = 'nvi'

  -- Setup the keymapping
  map_call_n("<leader>c", dap.continue)
  map_call_n("<leader>e", dap.terminate)
  map_call_n("<leader>b", pb.toggle_breakpoint)
  map_call_n("<leader>bc", pb.clear_all_breakpoints)
  ---@diagnostic disable-next-line: param-type-mismatch
  map_call_n("<leader>B", function() pb.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
  map_call_n("<leader>s", dap.step_over)
  map_call_n("<leader>i", dap.step_into)
  map_call_n("<leader>o", dap.step_out)
  -- map_call_n("<leader>l", dap.repl_open)
  map_call_n("<leader>u", function () dapui.float_element("scopes", {enter=true}) end)
  map_call_n("<leader>dl", dap.run_last)
  map_call_n("<leader>tf", dap_python.test_method)
  map_call_n("<leader>tc", dap_python.test_class)
end

local init_keyamp = function ()
  map_call_n("<leader>dg", init_debug_env)
end

M.setup = function()
  plugin_setup()
  init_keyamp()
end

return M
