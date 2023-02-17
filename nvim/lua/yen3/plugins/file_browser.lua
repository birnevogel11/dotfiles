local keymap_n = require("yen3.lib.keymap").keymap_n

local neotree_nvim_setup = function()
  require("neo-tree").setup({
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
  })

  keymap_n("<leader>fv", ":NeoTreeRevealToggle<cr>", "Neotree toggle")
  keymap_n("<leader>fV", ":Neotree float<cr>", "Neotree float")
end

return {
  -- File browser
  { "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    after = { "nui.nvim" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Neotree", "NeoTreeFocusToggle", "NeoTreeRevealToggle" },
    keys = { "<leader>fv", "<leader>fV" },
    config = function() neotree_nvim_setup() end,
  },
}
