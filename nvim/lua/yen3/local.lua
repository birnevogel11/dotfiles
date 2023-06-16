local M = {}

M.pylsp_flake8_config = { enable = false }
M.pylsp_mypy_config = { enable = false }
M.pylsp_pylint_config = { enable = false }

M.enable_cspell = false
M.cspell_extra_args = {}

-- Config example:
--
-- local yen3_local = require('yen3.local')
--
-- yen3_local.dap_launch_python_extra = {
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
-- local yen3_local = require("yen3.local")
--
-- yen3_local.dap_run = {
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
M.dap_run = nil

-- debug example (TBD)
--
-- nvim "+lua require('test')"
--
-- local launch_python = {
--   {
--     name = "Python: debug",
--     type = "python",
--     request = "launch",
--     python = os.getenv("HOME") .. "/.pyenv/versions/3.10.10/bin/python3",
--     program = "./main.py",
--     justMyCode = false,
--     args = { }
--   }
-- }
--
-- require("dap").configurations.python = launch_python
-- vim.cmd [[ :e ./main.py ]]
-- require("yen3.plugins.dap.base").start_debug_session()



return M
