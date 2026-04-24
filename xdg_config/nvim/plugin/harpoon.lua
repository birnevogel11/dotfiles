require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/ThePrimeagen/harpoon" },
  }, { confirm = false })


  vim.keymap.set("n", "<leader>xs", require("harpoon.ui").toggle_quick_menu, { desc = "Harpoon: Toogle quick menu" })
  vim.keymap.set("n", "<leader>xx", require("harpoon.mark").add_file, { desc = "Harpoon: Add file" })
  vim.keymap.set("n", "<S-h>", require("harpoon.ui").nav_prev, { desc = "Harpoon: prev file" })
  vim.keymap.set("n", "<S-l>", require("harpoon.ui").nav_next, { desc = "Harpoon: next file" })
end)
