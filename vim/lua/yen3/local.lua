local M = {}

M.pylsp_flake8_config = { enable = false }
M.pylsp_mypy_config = { enable = false }
M.pylsp_pylint_config = { enable = false }

M.lspsaga_winbar_enable = false

M.enable_cspell = false
M.cspell_extra_args = {}

-- Example config in .lvimrc_launch.json
--
-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
-- Remote debug/attach:
--
-- python3 -m debugpy --listen 0.0.0.0:5678 --wait-for-client /usr/bin/dltlyse
--
-- or
--
-- import debugpy; debugpy.listen(5678); print("Waiting for debugger attach"); debugpy.wait_for_client()
-- debugpy.breakpoint()
--
-- {
--     "version": "0.2.0",
--     "configurations": [
--         {
--             "type": "python",
--             "request": "launch"
--             "name": "Launch",
--             "program": "${input:myPrompt}"
--         },
--         {
--             "type": "python",
--             "request": "launch"
--             "name": "Dltlyse show plugins",
--             "program": "/home/yen3/.pyenv/versions/dltlyse/bin/dltlyse",
--             "console": "integratedTerminal",
--             "justMyCode": "false"
--             "args": ["-s"],
--         },
--         {
--            "type": "python",
--            "name": "Attach",
--            "request": "attach",
--            "connect": {
--              "host": "localhost",
--              "port": 5678
--            },
--            "justMyCode": false,
--            "pathMappingsr": {
--              "localRoot": "${workspaceFolder}",
--              "remoteRoot": ".",
--            }
--         }
--     ],
--     "inputs": [
--         {
--             "id": "myPrompt",
--             "type": "pickString",
--             "description": "Program to run: ",
--             "default": "foobar"
--         }
--     ]
-- }
M.dap_launch_json_path = ''

M.dap_launch_python_extra = {}

return M
