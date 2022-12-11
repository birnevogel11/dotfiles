local M = {}

local yen3_local = require("yen3.local")
local config_util = require("yen3.util.config")
local map_call_n = config_util.map_call_n

local define_dap_symbol = function()
  vim.fn.sign_define(
    'DapBreakpoint',
    {text='', texthl='DiagnosticSignError', linehl='', numhl=''}
  )
  vim.fn.sign_define(
      'DapBreakpointRejected',
      {text='', texthl='DiagnosticSignWarn', linehl='', numhl=''}
  )
  vim.fn.sign_define(
      'DapStopped',
      {text='', texthl='GitSignsDelete', linehl='GitSignsDeleteLn', numhl=''}
  )
end

local dapui_plugin_seup = function ()
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
       position = "right",
     },
     {
       elements = {
         { id = "console", size = 0.3},
         { id = "repl", size = 0.7},
       },
       size = 0.25, -- 25% of total lines
       position = "bottom",
     },
    },
  })
end

local load_local_config = function ()
  local dap_config_python = require("dap").configurations.python

  if yen3_local.dap_launch_python_extra then
    for _, extra_config in ipairs(yen3_local.dap_launch_python_extra) do
      table.insert(dap_config_python, extra_config)
    end
  end
end

local init_debug_env = function(is_launch)
  local dap = require("dap")
  local dapui = require("dapui")
  local dap_python = require("dap-python")
  local pb = require('persistent-breakpoints.api')

  -- Load config
  load_local_config()

  -- Prepare the UI
  pb.load_breakpoints()
  dapui.toggle()

  -- Enable mouse
  vim.opt.mouse = 'nvi'
  vim.opt.mousemodel = 'popup_setpos'

  -- Setup the keymapping
  map_call_n("c", dap.continue, "Dap continue")
  map_call_n("e", dap.terminate, "Dap terminate")
  map_call_n("<leader>b", pb.toggle_breakpoint, "Dap toggle breakpoint")
  map_call_n("<leader>bc", pb.clear_all_breakpoints, "Dap clean all breakpoints")
  map_call_n("n", dap.step_over, "Dap step over")
  map_call_n("s", dap.step_into, "Dap step into")
  map_call_n("q", function()
    dap.terminate()
    dapui.toggle()
  end, "Dap terminate")
  map_call_n("<leader>qc", function() require('telescope').extensions.dap.commands({}) end, "Dap list commands")
  map_call_n("<leader>o", dap.step_out, "Dap step out")
  map_call_n("<leader>B", function() pb.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
    "Dap conditional breakpoint"
  )
  map_call_n("<leader>ql", dap.repl_open, "Dap repl open")
  map_call_n("<leader>qu", function () dapui.float_element("scopes", {enter=true}) end, "Dap float window scope")
  map_call_n("<leader>qL", function () dapui.float_element("repl", {enter=true}) end, "Dap float window repl")
  map_call_n("<leader>qr", dap.run_last, "Dap run last")
  if vim.api.nvim_buf_get_option(0, "buftype") == "python" then
    map_call_n("<leader>qf", dap_python.test_method, "Dap test python method")
    map_call_n("<leader>qt", dap_python.test_class, "Dap test python class")
  end

  if is_launch then
    dap.continue()
  end
end

local init_keyamp = function ()
  map_call_n("<leader>qq", function() init_debug_env(false) end, "Dap start without launch")
  map_call_n("<leader>qQ", function() init_debug_env(true) end, "Dap start with launch")
end

local plugin_setup = function()
  dapui_plugin_seup()
  require("nvim-dap-virtual-text").setup()
  require('dap-python').setup()
  require('telescope').load_extension('dap')
  require('persistent-breakpoints').setup({ load_breakpoints_event = nil })

  define_dap_symbol()
end

M.setup = function()
  plugin_setup()
  init_keyamp()
end

return M
