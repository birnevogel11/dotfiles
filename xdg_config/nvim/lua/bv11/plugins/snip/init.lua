local keymap = require("bv11.lib.keymap").keymap
local keymap_n = require("bv11.lib.keymap").keymap_n
local lib_notify = require("bv11.lib.notify")

local source_snippets_again = function()
  require("bv11.plugins.snip.luasnip").source_snippets()
  lib_notify.notify("Luasnip", "Souce custom snippets again.", "info")
end

local luasnip_setup = function()
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
  require("bv11.plugins.snip.luasnip").source_snippets()

  keymap({ "i", "s" }, "<c-e>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end)
  keymap({ "i", "s" }, "<c-k>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end)
  keymap("i", "<c-l>", function()
    if ls.choice_active() then
      require("luasnip.extras.select_choice")()
      -- ls.change_choice(1)
    end
  end)
  keymap({ "i", "s" }, "<c-j>", function()
    if ls.jumpable(1) then
      ls.jump(1)
    end
  end)
  keymap_n("<leader>il", source_snippets_again, "Luasnip: Source snippets again")
end

return {
  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = "L3MON4D3/LuaSnip",
    after = { "nvim-cmp" },
    event = "VeryLazy",
    config = luasnip_setup,
  },
}
