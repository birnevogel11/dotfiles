require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/folke/which-key.nvim" },
  }, { confirm = false })

  require("which-key").setup({
    ---@diagnostic disable-next-line: unused-local
    delay = function(ctx)
      return 2000
    end,
  })

  vim.keymap.set("n", "<leader>,",
    function()
      require("which-key").show({ global = false })
    end,
    { desc = "List Keymaps" })

end)
