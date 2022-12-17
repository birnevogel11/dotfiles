local lib_ftplugin = require('yen3.lib.ftplugin')
local lib_keymap = require('yen3.lib.keymap')
local sunsetshiba_color = require('yen3.sunsetshiba')

local M = {}

local ghcid_setup = function()
  lib_keymap.buf_map_n(0, '<leader>dc', ':Ghcid<cr>')
  lib_keymap.buf_map_n(0, '<leader>dC', ':GhcidKill<cr>')
end

M.setup = function()
  lib_ftplugin.indention_setup(2, 80)
  sunsetshiba_color.ftplugin.haskell()

  ghcid_setup()
end

M.setup()
