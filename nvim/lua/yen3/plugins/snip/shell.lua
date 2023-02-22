local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local add_snippets = require("yen3.plugins.snip.luasnip").add_snippets

add_snippets("sh", {
  ["#!"] = fmt(
    "#!{}",
    c(1, {
      t("/usr/bin/env bash"),
      t("/bin/sh"),
    })
  ),
  strict = fmt("{}", c(1, {t "set -Eeuxo pipefail", t "set -eux"}))
})
