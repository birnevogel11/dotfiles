require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/emrearmagan/atlas.nvim" },
  }, { confirm = false })

  require("atlas").setup({
    pulls = {
      providers = {
        github = {},
      },
    },
    issues = {
      providers = {
        github = {},
      },
    },
  })
end)
