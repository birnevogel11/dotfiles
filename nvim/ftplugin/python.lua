-- local Job = require "plenary.job"

-- local ruff_autofix = function()
--   Job:new({
--     command = "ruff",
--     args = {},
--     cwd = cwd,
--   }):sync()
-- end

require('yen3.lib.ftplugin').indention_setup(4, 119)

vim.opt.colorcolumn = '79,119'
