local M = {}

local yen3_local = require("yen3.local")
local keyamp_n = require("yen3.lib.keymap").keymap_n

local define_dap_symbol = function()
  vim.fn.sign_define("DAP:Breakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  vim.fn.sign_define("DAP:BreakpointRejected", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
  vim.fn.sign_define("DAP:Stopped", { text = "", texthl = "GitSignsDelete", linehl = "GitSignsDeleteLn", numhl = "" })
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
          { id = "console", size = 0.3 },
          { id = "repl", size = 0.7 },
        },
        size = 0.25, -- 25% of total lines
        position = "bottom",
      },
    },
  })
end

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
  local dap_python = require("dap-python")
  local pb = require("persistent-breakpoints.api")

  -- Load config
  load_local_config()

  -- Prepare the UI
  pb.load_breakpoints()
  dapui.toggle()

  -- Enable mouse
  vim.opt.mouse = "nvi"
  vim.opt.mousemodel = "popup_setpos"

  -- Setup the keymapping
  keyamp_n("<leader>ec", dap.continue, "DAP: continue")
  keyamp_n("<leader>eq", dap.terminate, "DAP: terminate")
  keyamp_n("<leader>et", dapui.toggle, "DAP: toogle debug UI")
  keyamp_n("<leader>em", function() require("telescope").extensions.dap.commands({}) end, "DAP: list commands")

  keyamp_n("<leader>eb", pb.toggle_breakpoint, "DAP: toggle breakpoint")
  keyamp_n("<leader>eB", function() pb.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, "DAP: conditional breakpoint")
  keyamp_n("<leader>ecc", pb.clear_all_breakpoints, "DAP: clean all breakpoints")

  keyamp_n("<leader>es", dap.step_over, "DAP: step over")
  keyamp_n("<leader>ei", dap.step_into, "DAP: step into")
  keyamp_n("<leader>eo", dap.step_out, "DAP: step out")

  keyamp_n("<leader>qu", function() dapui.float_element("scopes", { enter = true }) end, "DAP: float window scope")
  keyamp_n("<leader>qL", function() dapui.float_element("repl", { enter = true }) end, "DAP: float window repl")

  if vim.api.nvim_buf_get_option(0, "buftype") == "python" then
    keyamp_n("<leader>qf", dap_python.test_method, "DAP: test python method")
    keyamp_n("<leader>qt", dap_python.test_class, "DAP: test python class")
  end
end

local repl_auto_complete_setup = function()
  require("cmp").setup.filetype({ "dap-repl", "dapui_watches" }, {
    sources = {
      { name = "dap" },
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

  repl_auto_complete_setup()
end

M.setup = function()
  plugin_setup()

  keyamp_n("<leader>ee", init_debug_env, "DAP: start debug session")
end

return M
