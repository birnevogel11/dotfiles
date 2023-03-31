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
--     program = "<fill it>",
--     justMyCode = false,
--     args = {
--     }
--   }
-- }
M.dap_launch_python_extra = {}
M.dap_launch_python_default_configs = true

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
