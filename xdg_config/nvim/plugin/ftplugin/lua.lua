require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/folke/lazydev.nvim" },
    { src = "https://github.com/Bilal2453/luvit-meta" },
  }, { confirm = false })

  require("lazydev").setup({
    library = {
      -- Library items can be absolute paths
      -- "~/projects/my-awesome-lib",
      -- Or relative, which means they will be resolved as a plugin
      -- "LazyVim",
      -- When relative, you can also provide a path to the library in the plugin dir
      -- "luvit-meta/library", -- see below
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "lazy.nvim", words = { "LazyVim" } },
    },
  })
end)
