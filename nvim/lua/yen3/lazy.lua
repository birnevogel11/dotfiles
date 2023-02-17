local M = {}

local lazy_config = {
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "matchparen",
        "tar",
        "tarPlugin",
        "rrhelper",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
}

M.setup = function()
  require("lazy").setup("yen3.plugins", lazy_config)
  require("yen3.lib.keymap").keymap_n("<leader>pp", "<cmd>Lazy<cr>", "Lazy")
end

return M
