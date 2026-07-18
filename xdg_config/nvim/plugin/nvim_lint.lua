require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/mfussenegger/nvim-lint" },
  }, { confirm = false })


  require("lint").linters_by_ft = {
    dockerfile = { "hadolint"  },
    markdown = { "markdownlint" },
    -- python = { "mypy" },
    shell = { "shellcheck" },
    yaml = { "yamllint" },
  }

  -- TODO: Move it to global config
  require("lint").linters.hadolint.args = {
    "--ignore", "DL3003",
    "--ignore", "DL3008",
    "--ignore", "DL3009",
    "--ignore", "DL3013",
    "--ignore", "DL3015",
    "--ignore", "DL3018",
    "--ignore", "DL3027",
    "--ignore", "DL3047",
    "--ignore", "DL4006",
    "-f", "json",
    "-",
  }

  require("lint").linters.markdownlint.args = {
    "--disable", "MD013", -- Line length
    "--disable", "MD007", -- Indentation
    "--stdin",
    "-",
  }

  vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end)
