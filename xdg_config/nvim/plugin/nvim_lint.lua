require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/mfussenegger/nvim-lint" },
  }, { confirm = false })


  require("lint").linters_by_ft = cspell_lang_setup({
    c = { "cspell" },
    cpp = { "cspell" },
    dockerfile = { "hadolint", "cspell" },
    json = { "cspell" },
    markdown = { "markdownlint" },
    python = { "mypy", "cspell" },
    rust = { "cspell" },
    shell = { "shellcheck", "cspell" },
    yaml = { "yamllint","cspell" },
  })

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

  vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end)
