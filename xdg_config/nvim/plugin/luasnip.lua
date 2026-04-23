require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/L3MON4D3/LuaSnip" },
  }, { confirm = false })

  local ls = require("luasnip")
  local types = require("luasnip.util.types")

  ls.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { " «««  ", "Comment" } },
        },
      },
    },
  })

  -- Source all snaips
  require("beaver.source_snips")

  vim.keymap.set({ "i", "s" }, "<c-e>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end)
  vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end)
  vim.keymap.set("i", "<c-l>", function()
    if ls.choice_active() then
      require("luasnip.extras.select_choice")()
      -- ls.change_choice(1)
    end
  end)
  vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if ls.jumpable(1) then
      ls.jump(1)
    end
  end)

  -- vim.keymap.set("n", "<leader>il", function()
  --   require("beaver.snips").source_snippets()
  --   require("bv11.lib.notify").notify("Luasnip", "Souce custom snippets again.", "info")
  -- end, { desc = "Luasnip: Source snippets again" })
end)
