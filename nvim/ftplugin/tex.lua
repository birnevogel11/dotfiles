local cmp = require("cmp")

require('yen3.lib.ftplugin').indention_setup(2, 119)

cmp.setup.filetype('tex', {
  sources = cmp.config.sources({
      { name = 'omni' },
      { name = 'buffer' },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      { name = "tmux" },
    })
})
