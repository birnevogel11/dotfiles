local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local add_snippets = require("beaver.snips").add_snippets

add_snippets("rust", {
  -- std
  pl = fmt('println!("{1}: {2}", {3});', { i(1), t({ "{:#?}" }), i(2) }),

  -- env_logger
  ul = t("use log;"),
  ld = fmt('log::debug!("{1}: {2}", {3});', { i(1), t({ "{:#?}" }), i(2) }),
  li = fmt('log::info!("{1}: {2}", {3});', { i(1), t({ "{:#?}" }), i(2) }),
  le = fmt('log::error!("{1}: {2}", {3});', { i(1), t({ "{:#?}" }), i(2) }),
})
