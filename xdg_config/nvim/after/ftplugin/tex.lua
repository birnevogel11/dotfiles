local cmp = require("cmp")

require('bv11.lib.ftplugin').indention_setup(2, 119)

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

-- <leader>ll - Compile and open skim in macOS
-- <leader>lv - Open skim in macOS
