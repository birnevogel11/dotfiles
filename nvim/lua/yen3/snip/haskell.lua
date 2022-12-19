local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local add_snippets = require("yen3.snip.luasnip").add_snippets

add_snippets("haskell", {
  lang = fmt("{{-# LANGUAGE {} #-}}", { i(1) }),

  imp = fmt("import {}", { i(1) }),
  impq = fmt("import qualified {} as {}", { i(1), i(2) }),
  imps = fmt("import {} ({})", { i(1), i(2) }),
})
