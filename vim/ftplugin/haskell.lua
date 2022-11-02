local ftplugin_util = require('yen3.util.ftplugin')
local config_util = require('yen3.util.config')
local sunsetshiba_color = require('yen3.sunsetshiba')

local M = {}

local ghcid_setup = function()
  config_util.buf_map_n(0, '<leader>dc', ':Ghcid<cr>')
  config_util.buf_map_n(0, '<leader>dC', ':GhcidKill<cr>')
end

M.setup = function()
  ftplugin_util.indention_setup(2, 80)
  sunsetshiba_color.ftplugin.haskell()

  ghcid_setup()
end

M.setup()
