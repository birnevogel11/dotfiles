require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/chrisgrieser/nvim-puppeteer" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  }, { confirm = false })
end)
