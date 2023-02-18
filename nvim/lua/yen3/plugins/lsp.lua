local lsp_status_setup = function()
  local nvim_status = require("lsp-status")

  nvim_status.config({
    select_symbol = function(cursor_pos, symbol)
      if symbol.valueRange then
        local value_range = {
          ["start"] = {
            character = 0,
            line = vim.fn.byte2line(symbol.valueRange[1]),
          },
          ["end"] = {
            character = 0,
            line = vim.fn.byte2line(symbol.valueRange[2]),
          },
        }

        return require("lsp-status.util").in_range(cursor_pos, value_range)
      end
    end,
    spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  })

  nvim_status.register_progress()
end

return {
  { "neovim/nvim-lspconfig",
    event = "BufRead",
    dependencies = {
      { "nvim-lua/lsp-status.nvim" },
      { "MrcJkb/haskell-tools.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("yen3.lsp").lsp_config_setup()
      lsp_status_setup()
    end,
  },
  { "j-hui/fidget.nvim", ft = {"lua", "go", "rust"},
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots",
        },
        align = {
          bottom = true,
        },
        window = {
          relative = "editor",
        },
      })
    end
  },
}
