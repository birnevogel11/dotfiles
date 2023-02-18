local M = {}

M.setup = function()
  require("lazy").setup("yen3.plugins",
    {
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
  )
  require("yen3.lib.keymap").keymap_n("<leader>pp", "<cmd>Lazy<cr>", "Lazy")
end

return M
