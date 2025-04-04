local Zuul = require("bv11.plugins.snacks.zuul")

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

local layout_keymap = {
  preset = "vscode",
  layout = {
    width = 0.8,
  }
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
      bigfile = {},
      gitbrowse = {},
      notifier = {},
      -- image = {},
    },
    keys = {
      -- Resume
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume", },

      -- File and search
      { "<leader>ff", function() Snacks.picker.smart({ layout = layout_simple }) end, desc = "Smart Find files", },
      { "<leader>fm", function() Snacks.picker.recent({ layout = layout_simple }) end, desc = "Recent", },
      { "<leader>fg", function() Snacks.picker.grep({ layout = layout_search }) end, desc = "Grep", },
      { "<leader>fg", function() Snacks.picker.grep_word({ layout = layout_search }) end, desc = "Visual selection or word", mode = { "v", "x" } },
      { "<leader>fb", function() Snacks.picker.buffers({ layout = layout_search }) end, desc = "Buffers", },
      { "<leader>fw", function() Snacks.picker.lines({ layout = layout_search }) end, desc = "Buffer Lines" },
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>fw", function() Snacks.picker.lines({ search=Snacks.picker:word(), layout = layout_search }) end, mode = { "v", "x" }, desc = "Buffer Lines" },
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>ft", function() Snacks.picker.todo_comments({ layout = layout_fullscreen}) end, desc = "Todo comments"},

      -- LSP
      { "<C-]", function() Snacks.picker.lsp_definitions({layout = layout_search}) end, desc = "Goto Definition" },
      { "<leader>fj", function() Snacks.picker.lsp_symbols({ layout = layout_search}) end, desc = "LSP Symbols", },
      { "<leader>fk", function() Snacks.picker.lsp_workspace_symbols({ layout = layout_search}) end, desc = "LSP Workspace Symbols", },
      { "<leader>fl", function() Snacks.picker.lsp_references({ layout = layout_search}) end, desc = "LSP References", },

      -- Neovim
      { "<leader>fx", function() Snacks.picker.help({ layout = layout_search }) end, desc = "Help Pages", },
      { "<leader>fz", function() Snacks.picker.keymaps({ layout = layout_keymap }) end, desc = "Keymaps", },
      { "<leader>fc", function() Snacks.picker.commands({ layout = layout_fullscreen }) end, desc = "Commands", },
      { "<leader>fn", function() Snacks.picker.notifications({ layout = layout_fullscreen }) end, desc = "Notifications", },

      -- Git
      { "<leader>fs", function() Snacks.picker.git_status({layout = layout_search}) end, desc = "Git Status", },
      { "<leader>gc", function() Snacks.picker.git_branches({layout = layout_search}) end, desc = "Git Branches", },

      -- Zuul
      { "<leader>zj", function() Zuul.job({layout = layout_search}) end, desc = "Zuul jobs", },
      { "<leader>zr", function() Zuul.role({layout = layout_search}) end, desc = "Zuul Roles", },
      { "<leader>zt", function() Zuul.project_template({layout = layout_search}) end, desc = "Zuul Project Templates", },
      { "<leader>zv", function() Zuul.workspace_var({layout = layout_search}) end, desc = "Zuul workspace vars", },
      { "<leader>zh", function() Zuul.job_hierarchy({layout = layout_search}) end, desc = "Zuul Job Hierarchy", mode = { "v", "x"  } },
      { "<leader>zp", function() Zuul.job_playbooks({layout = layout_search}) end, desc = "Zuul Job Playbooks", mode = { "v", "x"  } },
    },
  },
}
