local M = {}

local hadolint_setup = function()
  require("lint").linters.hadolint.args = {
    "--ignore",
    "DL3003",
    "--ignore",
    "DL3008",
    "--ignore",
    "DL3009",
    "--ignore",
    "DL3013",
    "--ignore",
    "DL3015",
    "--ignore",
    "DL3018",
    "--ignore",
    "DL3027",
    "--ignore",
    "DL3047",
    "--ignore",
    "DL4006",
    "-f",
    "json",
    "-",
  }
end

local cspell_lang_setup = function(linters)
  local languages = {
    "c",
    "cpp",
    "dockerfile",
    "json",
    "python",
    "rust",
    "shell",
    "yaml",
  }

  for _, name in pairs(languages) do
    if not linters[name] then
      linters[name] = { "cspell" }
    end
    if not vim.tbl_contains(linters[name], "cspell") then
      table.insert(linters[name], "cspell")
    end
  end

  return linters
end

M.setup = function()
  require("lint").linters_by_ft = cspell_lang_setup({
    shell = { "shellcheck" },
    python = { "mypy" },
    dockerfile = { "hadolint" },
    -- markdown = { "markdownlint" },
    yaml = { "yamllint" },
  })

  hadolint_setup()

  vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end

return M
