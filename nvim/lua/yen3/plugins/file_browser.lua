return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    after = { "nui.nvim" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        "s1n7ax/nvim-window-picker",
        version = "v1.*",
        main = "window-picker",
        opts = {
          autoselect_one = true,
          include_current = false,
          filter_rules = {
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify" },

              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal", "quickfix" },
            },
          },
          other_win_hl_color = "#e35e4f",
        },
      },
    },
    opts = {
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "toggle_node",
          ["l"] = "open",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["h"] = "close_node",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["R"] = "refresh",
          ["/"] = "fuzzy_finder",
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["a"] = "add",
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy", -- takes text input for destination
          ["m"] = "move", -- takes text input for destination
          ["q"] = "close_window",
        },
      },
      filesystem = {
        filtered_items = {
          never_show = { -- remains hidden even if visible is toggled to true
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
    },
    keys = {
      { "<leader>fv", ":Neotree toggle filesystem reveal<cr>", silent = true },
      { "<leader>fV", ":Neotree float filesystem reveal<cr>", silent = true },
    },
  },
}
