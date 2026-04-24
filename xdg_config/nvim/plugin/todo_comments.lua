require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/folke/todo-comments.nvim" },
  }, { confirm = false })

  require("todo-comments").setup({})
end)
