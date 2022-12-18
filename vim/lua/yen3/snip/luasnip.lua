local keymap = require("yen3.lib.keymap").keymap
local keymap_n = require("yen3.lib.keymap").keymap_n
local lib_notify = require("yen3.lib.notify")

local M = {}

local snippet_files = {
  "all.lua",
  "dockerfile.lua",
  "haskell.lua",
  "lua.lua",
  "python.lua",
}

local source_snippets = function()
  for _, name in ipairs(snippet_files) do
    vim.cmd("source ~/.config/nvim/lua/yen3/snip/" .. name)
  end
end

M.source_snippets_again = function()
  source_snippets()
  lib_notify.notify("Luasnip", "Souce custom snippets again.", "info")
end

M.luasnip_setup = function()
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
  source_snippets()

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
  keymap_n("<leader>es", M.source_snippets_again, "Luasnip: Source snippets again")
end

M.add_snippets = function(lang, raw_snippets)
  local ls = require("luasnip")
  local s = ls.s

  local snippets = {}
  for k, v in pairs(raw_snippets) do
    table.insert(snippets, s(k, v))
  end

  ls.add_snippets(lang, snippets)
end

return M
