local M = {}

-- M.pylsp_flake8_config = { enable = false }
-- M.pylsp_mypy_config = { enable = false }
-- M.pylsp_pylint_config = { enable = false }

M.enable_cspell = false
M.cspell_extra_args = {}

-- Python config example:
--
-- require('yen3.local').dap_ui_console_element = false
-- require('yen3.local').dap_config = {
--   python = {
--     launch_default = false,
--     launch = {
--       {
--         name = "Python: debug",
--         type = "python",
--         request = "launch",
--         python = "/home/yen3/.pyenv/versions/3.9.8/bin/python3",
--         cwd = vim.fn.getcwd(),
--         program = "<fill it>",
--         args = {
--         }
--         justMyCode = false,
--         stopOnEntry = true,
--       }
--     },
--   }
-- }

-- C++ config example:
--
-- require('yen3.local').dap_ui_console_element = true
-- require('yen3.local').dap_config = {
--   cpp = {
--     launch_default = false,
--     launch = {
--       {
--         name = "Launch file",
--         type = "codelldb",
--         request = "launch",
--         program = function()
--           return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--         end,
--         cwd = '${workspaceFolder}',
--         stopAtEntry = true,
--       },
--       {
--         name = 'Attach to gdbserver :1234',
--         type = 'cppdbg',
--         request = 'launch',
--         MIMode = 'gdb',
--         miDebuggerServerAddress = 'localhost:1234',
--         miDebuggerPath = '/usr/bin/gdb',
--         cwd = '${workspaceFolder}',
--         program = function()
--           return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--         end,
--       },
--     },
--   }
-- }

-- Rust config example:
--
-- require('yen3.local').dap_ui_console_element = true
-- require('yen3.local').dap_config = {
--   rust = {
--     launch_default = false,
--     launch = {
--       {
--         name = "Rust tools debug",
--         type = "rt_lldb",
--         request = "launch",
--         program = vim.fn.getcwd() .. "/target/debug/ugly_number",
--         args = {},
--         cwd = vim.fn.getcwd(),
--         stopOnEntry = false,
--         runInTerminal = false,
--         justMyCode = false,
--       }
--     },
--   }
-- }
M.dap_ui_console_element = false
M.dap_config = {
  python = {
    launch_default = true,
    launch = {},
  },
  cpp = {
    launch_default = true,
    launch = {},
  },
}

-- Rust example (https://github.com/simrat39/rust-tools.nvim/blob/master/lua/rust-tools/dap.lua)
--
-- require("yen3_local").dap_run_config = {
--   name = "Rust tools debug",
--   type = "rt_lldb",
--   request = "launch",
--   program = vim.fn.getcwd() .. "/target/debug/ugly_number",
--   args = {},
--   cwd = vim.fn.getcwd(),
--   stopOnEntry = false,
--   runInTerminal = false,
--   justMyCode = false,
-- }
--
-- Python example
--
-- require("yen3.plugins.dap.base").dap_run_config = {
--   name = "Python: debug",
--   type = "python",
--   request = "launch",
--   python = os.getenv("HOME") .. "/.pyenv/versions/3.10.10/bin/python3",
--   program = "./main.py",
--   justMyCode = false,
--   args = { },
--   stopOnEntry = true,
-- }
M.dap_run_config = nil

-- Run debug from command line
--
-- 1. Save the following content as test.lua
--
--     vim.cmd [[ :e ./main.py ]]
--
--     require("yen3.plugins.dap.base").dap_run_custom_config({
--       name = "Python: debug",
--       type = "python",
--       request = "launch",
--       python = os.getenv("HOME") .. "/.pyenv/versions/3.10.10/bin/python3",
--       program = "./main.py",
--       justMyCode = false,
--       args = { },
--       stopOnEntry = true,
--     })
--
-- 2. Run the command
--
--     NVIM_DAP_DEBUG_ENABLE=yes NVIM_DAP_DEBUG_CONSOLE_ENABLE=yes nvim "+lua require('test')"

return M
