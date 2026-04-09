local prerequired_language = {
  "bash",
  "c",
  "clojure",
  "cpp",
  "diff",
  "dockerfile",
  "dot",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "go",
  "haskell",
  "hcl",
  "html",
  "javascript",
  "json",
  "json5",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "requirements",
  "rst",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}

local M = {}

M.setup = function()
  -- set foldmethod under treesitter
  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.wo[0][0].foldmethod = 'expr'
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  vim.api.nvim_command("set nofoldenable")

  vim.api.nvim_create_user_command("TSInstallrequiredlanguage", function()
    vim.cmd("TSInstall " .. table.concat(prerequired_language, " "))
  end, { desc = "Install prerequired treesitter language" })

  local patterns = {}
  for _, parser in ipairs(prerequired_language) do
      local parser_patterns = vim.treesitter.language.get_filetypes(parser)
      for _, pp in pairs(parser_patterns) do
      table.insert(patterns, pp)
    end
  end

  vim.api.nvim_create_autocmd('FileType', {
    pattern = patterns,
    callback = function()
      vim.treesitter.start()
    end,
  })
end

return M
