return {
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    config = function()
      local ui = require("harpoon.ui")
      local mark = require("harpoon.mark")
      local keymap_n = require("yen3.lib.keymap").keymap_n

      -- keymap_n("<leader>ss", ui.toggle_quick_menu)
      --
      -- keymap_n("<leader>sa", mark.add_file)
      --
      -- keymap_n("<S-h>", ui.nav_prev)
      -- keymap_n("<S-l>", ui.nav_next)
    end,
  },
}
