local keymap = require('yen3.lib.keymap').keymap
local keymap_n = require('yen3.lib.keymap').keymap_n
local lib_notify = require('yen3.lib.notify')

local M = {}

M.luasnip_setup = function()
  local ls = require('luasnip')
  local types = require("luasnip.util.types")

  ls.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { " <-- choiceNode", "Comment" } },
        },
      },
    },
  })

  keymap({'i', 's'}, '<c-e>', function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end)
  keymap({'i', 's'}, '<c-k>', function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end)
  keymap('i', '<c-l>', function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)
  keymap({'i', 's'}, '<c-j>', function()
    if ls.jumpable(1) then
      ls.jump(1)
    end
  end)

  vim.cmd [[ source ~/.config/nvim/lua/yen3/snip/snippets.lua ]]
  keymap_n("<leader><leader>s", function()
    vim.cmd [[  source ~/.config/nvim/lua/yen3/snip/snippets.lua  ]]
    lib_notify.notify('Luasnip', 'Souce custom snippets again.', 'info')
  end)

  -- require("luasnip.loaders.from_vscode").lazy_load()
end

M.add_snippets = function(lang, raw_snippets)
  local ls = require('luasnip')
  local s = ls.s

  local snippets = {}
  for k, v in pairs(raw_snippets) do
    table.insert(snippets, s(k, v))
  end

  ls.add_snippets(lang, snippets)
end

return M
