local M = {}

local disable_builtin_plugins = {
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
}

M.setup = function()
  require("lazy").setup("yen3.plugins", {
    performance = {
      rtp = {
        disabled_plugins = disable_builtin_plugins,
      },
    },
  })
  require("yen3.lib.keymap").keymap_n("<leader>pp", "<cmd>Lazy<cr>", "Lazy")
end

return M
