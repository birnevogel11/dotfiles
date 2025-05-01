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
  local dap = require("dap")

  require("which-key").add({
    -- Breakpoints
    {"<leader>eb", dap.toggle_breakpoint, desc = "DAP: toogle breakpoint" },
    {"<leader>ebb", set_conditional_breakpoint, desc = "DAP: set conditonal breakpoint" },
    {"<leader>ebc", dap.clear_breakpoints, desc = "DAP: clear all breakppoints" },

    -- Control
    {"<leader>ec", dap.continue, desc = "DAP: continue" },
    {"<leader>eq", terminate_dap_session, desc = "DAP: terminate" },
    {"<leader>es", dap.step_into, desc = "DAP: step into" },
    {"<leader>ei", dap.step_over, desc = "DAP: step over" },
    {"<leader>eo", dap.step_out, desc = "DAP: step out" },
    {"<leader>eu", up_frame, desc = "DAP: Go to the up frame" },
    {"<leader>ed", down_frame, desc = "DAP: Go to the down frame" },

    -- UI
    {"<leader>ev", make_float_win("scopes"), desc = "DAP: float window scope" },
    {"<leader>ek", make_float_win("stacks"), desc = "DAP: float window stack" },
    {"<leader>ew", make_float_win("watches"), desc = "DAP: float window watches" },
    {"<leader>el", make_float_win("repl"), desc = "DAP: float window repl" },
    {"<leader>eg", require("dapui").eval, mode = {"n", "v"}, desc = "DAP: eval the currsor word", group= "DAP"},
  })
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

  -- Initialize the UI
  start_debug(false)

  -- Set the breakpoint in the current line
  require("dap").set_breakpoint()

  -- Start the debug session
  ---@diagnostic disable-next-line: missing-fields
  require("neotest").run.run({strategy = "dap"})
end

local dap_setup = function()
  require("dap-python").setup("python3")

  dapui_plugin_setup()

  ---@diagnostic disable-next-line: missing-parameter
  require("nvim-dap-virtual-text").setup()
  require("nvim-dap-repl-highlights").setup()

  -- TODO: migrate to 0.11
  vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = " ", texthl = "GitSignsDelete", linehl = "GitSignsDeleteLn", numhl = "" })

  require("which-key").add({
    {"<leader>ee", start_debug, desc = "DAP: initial debug environment" },
    {"<leader>et", start_debug_test_case, desc = "DAP: debug unit test case" },
  })
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
      -- { "rcarriga/cmp-dap" },  -- WIP: adapt it for blink-cmp
    },
    event = "VeryLazy",
    config = function()
      dap_setup()
    end,
  }
}
