local is_debug_env_inited = false

local dapui_setup = function()
  local bv11_local = require("bv11.local")
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


local load_local_config = function()
  local dap_config = require("dap").configurations

  local bv11_local = require("bv11.local")
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

  -- Breakpoints
  vim.keymap.set("n","<leader>eb", dap.toggle_breakpoint, { desc = "DAP: toogle breakpoint" })
  vim.keymap.set("n","<leader>ebb", function() require("dap").toggle_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "DAP: set conditonal breakpoint" })
  vim.keymap.set("n","<leader>ebc", dap.clear_breakpoints, { desc = "DAP: clear all breakppoints" })

  -- Control
  vim.keymap.set("n","<leader>ec", dap.continue, { desc = "DAP: continue" })
  vim.keymap.set("n","<leader>es", dap.step_into, { desc = "DAP: step into" })
  vim.keymap.set("n","<leader>ei", dap.step_over, { desc = "DAP: step over" })
  vim.keymap.set("n","<leader>eo", dap.step_out, { desc = "DAP: step out" })
  vim.keymap.set("n","<leader>eu", function()
    require("dap").up()
    vim.notify("DAP: Jump to the up frame")
  end, { desc = "DAP: Go to the up frame" })
  vim.keymap.set("n","<leader>ed", function()
    require("dap").down()
    vim.notify("DAPJump to the down frame")
  end, { desc = "DAP: Go to the down frame" })
  vim.keymap.set("n","<leader>eq", function()
    require("dap").terminate()
    require("dapui").close()
    vim.notify("DAP: Terminate the debug session ...")

    vim.opt.mouse = ""  -- Disable mouse
    vim.notify("Mouse mode: Disable mouse")
  end, { desc = "DAP: terminate" })

  vim.keymap.set("n","<leader>ev", make_float_win("scopes"), { desc = "DAP: float window scope" })
  vim.keymap.set("n","<leader>ek", make_float_win("stacks"), { desc = "DAP: float window stack" })
  vim.keymap.set("n","<leader>ew", make_float_win("watches"), { desc = "DAP: float window watches" })
  vim.keymap.set("n","<leader>el", make_float_win("repl"), { desc = "DAP: float window repl" })
  vim.keymap.set({"n", "v"}, "<leader>eg", require("dapui").eval, { desc = "DAP: eval the currsor word" })
end

local setup_debug_ui = function()
  if is_debug_env_inited == true then
    return
  end

  load_local_config()
  add_debug_keymap()

  -- Avoid initializing again
  is_debug_env_inited = true

  require("dapui").open()

  -- Enable mouse
  vim.opt.mouse = "nvi"
  vim.opt.mousemodel = "popup_setpos"
  vim.notify("Enable mouse - nvi, mousemodel = popus_setpos")
end

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/mfussenegger/nvim-dap" },

    -- { src = "https://github.com/igorlfs/nvim-dap-view" },  -- TODO: try it

    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/LiadOz/nvim-dap-repl-highlights" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },

    { src = "https://github.com/mfussenegger/nvim-dap-python" },

    { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },

    -- { src = "https://github.com/rcarriga/cmp-dap" },  -- WIP: adapt it for blink-cmp
  }, { confirm = false })

  require("dap-python").setup("python3")
  dapui_setup()
  ---@diagnostic disable-next-line: missing-parameter
  require("nvim-dap-virtual-text").setup()
  require("nvim-dap-repl-highlights").setup()

  -- TODO: migrate to 0.11
  vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = " ", texthl = "GitSignsDelete", linehl = "GitSignsDeleteLn", numhl = "" })

  -- Keymap
  vim.keymap.set("n", "<leader>ee", setup_debug_ui, { desc = "DAP: initial debug environment" })
  vim.keymap.set("n", "<leader>et", function()
    vim.notify("DAP: Debug the current line of the unit test case")
    setup_debug_ui()
    require("dap").set_breakpoint()  -- Set the breakpoint in the current line
    ---@diagnostic disable-next-line: missing-fields
    require("neotest").run.run({strategy = "dap"})
  end, { desc = "DAP: debug unit test case" })
end)
