return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      { "kyazdani42/nvim-web-devicons" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/popup.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      { "nvim-telescope/telescope-frecency.nvim", dependencies = { "tami5/sql.nvim" } },
      { "octarect/telescope-menu.nvim" },
      -- { "psiska/telescope-hoogle.nvim", ft = "haskell" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "luckasRanarison/nvim-devdocs" },
      -- { "nvim-telescope/telescope-github.nvim" },
      -- { "AckslD/nvim-neoclip.lua", dependencies = { { "tami5/sqlite.lua", module = "sqlite" } } },
      -- { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = require("yen3.plugins.search.base").telescope.setup,
    -- keys = {
    --   "<leader>fG",
    --   "<leader>fd",
    --   "<leader>fdd",
    --   "<leader>ff",
    --   "<leader>fg",
    --   "<leader>fb",
    --   "<leader>fm",
    --   "<leader>fn",
    --   "<leader>fs",
    --   "<leader>fu",
    --   "<leader>fx",
    --   "<leader>fz",
    -- }
  },
}
