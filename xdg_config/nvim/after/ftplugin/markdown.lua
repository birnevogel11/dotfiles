-- require('bv11.lib.ftplugin').indention_setup(4, 80)
vim.wo.spell = true

local keymap_n = require("bv11.lib.keymap").keymap_n
keymap_n("<leader>wc", "<cmd>:RenderMarkdown toggle<cr>", "Toggle render markdown")
