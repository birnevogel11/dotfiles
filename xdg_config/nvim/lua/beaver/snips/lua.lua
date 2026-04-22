local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local add_snippets = require("bv11.plugins.snip.luasnip").add_snippets

add_snippets("lua", {
  req = fmt("local {} = require('{}')", {
    f(function(import_name)
      local parts = vim.split(import_name[1][1], ".", true)
      return parts[#parts] or ""
    end, { 1 }),
    i(1),
  }),
  lf = fmt("local {} = function() {} end", { i(1), i(2) }),
  mf = fmt("M.{} = function() {} end", { i(1), i(2) }),
  fori = fmt(
    [[
      for _, {} in ipairs({}) do
        {}
      done
    ]],
    { i(2, "v"), i(1), i(3) }
  ),
  ["for"] = fmt(
    [[
      for {}, {} in pairs({}) do
        {}
      done
    ]],
    { i(2, "k"), i(3, "v"), i(1), i(4) }
  ),
  ["lazyload"] = fmt(
    [[
      require("beaver.lazyload").on_vim_enter(function()
        vim.pack.add({{
          {{ src = "https://github.com/{}" }},
        }})

        {}
      end)
    ]],
    { i(1), i(2) }
  ),
})
