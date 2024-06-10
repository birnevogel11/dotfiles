return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      -- dependencies
      { "kyazdani42/nvim-web-devicons" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/popup.nvim" },

      -- Plugins
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      { "octarect/telescope-menu.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "homerours/jumper.nvim" },

      -- Persoanl plugins
      { dir = "~/usr/rc/xdg_config/nvim/local_plugins/telescope-zuul-search.nvim" },
      { dir = "~/usr/rc/xdg_config/nvim/local_plugins/telescope-bv11-jumper.nvim" },

      -- { "psiska/telescope-hoogle.nvim", ft = "haskell" },
      -- { "luckasRanarison/nvim-devdocs" },
      -- { "nvim-telescope/telescope-github.nvim" },
      -- { "AckslD/nvim-neoclip.lua", dependencies = { { "tami5/sqlite.lua", module = "sqlite" } } },
      -- { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = require("bv11.plugins.search.base").telescope.setup,
  },
}
