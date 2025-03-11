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
      picker = {
        formatters = {
          file = {
            truncate = 120,
          }
        }
      },
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
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume", },

      { "<leader>ff", function() Snacks.picker.smart({ layout = layout_simple }) end, desc = "Smart Find files", },
      { "<leader>fm", function() Snacks.picker.recent({ layout = layout_simple }) end, desc = "Recent", },
      { "<leader>fg", function() Snacks.picker.grep({ layout = layout_search }) end, desc = "Grep", },
      { "<leader>fg", function() Snacks.picker.grep_word({ layout = layout_search }) end, desc = "Visual selection or word", mode = { "v", "x" } },
      { "<leader>fb", function() Snacks.picker.buffers({ layout = layout_search }) end, desc = "Buffers", },
      { "<leader>fw", function() Snacks.picker.lines({ layout = layout_search }) end, desc = "Buffer Lines" },
      { "<leader>fw", function() Snacks.picker.lines({ search=Snacks.picker:word(), layout = layout_search }) end, mode = { "v", "x" }, desc = "Buffer Lines" },

      { "<C-]", function() Snacks.picker.lsp_definitions({layout = layout_search}) end, desc = "Goto Definition" },
      { "<leader>fj", function() Snacks.picker.lsp_symbols({ layout = layout_search}) end, desc = "LSP Symbols", },
      { "<leader>fk", function() Snacks.picker.lsp_workspace_symbols({ layout = layout_search}) end, desc = "LSP Workspace Symbols", },
      { "<leader>fl", function() Snacks.picker.lsp_references({ layout = layout_search}) end, desc = "LSP References", },

      { "<leader>fx", function() Snacks.picker.help({ layout = layout_search }) end, desc = "Help Pages", },
      { "<leader>fz", function() Snacks.picker.keymaps({ layout = layout_fullscreen }) end, desc = "Keymaps", },
      { "<leader>fe", function() Snacks.picker.commands({ layout = layout_fullscreen }) end, desc = "Commands", },

      { "<leader>fn", function() Snacks.picker.git_status({layout = layout_search}) end, desc = "Git Status", },
      { "<leader>gc", function() Snacks.picker.git_branches({layout = layout_search}) end, desc = "Git Branches", },
    },
  },
}
