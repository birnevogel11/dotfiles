local M = {}

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
