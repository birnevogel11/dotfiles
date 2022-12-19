local yen3_local = require("yen3.local")
local notify_simple = require("yen3.lib.notify").notify
local keymap_n = require("yen3.lib.keymap").keymap_n

local M = {}

local load_local_config = function()
  local dap_config_python = require("dap").configurations.python

  if yen3_local.dap_launch_python_extra then
    for _, extra_config in ipairs(yen3_local.dap_launch_python_extra) do
      table.insert(dap_config_python, extra_config)
    end
  end
end

local init_debug_env = function()
  local dap = require("dap")
  local dapui = require("dapui")
  local pb = require("persistent-breakpoints.api")

  -- Setup the keymapping
  keymap_n("<leader>ec", dap.continue, "DAP: continue")
  keymap_n("<leader>eq", dap.terminate, "DAP: terminate")
  keymap_n("<leader>eu", dapui.toggle, "DAP: toogle debug UI")
  keymap_n("<leader>em", function()
    require("telescope").extensions.dap.commands({})
  end, "DAP: list commands")

  keymap_n("<leader>eb", pb.toggle_breakpoint, "DAP: toggle breakpoint")
  ---@diagnostic disable-next-line: param-type-mismatch
  keymap_n("<leader>eB", function() pb.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
           "DAP: conditional breakpoint")
  keymap_n("<leader>ecc", pb.clear_all_breakpoints, "DAP: clean all breakpoints")

  keymap_n("<leader>es", dap.step_over, "DAP: step over")
  keymap_n("<leader>ei", dap.step_into, "DAP: step into")
  keymap_n("<leader>eo", dap.step_out, "DAP: step out")

  keymap_n("<leader>qu", function() dapui.float_element("scopes", { enter = true }) end, "DAP: float window scope")
  keymap_n("<leader>qL", function() dapui.float_element("repl", { enter = true }) end, "DAP: float window repl")

  -- Load config
  load_local_config()

  -- Load stored breakpoints
  pb.load_breakpoints()

  -- Enable mouse
  vim.opt.mouse = "nvi"
  vim.opt.mousemodel = "popup_setpos"
end

local start_debug_session = function()
  notify_simple("DAP", "Start the debug session ...")
  require("dapui").open()
end

local start_debug_test_case = function ()
  notify_simple("Neotest + DAP", "Start to debug for the test ...")
  require("neotest").run.run({ strategy = "dap" })
  require("dapui").open()
end

local define_dap_symbol = function()
  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "", texthl = "GitSignsDelete", linehl = "GitSignsDeleteLn", numhl = "" })
end

local dapui_plugin_seup = function()
  require("dapui").setup({
    layouts = {
      {
        elements = {
          { id = "watches", size = 0.05 },
          { id = "stacks", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "scopes", size = 0.45 },
        },
        size = 40, -- 40 columns
        position = "right",
      },
      {
        elements = {
          { id = "console", size = 0.1 },
          { id = "repl", size = 0.9 },
        },
        size = 0.25, -- 25% of total lines
        position = "bottom",
      },
    },
  })
end

local plugin_setup = function()
  dapui_plugin_seup()

  require("nvim-dap-virtual-text").setup()
  require("dap-python").setup()
  require("telescope").load_extension("dap")
  require("persistent-breakpoints").setup({ load_breakpoints_event = nil })

  define_dap_symbol()
end

M.repl_auto_complete_setup = function()
  require("cmp").setup.filetype({ "dap-repl", "dapui_watches" }, {
    sources = {
      { name = "dap" },
    },
  })
end

M.setup = function()
  plugin_setup()
  init_debug_env()

  keymap_n("<leader>ee", start_debug_session, "DAP: start debug session")
  keymap_n("<leader>et", start_debug_test_case, "Neotest + DAP: debug for the test case")
end

return M
