return {
  {
    'saghen/blink.cmp',
     version = 'v0.13.1',
     enabled = true,

     ---@module 'blink.cmp'
     ---@type blink.cmp.Config
     opts = {
       -- See the full "keymap" documentation for information on defining your own keymap.
       keymap = {
         preset = 'default',
         ['<C-e>'] = {'accept', 'fallback'},
       },

       signature = { enabled = true },

       sources = {
         default = { 'lsp', 'snippets', 'path', 'buffer' },
       },

       snippets = { preset = 'luasnip' },

       cmdline = { enabled = true },

       completion = {
         accept = { auto_brackets = { enabled = true }, },
         menu = { draw = { columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } }, }, },
         documentation = { auto_show = true, auto_show_delay_ms = 10},
       },

       fuzzy = { implementation = "prefer_rust_with_warning" }
     },
     opts_extend = { "sources.default" }
  }
}
