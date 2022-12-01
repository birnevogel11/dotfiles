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
         { id = "console", size = 0.7},
         { id = "repl", size = 0.3},
       },
       size = 0.25, -- 25% of total lines
       position = "bottom",
     },
    },
  })
end

local load_local_config = function ()
  local dap_ext_vscdoe = require("dap.ext.vscode")

  -- TODO: fix it
  -- require('dap.ext.vscode').json_decode = require'json5'.parse
  if yen3_local.dap_launch_json_path then
    dap_ext_vscdoe.load_launchjs(yen3_local.dap_launch_json_path)
  end
  dap_ext_vscdoe.load_launchjs()
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

  -- Setup repl completion
  -- TODO: fix it
  vim.cmd [[ au FileType dap-repl lua require('dap.ext.autocompl').attach() ]]

  -- Enable mouse
  vim.opt.mouse = 'nvi'
  vim.opt.mousemodel = 'popup_setpos'

  -- Setup the keymapping
  map_call_n("c", dap.continue)
  map_call_n("e", dap.terminate)
  map_call_n("b", pb.toggle_breakpoint)
  map_call_n("<leader>bc", pb.clear_all_breakpoints)
  map_call_n("n", dap.step_over)
  map_call_n("s", dap.step_into)
  map_call_n("q", function()
    dap.terminate()
    dapui.toggle()
  end)
  map_call_n("<leader>qc", function() require('telescope').extensions.dap.commands({}) end)
  map_call_n("<leader>o", dap.step_out)
  map_call_n("<leader>B", function() pb.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
  map_call_n("<leader>ql", dap.repl_open)
  map_call_n("<leader>qu", function () dapui.float_element("scopes", {enter=true}) end)
  map_call_n("<leader>qL", function () dapui.float_element("repl", {enter=true}) end)
  map_call_n("<leader>qr", dap.run_last)
  map_call_n("<leader>qf", dap_python.test_method)
  map_call_n("<leader>qt", dap_python.test_class)

  if is_launch then
    dap.continue()
  end
end

local init_keyamp = function ()
  map_call_n("<leader>qq", function() init_debug_env(true) end)
  map_call_n("<leader>qQ", function() init_debug_env(false) end)
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
