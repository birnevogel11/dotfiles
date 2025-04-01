return {
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    config = function()
      local ui = require("harpoon.ui")
      local mark = require("harpoon.mark")
      local keymap_n = require("bv11.lib.keymap").keymap_n

      keymap_n("<leader>xs", ui.toggle_quick_menu, "Harpoon: Toogle quick menu")

      keymap_n("<leader>xx", mark.add_file, "Harpoon: Add file")

      keymap_n("<S-h>", ui.nav_prev)
      keymap_n("<S-l>", ui.nav_next)
    end,
  },
}
