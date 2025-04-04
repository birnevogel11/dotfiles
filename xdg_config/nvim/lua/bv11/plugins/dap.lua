local is_debug_env_inited = false

local bv11_local = require("bv11.local")
local notify_simple = require("bv11.lib.notify").notify

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

local up_frame = function()
  require("dap").up()
  notify_simple("DAP", "Jump to the up frame")
end

local down_frame = function()
  require("dap").down()
  notify_simple("DAP", "Jump to the down frame")
end

local set_conditional_breakpoint = function ()
  local condition = vim.fn.input("Breakpoint condition: ")
  require("dap").toggle_breakpoint(condition)
end

local terminate_dap_session = function()
  require("dap").terminate()
    notify_simple("DAP", "Terminate the debug session ...")
end

---Make a floating DAP window
---@param scope string
---@return function
local make_float_win = function(scope)
  return function()
    ---@diagnostic disable-next-line: missing-fields
    require("dapui").float_element(scope, { enter = true })
  end
end


local add_debug_keymap = function()
  local keymap_n = require("bv11.lib.keymap").keymap_n
  local dap = require("dap")

  -- Breakpoints
  keymap_n("<leader>eb", dap.toggle_breakpoint, "DAP: toogle breakpoint")
  keymap_n("<leader>ebb", set_conditional_breakpoint, "DAP: set conditonal breakpoint")
  keymap_n("<leader>ebc", dap.clear_breakpoints, "DAP: clear all breakppoints")

  -- Control
  keymap_n("<leader>ec", dap.continue, "DAP: continue")
  keymap_n("<leader>eq", terminate_dap_session, "DAP: terminate")
  keymap_n("<leader>es", dap.step_into, "DAP: step into")
  keymap_n("<leader>ei", dap.step_over, "DAP: step over")
  keymap_n("<leader>eo", dap.step_out, "DAP: step out")
  keymap_n("<leader>eu", up_frame, "DAP: Go to the up frame")
  keymap_n("<leader>ed", down_frame, "DAP: Go to the down frame")

  -- UI
  keymap_n("<leader>ev", make_float_win("scopes"), "DAP: float window scope")
  keymap_n("<leader>ek", make_float_win("stacks"), "DAP: float window stack")
  keymap_n("<leader>ew", make_float_win("watches"), "DAP: float window watches")
  keymap_n("<leader>el", make_float_win("repl"), "DAP: float window repl")
  -- keymap_n("<leader>eg", dapui.eval, "DAP: eval the currsor word")
  -- keymap("v", "<leader>eg", dapui.eval, "DAP: eval the selection word")

  -- Misc
  -- TODO: implement it with snacks.picker
  -- keymap_n("<leader>ef", function()
  --   require("telescope").extensions.dap.commands({})
  -- end, "DAP: list commands")
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
        vim.api.nvim_set_option_value(key, val, {win=win})
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

  -- Avoid initializing again
  is_debug_env_inited = true
end

local dapui_plugin_setup = function()
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
          -- { id = "watches", size = 0.05 },
          -- { id = "stacks", size = 0.15 },
          { id = "breakpoints", size = 0.25 },
          { id = "scopes", size = 0.75 },
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

--- Start the debug session
---@param send_notify boolean?
local start_debug = function(send_notify)
  init_debug_env()
  if send_notify ~= nil and send_notify == true then
    notify_simple("DAP", "Start the debug session")
  end
  require("dapui").open()
end

local start_debug_test_case = function()
  notify_simple("DAP", "Debug the current line of the unit test case")
  require("dap-python").setup("python3")
  start_debug(false)
  require("dap").toggle_breakpoint()
  require('dap-python').test_method()
end

local dap_setup = function()
  local keymap_n = require("bv11.lib.keymap").keymap_n

  dapui_plugin_setup()

  ---@diagnostic disable-next-line: missing-parameter
  require("nvim-dap-virtual-text").setup()
  require("nvim-dap-repl-highlights").setup()

  -- TODO: migrate to 0.11
  vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = " ", texthl = "GitSignsDelete", linehl = "GitSignsDeleteLn", numhl = "" })

  keymap_n("<leader>ee", start_debug, "DAP: initial debug environment")
  keymap_n("<leader>et", start_debug_test_case, "DAP: python test method")
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- { "igorlfs/nvim-dap-view" },  -- TODO: test until it's mature
      { "LiadOz/nvim-dap-repl-highlights" },
      { "mfussenegger/nvim-dap-python" },
      { "nvim-neotest/nvim-nio" },
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      -- { "Weissle/persistent-breakpoints.nvim" },
      -- { "rcarriga/cmp-dap" },  -- WIP: adapt it for blink-cmp
    },
    event = "VeryLazy",
    config = function()
      dap_setup()
    end,
  }
}
