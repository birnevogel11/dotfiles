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
--
-- Run a program:
--
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
--
-- Remote debug/attach:
--
-- python3 -m debugpy --listen 0.0.0.0:5678 --wait-for-client /usr/bin/dltlyse
--
-- or
--
-- import debugpy; debugpy.listen(5678); print("Waiting for debugger attach"); debugpy.wait_for_client()
-- debugpy.breakpoint()
--
-- require('yen3.local').dap_python_config = {
--   {
--      name = "Attach",
--      type = "python",
--      request = "attach",
--      connect = {
--        host = "localhost",
--        port = 5678
--      },
--      justMyCode = false,
--      pathMappings = {
--        localRoot = "${workspaceFolder}",
--        remoteRoot = ".",
--      }
--   }
-- }
M.dap_python_config = {}

return M
