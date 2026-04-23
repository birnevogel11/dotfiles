require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.*") },
  }, { confirm = false })

  require("blink.cmp").setup({
     -- See the full "keymap" documentation for information on defining your own keymap.
     keymap = {
       preset = 'default',
       -- ['<C-e>'] = {'accept', 'fallback'},
       ["<C-e>"] = {
          function(cmp)
              if vim.b[vim.api.nvim_get_current_buf()].nes_state then
                  cmp.hide()
                  return (
                      require("copilot-lsp.nes").apply_pending_nes()
                      and require("copilot-lsp.nes").walk_cursor_end_edit()
                  )
              end
              if cmp.snippet_active() then
                  return cmp.accept()
              else
                  return cmp.select_and_accept()
              end
          end,
          "snippet_forward",
          "accept",
          "fallback",
        },
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
end)
