local extend_conform_lint_args = function(name, extra_args)
  local util = require("conform.util")
  local linter = require("conform.formatters." .. name)
  require("conform").formatters[name] = vim.tbl_deep_extend("force", linter, {
    args = util.extend_args(linter.args, extra_args),
    range_args = util.extend_args(linter.range_args, extra_args),
  })
end

local autocmd_format_before_write = function()
  local confrom_ft = {"*.clj"}
  -- Skip .py if NVIM_DISABLE_BLACK_FORMAT is set
  if vim.env.NVIM_DISABLE_BLACK_FORMAT == nil then
    table.insert(confrom_ft, "*.py")
  end
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("bv11_ConformFormat", { clear = true }),
    pattern = confrom_ft,
    callback = function(args)
      require("conform").format({ bufnr = args.buf })
    end,
  })
end

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim" },
  }, { confirm = false })

  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
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
      clojure = { "cljfmt" },
    },
  })

  -- extend_conform_lint_args("black", { "-l", os.getenv("NVIM_PY_BLACK_WIDTH") or "119" })
  extend_conform_lint_args("shfmt", { "-i", "2", "-ci" })
  extend_conform_lint_args("stylua", { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "120" })
  -- extend_conform_lint_args("ruff_format", { "--line-length", "119"})

  autocmd_format_before_write()
end)

-- require("beaver.lazyload").on_vim_enter(function()
--   vim.pack.add({
--     { src = "https://github.com/stevearc/conform.nvim" },
--   })
-- end)
