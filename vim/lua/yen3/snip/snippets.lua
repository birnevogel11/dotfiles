local ls = require('luasnip')
local s = ls.s
local fmt = require('luasnip.extras.fmt').fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require('luasnip.extras').rep
local add_snippets = require('yen3.snip.luasnip').add_snippets

add_snippets("lua", {
  req = fmt("local {} = require('{}')", {
   f(function(import_name)
    local parts = vim.split(import_name[1][1], ".", true)
    return parts[#parts] or ""
   end, {1}),
   i(1),
  })
})

add_snippets("haskell", {
  imp = fmt("import {}", { i(1) }),
  impq = fmt("import qualified {} as {}", { i(1), i(2) }),
  imps = fmt("import {} ({})", {i(1), i(2)}),
  lang = fmt("{{-# LANGUAGE {} #-}}", {i(1)}),
})

add_snippets("python", {
  ifm = fmt([[
          def main() -> None:
              {}

          if __name__ == "__main__":
              main()
      ]], {i(1)}),

  logger = fmt("logger = logging.getLogger(__name__){}", {c(1, {t "", t "  # pylint: disable=invalid-name"})}),
  logformat = fmt("logging.basicConfig(level=logging.INFO, format=\"[%(asctime)s][%(levelname)-5.5s][%(name)s] %(message)s\"){}", {i(1)}),
  logi = fmt("logger.info({})", {i(1)}),
  loge = fmt("logger.error({})", {i(1)}),
  logw = fmt("logger.warning({})", {i(1)}),
  logx = fmt("logger.exception({})", {i(1)}),
  logd = fmt("logger.debug({})", {i(1)}),

  rnie = fmt("raise NotImplementedError({}){}", {i(1), i(2)}),

  pmp =
    fmt([[
      @pytest.mark.parametrize("{}",[{}])
      def test_{}({}) -> None:
          {}
    ]],
      {
        i(1),
        i(2),
        i(3, "default"),
        f(function(arg) return vim.fn.join(vim.split(arg[1][1], ",", true)or {}, ", ") end, {1}),
        i(5),
      }),
  pmp2 = fmt('@pytest.mark.parametrize("{}",[{}])', {i(1), i(2)}),

  il = fmt("import logging", {}),
  fp = fmt("from pathlib import Path", {}),
  ft = fmt("from typing import {}", {i(1)}),
  fu = fmt("from unitest.mock import patch", {}),

  dbg = fmt("import pudb; print('yen3-debug: Start debug'); pudb.set_trace(){}", {i(1)}),
  dbgr =
    fmt([[
      logger.info("yen3-debug: start remote pudb 6899"),
      from pudb.remote import set_trace; set_trace(term_size=({}, {}), host='0.0.0.0')"
      {}
    ]],
      { f(function() return tostring(vim.o.columns) end),
        f(function() return tostring(vim.o.lines) end),
        i(3),
      }
    ),
})
