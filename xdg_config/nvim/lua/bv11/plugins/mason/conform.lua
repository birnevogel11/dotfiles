local M = {}

local extend_conform_lint_args = function(name, extra_args)
  local util = require("conform.util")
  local linter = require("conform.formatters." .. name)
  require("conform").formatters[name] = vim.tbl_deep_extend("force", linter, {
    args = util.extend_args(linter.args, extra_args),
    range_args = util.extend_args(linter.range_args, extra_args),
  })
end

M.setup = function()
  require("conform").setup({
    formatters_by_ft = {
      -- lua = { "stylua" },
      python = {
        -- "black",
        "ruff_fix", -- To fix lint errors. (ruff with argument --fix)
        "ruff_format", -- To run the formatter. (ruff with argument format)
      },
      shell = { "shfmt" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      vue = { "prettier" },
    },
  })

  extend_conform_lint_args("black", { "-l", os.getenv("NVIM_PY_BLACK_WIDTH") or "119" })
  extend_conform_lint_args("shfmt", { "-i", "2", "-ci" })
  extend_conform_lint_args("stylua", { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "120" })

  require("bv11.lib.keymap").keymap_n("<leader>bb", require("conform").format, "Format the buffer")
end

return M
