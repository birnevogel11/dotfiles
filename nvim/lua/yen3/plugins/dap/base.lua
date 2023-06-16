local M = {}

local yen3_local = require("yen3.local")
local notify_simple = require("yen3.lib.notify").notify
local keymap_n = require("yen3.lib.keymap").keymap_n

local load_local_config = function()
  local dap_config_python = require("dap").configurations.python

  if yen3_local.dap_launch_python_extra then
    if yen3_local.dap_launch_python_default_configs then
      for _, extra_config in ipairs(yen3_local.dap_launch_python_extra) do
        table.insert(dap_config_python, extra_config)
      end
    else
      require("dap").configurations.python = yen3_local.dap_launch_python_extra
    end
  end
end

local add_debug_keymap = function()
  local dap = require("dap")
  local dapui = require("dapui")
  local pb = require("persistent-breakpoints.api")

  -- Setup the keymapping
  keymap_n("<leader>ec", dap.continue, "DAP: continue")
  keymap_n("<leader>eq", function()
    dap.terminate()
    notify_simple("DAP", "Terminate the debug session ...")
  end , "DAP: terminate")
  keymap_n("<leader>eu", dapui.toggle, "DAP: toogle debug UI")
  keymap_n("<leader>em", function()
    require("telescope").extensions.dap.commands({})
  end, "DAP: list commands")

  keymap_n("<leader>eb", pb.toggle_breakpoint, "DAP: toggle breakpoint")
  ---@diagnostic disable-next-line: param-type-mismatch
  keymap_n("<leader>eB", function() pb.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
           "DAP: conditional breakpoint")
  keymap_n("<leader>ecc", function()
    pb.clear_all_breakpoints()
    notify_simple("DAP", "Clean all breakpoints")
  end, "DAP: clean all breakpoints")

  keymap_n("<leader>es", dap.step_into, "DAP: step into")
  keymap_n("<leader>ei", dap.step_over, "DAP: step over")
  keymap_n("<leader>eo", dap.step_out, "DAP: step out")

  keymap_n("<leader>ev", function() dapui.float_element("scopes", { enter = true }) end, "DAP: float window scope")
  keymap_n("<leader>ek", function() dapui.float_element("stacks", { enter = true }) end, "DAP: float window stack")
  -- keymap_n("<leader>qL", function() dapui.float_element("repl", { enter = true }) end, "DAP: float window repl")

  keymap_n("<leader>er", function() vim.cmd [[ RustDebuggables ]] end)
end

local add_dap_event = function()
  local dap, dapui = require("dap"), require("dapui")

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

local init_debug_env = function()
  -- Load stored breakpoints
  require("persistent-breakpoints.api").load_breakpoints()

  -- Add UI & Key config
  add_debug_keymap()

  -- Load config
  load_local_config()

  -- Enable mouse
  vim.opt.mouse = "nvi"
  vim.opt.mousemodel = "popup_setpos"

  -- Add dap event
  add_dap_event()
end

M.start_debug_session = function()
  init_debug_env()
  notify_simple("DAP", "Start the debug session and restore breakpoints")
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
          { id = "stacks", size = 0.15 },
          { id = "breakpoints", size = 0.25 },
          { id = "scopes", size = 0.55 },
        },
        size = 40, -- 40 columns
        position = "right",
      },
      {
        elements = {
          -- { id = "console", size = 0.1 },
          { id = "repl", size = 1 },
        },
        size = 0.25, -- 25% of total lines
        position = "bottom",
      },
    },
  })
end

local plugin_setup = function()
  dapui_plugin_seup()

  ---@diagnostic disable-next-line: missing-parameter
  require("nvim-dap-virtual-text").setup()
  require("dap-python").setup()
  require("telescope").load_extension("dap")
  require("persistent-breakpoints").setup({ load_breakpoints_event = nil })
  require('nvim-dap-repl-highlights').setup()

  define_dap_symbol()
end

M.repl_auto_complete_setup = function()
  require("cmp").setup.filetype({ "dap-repl", "dapui_watches" }, {
    sources = {
      { name = "dap" },
    },
  })
end

M.dap_setup = function()
  plugin_setup()

  keymap_n("<leader>ee", M.start_debug_session, "DAP: start debug session")
  keymap_n("<leader>et", start_debug_test_case, "Neotest + DAP: debug for the test case")
end

return M
