-- require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.*") },
  }, { confirm = false })

  require("blink.cmp").setup({
     -- See the full "keymap" documentation for information on defining your own keymap.
     keymap = {
       preset = 'default',
       ['<C-e>'] = {
         "snippet_forward",
         function()
           return require("sidekick").nes_jump_or_apply()
         end,
         function()
           return vim.lsp.inline_completion.get()
         end,
         "accept",
         "fallback",
       },
       ['<C-y>'] = { 'cancel', 'fallback' },
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
       documentation = { auto_show = true },
     },

     fuzzy = { implementation = "prefer_rust_with_warning" }
  })
-- end)
