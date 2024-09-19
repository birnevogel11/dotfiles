local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local add_snippets = require("bv11.plugins.snip.luasnip").add_snippets

add_snippets("python", {
  ["#!"] = t("#!/usr/bin/env python3"),
  ifm = fmt(
    [[
      def main() -> None:
          print("Hello, world!")
          {}


      if __name__ == "__main__":
          main()
    ]],
    { i(1) }
  ),

  noqa = fmt("# noqa: {}", { i(1) }),
  type_ignore = t("# type: ignore"),
  pl = t("# pylint: disable="),

  logger = fmt("logger = logging.getLogger(__name__)", {}),
  loggerpl = fmt("logger = logging.getLogger(__name__){}", { c(1, { t(""), t("  # pylint: disable=invalid-name") }) }),
  logformat = t(
    'logging.basicConfig(level=logging.INFO, format="[%(asctime)s][%(levelname)-5.5s][%(name)s] %(message)s")'
  ),
  stderrlogformat = t(
    'logging.basicConfig(stream=sys.stderr, level=logging.INFO, format="[%(asctime)s][%(levelname)-5.5s][%(name)s] %(message)s")'
  ),
  li = fmt("logger.info({})", { i(1) }),
  le = fmt("logger.error({})", { i(1) }),
  lw = fmt("logger.warning({})", { i(1) }),
  lx = fmt("logger.exception({})", { i(1) }),
  ld = fmt("logger.debug({})", { i(1) }),

  rn = t("raise NotImplementedError()"),
  rr = fmt('raise RuntimeError("{}")', i(1)),
  rv = fmt('raise ValueError("{}")', i(1)),

  pmp = fmt('@pytest.mark.parametrize("{}",[{}])', { i(1), i(2) }),
  pmp2 = fmt(
    [[
      @pytest.mark.parametrize("{}",[{}])
      def test_{}({}) -> None:
          {}
    ]],
    {
      i(1),
      i(2),
      i(3, "default"),
      f(function(arg)
        ---@diagnostic disable-next-line: param-type-mismatch
        return vim.fn.join(vim.split(arg[1][1], ",", true) or {}, ", ")
      end, { 1 }),
      i(5),
    }
  ),

  il = t("import logging"),
  id = t("import dataclasses"),
  fp = t("from pathlib import Path"),
  ft = fmt("from typing import {}", { i(1) }),
  fu = t("from unittest.mock import MagicMock, patch"),
  fa = t("from __future__ import annotations"),

  dbg = fmt(
    [[
      # fmt: off
      # TODO(bv11): remove the debug code
      import pudb; print('bv11-debug: Start debug');
      pudb.set_trace()
      # fmt: on
    ]],
    {}
  ),
  dbgr = fmt(
    [[
      # fmt: off
      # TODO(bv11): remove the debug code
      logger.info("bv11-debug: start remote pudb 6899")
      from pudb.remote import set_trace
      set_trace(term_size=({}, {}), host="0.0.0.0")
      # fmt: on
      {}
    ]],
    {
      f(function()
        return tostring(vim.o.columns)
      end),
      f(function()
        return tostring(vim.o.lines)
      end),
      i(3),
    }
  ),
  dbgpy = fmt([[
    import debugpy
    debugpy.breakpoint()
  ]], {}),
  pp = fmt("__import__('pprint').pprint({})", { i(1) }),
  pf = fmt("__import__('pprint').pformat({})", { i(1) }),
})
