require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/jceb/jiejie.nvim" },
  }, { confirm = false })
end)
