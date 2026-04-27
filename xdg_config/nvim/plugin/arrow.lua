require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/otavioschwanck/arrow.nvim" },
  }, { confirm = false })

  require("arrow").setup({
    show_icons = true,
    leader_key = ";",
    buffer_leader_key = "m",
    always_show_path = true,
  })

  vim.keymap.set("n", "<C-s>", require("arrow.persist").toggle, { desc = "Arrow: Toogle quick menu" })
  vim.keymap.set("n", "H", require("arrow.persist").previous, { desc = "Harpoon: prev file" })
  vim.keymap.set("n", "L", require("arrow.persist").next, { desc = "Harpoon: next file" })
end)
