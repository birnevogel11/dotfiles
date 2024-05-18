local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local add_snippets = require("bv11.plugins.snip.luasnip").add_snippets

add_snippets("all", {
  todo = {
    c(1, {
      t("TODO(bv11): "),
      t("FIXME(bv11): "),
    }),
  },
  dnm = t("# DON'T MERGE IT"),
})
