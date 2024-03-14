return {
  -- Edit
  { "tpope/vim-rhubarb", event = "VeryLazy" },
  { "tpope/vim-speeddating", event = "VeryLazy" },
  { "tpope/vim-surround", event = "VeryLazy" },
  { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },
  {
    "RRethy/nvim-treesitter-endwise",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter.configs").setup({ endwise = { enable = true } })
    end,
  },
  {
    "cappyzawa/trim.nvim",
    event = "InsertEnter",
    config = function()
      require("trim").setup({
        ft_blocklist = { "TelescopePrompt", "Trouble", "help", "bitbake" },
        trim_on_write = true,
        trim_trailing = true,
        trim_last_line = true,
        trim_first_line = false,
        -- patterns = {[[%s/\(\n\n\)\n\+/\1/]]}, -- Only one consecutive bl
      })

      -- Set traiing space highlight
      vim.cmd([[ match DiffDelete /\s\+$/ ]])
    end,
  },
  {
    "junegunn/vim-easy-align",
    event = "VeryLazy",
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      vim.cmd([[ xmap ga <Plug>(EasyAlign)]])

      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.cmd([[ nmap ga <Plug>(EasyAlign)]])
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "BufEnter",
    opts = {},
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({
        snippet_engine = "luasnip",
        languages = {
          python = {
            template = {
              annotation_convention = "reST",
            },
          },
        },
      })
      require("yen3.lib.keymap").keymap_n("<leader>wd", require("neogen").generate, "Generate annotations")
    end,
    event = "InsertEnter",
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    opts = {
      mapping = { "jk", "jj" },
      timeout = 300,
    },
  },
  {
    "ThePrimeagen/vim-be-good",
    cmd = { "VimBeGood" },
  },
  {
    "mbbill/undotree",
    event = "VeryLazy",
    keys = {
      { "<leader>fu", vim.cmd.UndotreeToggle, silent = true },
    },
  },
  {
    "godlygeek/tabular",
    event = "InsertEnter",
  },
  {
    "gabrielpoca/replacer.nvim",
    event = "VeryLazy",
    config = function()
      require("yen3.lib.keymap").keymap_n("<leader>vg", require("replacer").run, "Replace string in multiple files")
    end,
  },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = function()
      require("live-server").setup({
        args = { "--port=10089", "--browser=firefox" },
      })
    end,
    event = "VeryLazy",
  },
}
