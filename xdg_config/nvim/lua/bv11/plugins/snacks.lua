local layout_simple = {
  fullscreen = true,
  preview = false,
  layout = {
    backdrop = false,
    box = "vertical",
    border = "none",
    title = nil,
    { win = "input", height = 1, border = "none" },
    { win = "list", border = "none" },
  },
}

local layout_search = {
  preset = "ivy_split",
}

local layout_fullscreen = {
  fullscreen = true,
}


return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {},
      -- explorer = {},
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      -- bigfile = { enabled = true },
      -- dashboard = { enabled = true },
      -- indent = { enabled = true },
      -- input = { enabled = true },
      -- notifier = { enabled = true },
      -- quickfile = { enabled = true },
      -- scroll = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- words = { enabled = true },
    },
    keys = {
      { "<leader>ff", function() Snacks.picker.smart({ layout = layout_simple }) end, desc = "Smart Find files", },
      { "<leader>fm", function() Snacks.picker.recent({ layout = layout_simple }) end, desc = "Recent", },
      { "<leader>fg", function() Snacks.picker.grep({ layout = layout_search }) end, desc = "Grep", },
      -- { "<leader>fg", function() Snacks.picker.grep({ layout = layout_search }):word() end, mode = "v", desc = "Grep", },
      { "<leader>fb", function() Snacks.picker.buffers({ layout = layout_search }) end, desc = "Buffers", },
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume", },

      { "<leader>fj", function() Snacks.picker.lsp_symbols({ layout = layout_simple }) end, desc = "Tree sitter symbols", },
      { "<leader>fx", function() Snacks.picker.help({ layout = layout_search }) end, desc = "Help Pages", },
      { "<leader>fz", function() Snacks.picker.keymaps({ layout = layout_fullscreen }) end, desc = "Keymaps", },

      { "<leader>fn", function() Snacks.picker.git_status({layout = layout_search}) end, desc = "Git Status", },
      { "<leader>gc", function() Snacks.picker.git_branches({layout = layout_search}) end, desc = "Git Branches", },
    },
  },
}
