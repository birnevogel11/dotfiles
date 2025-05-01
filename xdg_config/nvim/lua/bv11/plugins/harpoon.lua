return {
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    config = function()
      require("which-key").add({
        { "<leader>xs", require("harpoon.ui").toggle_quick_menu, desc = "Harpoon: Toogle quick menu" },
        { "<leader>xx", require("harpoon.mark").add_file, desc = "Harpoon: Add file" },
        { "<S-h>", require("harpoon.ui").nav_prev, desc = "Harpoon: prev file" },
        { "<S-l>", require("harpoon.ui").nav_next, desc = "Harpoon: next file" },
      })
    end
  },
}
