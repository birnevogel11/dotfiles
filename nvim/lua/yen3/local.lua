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
--     name = "Python: node0 update-refspec debug",
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

return M
