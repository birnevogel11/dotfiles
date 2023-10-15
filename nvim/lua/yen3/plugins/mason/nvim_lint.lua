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

M.setup = function()
  require("lint").linters_by_ft = {
    shell = { "shellcheck" },
    python = { "mypy" },
    dockerfile = { "hadolint" },
    markdown = { "markdownlint" },
    yaml = { "yamllint" },
  }

  hadolint_setup()
end

return M
