return {
  -- The config is in lua/bv11/plugins/lsp/lsp_server.lua
  { "vxpm/ferris.nvim", opts = {}, ft = { "rust" } },
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
}
