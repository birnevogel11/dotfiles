require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/mtdl9/vim-log-highlighting" },
  }, { confirm = false })
end)
