local M = {}

M.pylsp_flake8_config = { enable = false }
M.pylsp_mypy_config = { enable = false }
M.pylsp_pylint_config = { enable = false }

M.enable_cspell = false
M.cspell_extra_args = {}

-- Config example:
--
-- require('yen3.local').dap_launch_python_default_configs = false
-- require('yen3.local').dap_launch_python_extra = {
--   {
--     name = "Python: debug",
--     type = "python",
--     request = "launch",
--     python = "/home/yen3/.pyenv/versions/3.9.8/bin/python3",
--     cwd = vim.fn.getcwd(),
--     program = "<fill it>",
--     args = {
--     }
--     justMyCode = false,
--     stopOnEntry = true,
--   }
-- }
M.dap_launch_python_extra = {}
M.dap_launch_python_default_configs = true

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
--     nvim "+lua require('test')"

return M
