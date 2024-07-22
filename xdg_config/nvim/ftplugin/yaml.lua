local util = require("lspconfig.util")

vim.lsp.start({
  name = "zuul-ls-study",
  cmd = { "/home/yen3/Trek/zuul-ls/target/debug/zuul-ls" },
  root_dir = util.find_git_ancestor(),
})
