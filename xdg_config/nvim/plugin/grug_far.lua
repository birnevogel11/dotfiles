require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/MagicDuck/grug-far.nvim" },
  }, { confirm = false })

  require("grug-far").setup()
  vim.keymap.set("n", "<leader>wo", "<cmd>GrugFar<cr>", { silent = true, desc = "Replace string in multiple files" })
end)
