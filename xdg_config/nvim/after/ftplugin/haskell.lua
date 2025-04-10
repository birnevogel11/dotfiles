require('bv11.lib.ftplugin').indention_setup(2, 80)

local keymap_n = require('bv11.lib.keymap').keymap_n
keymap_n('<leader>dc', ':Ghcid<cr>', "Ghcid: Start", 0)
keymap_n('<leader>dC', ':GhcidKill<cr>', "Ghcid: Kill", 0)
