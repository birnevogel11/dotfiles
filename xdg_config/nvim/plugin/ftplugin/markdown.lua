require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/kyazdani42/nvim-web-devicons" },
  }, { confirm = false })

  require("render-markdown").setup()
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/mpas/marp-nvim" },
  }, { confirm = false })

  require("marp").setup({
    port = 10088,
    wait_for_response_timeout = 30,
    wait_for_response_delay = 1,
  })
end)
