local config_util = require('yen3.util.config')
local ftplugin_util = require('yen3.util.ftplugin')

-- Setup indention
ftplugin_util.indention_setup(4, 119)

-- Setup color column
vim.opt_local.colorcolumn = '80,119'

-- Setup black keymap
config_util.lua_key_map(bufnr, 'n', '<leader>bb',  "require('yen3.plugin').python_black_format()")
