local M = {}

local is_debug_env_inited = false

local bv11_local = require("bv11.local")
local notify_simple = require("bv11.lib.notify").notify
local keymap = require("bv11.lib.keymap").keymap
local keymap_n = require("bv11.lib.keymap").keymap_n

local load_local_config = function()
  local dap_config = require("dap").configurations

  for filetype, config in pairs(bv11_local.dap_config) do
    if config.launch then
      if config.launch_default then
        for _, item in ipairs(config.launch) do
          table.insert(dap_config[filetype], item)
        end
      else
        dap_config[filetype] = config.launch
      end
    end
  end
end

local add_debug_keymap = function()
  local dap = require("dap")
  local dapui = require("dapui")
  local pb = require("persistent-breakpoints.api")

  -- Control
  keymap_n("<leader>ec", dap.continue, "DAP: continue")
  keymap_n("<leader>eq", function()
    dap.terminate()
    notify_simple("DAP", "Terminate the debug session ...")
  end, "DAP: terminate")
  keymap_n("<leader>es", dap.step_into, "DAP: step into")
  keymap_n("<leader>ei", dap.step_over, "DAP: step over")
  keymap_n("<leader>eo", dap.step_out, "DAP: step out")
  keymap_n("<leader>eu", function()
    dap.up()
    notify_simple("DAP", "Jump to the up frame")
  end, "DAP: Go to the up frame")
  keymap_n("<leader>ed", function()
    dap.down()
    notify_simple("DAP", "Jump to the down frame")
  end, "DAP: Go to the down frame")

  -- Breakpoints
  keymap_n("<leader>el", function()
    notify_simple("DAP", "Load breakpoints ...")
    require("persistent-breakpoints.api").load_breakpoints()
  end, "DAP: load breakpoints")
  keymap_n("<leader>eb", pb.toggle_breakpoint, "DAP: toggle breakpoint")
  ---@diagnostic disable-next-line: param-type-mismatch
  keymap_n("<leader>eB", function()
    pb.set_conditional_breakpoint()
  end, "DAP: conditional breakpoint")
  keymap_n("<leader>ecc", function()
    pb.clear_all_breakpoints()
    notify_simple("DAP", "Clean all breakpoints")
  end, "DAP: clean all breakpoints")

  -- UI
  keymap_n("<leader>eg", dapui.eval, "DAP: eval the currsor word")
  keymap("v", "<leader>eg", dapui.eval, "DAP: eval the selection word")
  keymap_n("<leader>ev", function()
    dapui.float_element("scopes", { enter = true })
  end, "DAP: float window scope")
  keymap_n("<leader>ek", function()
    dapui.float_element("stacks", { enter = true })
  end, "DAP: float window stack")
  keymap_n("<leader>ew", function()
    dapui.float_element("repl", { enter = true })
  end, "DAP: float window repl")
  -- keymap_n("<leader>et", dapui.toggle, "DAP: toogle debug UI")

  -- Misc
  keymap_n("<leader>ef", function()
    require("telescope").extensions.dap.commands({})
  end, "DAP: list commands")
end

local config_window = function()
  vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = { "\\[dap-repl\\]", "DAP *" },
    callback = function(args)
      local win = vim.fn.bufwinid(args.buf)
      local win_settings = {
        list = false,
        relativenumber = false,
        number = false,
        wrap = true,
        signcolumn = "auto",
      }
      for key, val in pairs(win_settings) do
        vim.api.nvim_win_set_option(win, key, val)
      end
    end,
  })
end

local init_debug_env = function()
  if is_debug_env_inited == true then
    return
  end

  -- Add UI & Key config
  add_debug_keymap()

  -- Load config
  load_local_config()

  -- Enable mouse
  vim.opt.mouse = "nvi"
  vim.opt.mousemodel = "popup_setpos"

  -- Add window option
  config_window()

  -- Load stored breakpoints
  require("persistent-breakpoints.api").load_breakpoints()

  -- Avoid initializing again
  is_debug_env_inited = true
end

local define_dap_symbol = function()
  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "", texthl = "GitSignsDelete", linehl = "GitSignsDeleteLn", numhl = "" })
end

local dapui_plugin_seup = function()
  local footer_elements = {}
  if os.getenv("NVIM_DAP_DEBUG_CONSOLE_ENABLE") ~= nil or bv11_local.dap_ui_console_element then
    footer_elements = {
      { id = "console", size = 0.5 },
      { id = "repl", size = 0.5 },
    }
  else
    footer_elements = {
      { id = "repl", size = 1 },
    }
  end

  ---@diagnostic disable-next-line: missing-fields
  require("dapui").setup({
    layouts = {
      {
        elements = {
          { id = "watches", size = 0.05 },
          { id = "stacks", size = 0.15 },
          { id = "breakpoints", size = 0.25 },
          { id = "scopes", size = 0.55 },
        },
        size = 40,
        position = "right",
      },
      {
        elements = footer_elements,
        size = 0.25,
        position = "bottom",
      },
    },
  })
end

local plugin_setup = function()
  dapui_plugin_seup()

  ---@diagnostic disable-next-line: missing-parameter
  require("nvim-dap-virtual-text").setup()
  require("dap-python").setup(require("bv11.lib.python").get_pyenv_virtualenv_bin_path("python3"))
  require("telescope").load_extension("dap")
  require("persistent-breakpoints").setup({ load_breakpoints_event = nil })
  require("nvim-dap-repl-highlights").setup()

  define_dap_symbol()
end

local repl_auto_complete_setup = function()
  require("cmp").setup.filetype({ "dap-repl", "dapui_watches" }, {
    sources = {
      { name = "dap" },
    },
  })
end

M.dap_run_custom_config = function(custom_config)
  local config = bv11_local.dap_run_config or custom_config
  local dap = require("dap")

  M.start_debug()

  if bv11_local.rust_debuggable_args ~= "" then
    local args = {'debuggables'}
    for _, value in ipairs(bv11_local.rust_debuggable_args) do
      table.insert(args, value)
    end

    vim.cmd.RustLsp(args)
  elseif config ~= nil then
    dap.run(config)
  end
notify_simple("DAP", "Run the custom dap-run config directly ...")
end

local start_debug_test_case = function()
  M.start_debug()
  require("neotest").run.run({ strategy = "dap" })
  notify_simple("DAP", "Debug for the test case")
end

M.start_debug = function()
  init_debug_env()
  notify_simple("DAP", "Start the debug session and restore breakpoints")
  require("dapui").open()
end

M.dap_setup = function()
  plugin_setup()
  repl_auto_complete_setup()

  keymap_n("<leader>ee", M.start_debug, "DAP: initial debug environment")
  keymap_n("<leader>er", M.dap_run_custom_config, "Run custom config dap-run directly")
  -- See lua/bv11/plugins/neotest.lua
  keymap_n("<leader>rd", start_debug_test_case, "Neotest + DAP: debug for the test case")
end

return M
