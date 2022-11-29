local M = {}

M.pylsp_flake8_config = { enable = false }
M.pylsp_mypy_config = { enable = false }
M.pylsp_pylint_config = { enable = false }

M.enable_spelunker = false
M.speulunker_extra_paths = {}

M.lspsaga_winbar_enable = false

M.enable_cspell = false
M.cspell_extra_args = {}

-- Example config in .lvimrc.lua
--
-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
-- require('yen3.local').dap_python_config = {
--   {
--     name = "dltlyse show plugins",
--     type = "python",
--     request = "launch",
--     program = "/home/yen3/.pyenv/versions/dltlyse/bin/dltlyse",
--     console = "integratedTerminal",
--     justMyCode = false,
--     args = {"-s"},
--   }
-- }
M.dap_python_config = {}

return M
