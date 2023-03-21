return {
  -- Search
  -- { "junegunn/fzf", build = "./install --all", event = "BufReadPost" }

  { "nvim-telescope/telescope.nvim",
    dependencies = {
      { "kyazdani42/nvim-web-devicons" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/popup.nvim" },
      { 'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      },
      { "nvim-telescope/telescope-frecency.nvim", dependencies = { "tami5/sql.nvim" } },
      { "octarect/telescope-menu.nvim" },
      { "psiska/telescope-hoogle.nvim", ft = "haskell" },
      -- { "nvim-telescope/telescope-fzy-native.nvim" },
      -- { "nvim-telescope/telescope-github.nvim" },
      -- { "AckslD/nvim-neoclip.lua", dependencies = { { "tami5/sqlite.lua", module = "sqlite" } } },
      -- { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
      require("yen3.plugins.search.base").telescope.setup()
    end,
    -- keys = {
    --   "<leader>fG",
    --   "<leader>fd",
    --   "<leader>fdd",
    --   "<leader>ff",
    --   "<leader>fg",
    --   "<leader>fm",
    --   "<leader>fn",
    --   "<leader>fs",
    --   "<leader>fu",
    --   "<leader>fx",
    --   "<leader>fx",
    -- }
  },
}
