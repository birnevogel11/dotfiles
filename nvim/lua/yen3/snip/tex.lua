local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local add_snippets = require("yen3.snip.luasnip").add_snippets

add_snippets("tex", {
  be = fmt([[
    \begin{{{}}}
      {}
    \end{{{}}}
  ]], {i(1), i(2), rep(1)}),
  its = fmt([[
    \begin{{itemize}}
      \item {}
    \end{{itemize}}
  ]], {i(1)}),
  it = fmt([[
      \item {}
  ]], {i(1)}),
  sens = fmt([[
    \begin{{sens}}
      \sen{}{}
    \end{{sens}}
  ]], {i(1), i(2)}),
  se = fmt([[
    \sen{}{}
  ]], {i(1), i(2)}),
})
