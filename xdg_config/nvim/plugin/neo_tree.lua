require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/kyazdani42/nvim-web-devicons" },
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
  }, { confirm = false })

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

  vim.keymap.set("n","<leader>fv", ":Neotree toggle filesystem reveal<cr>", {silent = true, desc = "Neotree" })
  -- vim.kemap.set("n", "<leader>fV", ":Neotree float filesystem reveal<cr>", { silent = true, desc = "Neotree float" })

end)

-- TODO: add it later
-- {
--   "stevearc/oil.nvim",
--   event = "VeryLazy",
--   opts = {},
--   dependencies = { "nvim-tree/nvim-web-devicons" },
-- },
