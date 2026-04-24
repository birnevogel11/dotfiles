local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local add_snippets = require("beaver.snips").add_snippets

add_snippets("markdown", {
  meta = fmt(
    [[
      ---
      date: {}
      ---
      {}
    ]],
    {
      f(function()
        return vim.fn.strftime("%Y-%m-%d")
      end),
      i(2),
    }
  ),
  meta_todo = fmt(
    [[
      ---
      start_date: {}
      end_date: TBD
      ---
      {}
    ]],
    {
      f(function()
        return vim.fn.strftime("%Y-%m-%d")
      end),
      i(2),
    }
  ),
})
