require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/Glench/Vim-Jinja2-Syntax" },
  }, { confirm = false })
end)
