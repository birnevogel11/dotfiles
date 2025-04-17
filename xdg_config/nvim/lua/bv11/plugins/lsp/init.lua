local keymap_n = require("bv11.lib.keymap").keymap_n

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

local init_lsp_query_keymap = function()
  -- Show active lsp server name
  keymap_n("<leader>dp", function()
    require("bv11.lib.notify").notify("lsp status", require("bv11.plugins.lsp.lib").get_activated_lsp())
  end, "Show activated lsp")
end

local lsp_config_setup = function()
  local lsp_server = require("bv11.plugins.lsp.lsp_server")

  -- Zuul CI
  lsp_server.lsp_server_zuul_ls()

  -- Python
  lsp_server.lsp_server_ruff()
  -- lsp_server.lsp_server_sith_ls()
  -- lsp_server.lsp_server_jedi_language_server()
  -- lsp_server.lsp_server_pylsp()
  -- lsp_server.lsp_server_basedpyright()
  -- lsp_server.lsp_server_pyright()
end

local add_extra_lspconfig = function()
  local configs = require("lspconfig.configs")
  if not configs.ts_ls then
    configs.ts_ls = {
      default_config = {},
    }
  end

  if not configs.zuul_ls then
    local util = require("lspconfig.util")
    configs.zuul_ls = {
      default_config = {
        cmd = { os.getenv("HOME") .. "/Trek/zuul-ls/target/release/zuul-ls" },
        filetypes = { "yaml", "yaml.ansible" },
        root_dir = util.find_git_ancestor,
        single_file_support = true,
        settings = {},
      },
      docs = {
        description = [[ zuul language server ]],
        default_config = {
          root_dir = [[ util.find_git_ancestor ]],
        },
      },
    }
  end
end


return {
  {
    "neovim/nvim-lspconfig",
    -- event = "VeryLazy",
    dependencies = {
      { "nvim-lua/lsp-status.nvim" },
      -- {
      --   "MrcJkb/haskell-tools.nvim",
      --   branch = "1.x.x",
      -- },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      init_lsp_query_keymap()
      add_extra_lspconfig()
      lsp_config_setup()
      lsp_status_setup()
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    tag = "legacy",
    ft = { "lua", "go", "rust", "c", "cpp", "yaml", "yaml.ansible" },
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots",
        },
        align = {
          bottom = true,
        },
        window = {
          blend = 0,
          relative = "editor",
        },
      })
    end,
  },
}
