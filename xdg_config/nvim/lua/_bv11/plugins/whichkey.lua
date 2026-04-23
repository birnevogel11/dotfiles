return {

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@class wk.Opts
    opts = {
      ---@diagnostic disable-next-line: unused-local
      delay = function(ctx)
        return 2000
      end,
    },
    keys = {
      {
        "<leader>,",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

}
