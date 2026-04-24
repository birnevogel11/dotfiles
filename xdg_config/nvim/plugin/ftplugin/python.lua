require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/chrisgrieser/nvim-puppeteer" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  }, { confirm = false })
end)

-- require("beaver.lazyload").on_vim_enter(function()
--   vim.pack.add({
--     { src = "https://github.com/MeanderingProgrammer/py-requirements.nvim" },
--     { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
--   })
--   require('py-requirements').setup({
--     file_patterns = { 'requirements.txt', 'constraints.in' },
--   })
-- end)
