local get_buf_activated_lsp = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if next(clients) == nil then
    return nil
  end

  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end

  return client_names
end

local get_activated_lsp = function()
  local lsp_names = get_buf_activated_lsp()
  if lsp_names == nil then
    return "No Active LSP"
  end

  local info_lines = vim.fn.copy(lsp_names) or {}
  local progress = require("lsp-status").status_progress() or ""
  if progress ~= "" then
    table.insert(info_lines, progress)
  end

  return vim.fn.join(info_lines, "\n")
end


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

local lsp_server_basedpyright = function()
  vim.lsp.config('basedpyright', {
    settings = {
      single_file_support = true,
      basedpyright = {
        analysis = {
          typeCheckingMode = "off",
          diagnosticMode = "openFilesOnly",
        },
        disableOrganizeImports = true,
      },
    }
  })
end

local lsp_server_ansiblels = function()
  vim.lsp.config('ansiblels', {
    settings = {
      ansible = {
        ansible = {
          useFullyQualifiedCollectionNames = false,
        },
        validation = {
          enabled = true,
          lint = {
            enabled = true,
            path = "ansible-lint -c " .. (os.getenv("HOME") .. "/usr/rc/xdg_config/ansible-lint/ansible-lint-config.yaml"),
          },
        },
      },
    }
  })
end

local lsp_server_lua_ls = function()
  vim.lsp.config('lua_ls', {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc')) then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT'
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME
            -- Depending on the usage, you might want to add additional paths here.
            -- "${3rd}/luv/library"
            -- "${3rd}/busted/library",
          }
          -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
          -- library = vim.api.nvim_get_runtime_file("", true)
        }
      })
    end,
    settings = {
      Lua = {}
    }
  })
end

local lsp_server_zuul_ls = function()
  vim.lsp.config("zuul_ls", {
     cmd = { os.getenv("HOME") .. "/Trek/zuul-ls/target/debug/zuul-ls" },
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/lsp-status.nvim", event = "VeryLazy" },
      { "nvim-lua/plenary.nvim" },
      { "williamboman/mason.nvim" },
    },
    config = function()
      -- Configure and enable LSP servers
      vim.lsp.enable({'ruff', 'basedpyright', 'ansiblels', 'lua_ls', 'zuul_ls'})
      lsp_server_ansiblels()
      lsp_server_basedpyright()
      lsp_server_lua_ls()
      lsp_server_zuul_ls()

      -- Show active lsp server name
      vim.keymap.set('n', '<leader>dp', function() require("bv11.lib.notify").notify("lsp status", get_activated_lsp()) end, { desc = "LSP: Show activated lsp" })

      lsp_status_setup()

      -- Set inlay hint and keymap
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          -- Enable inlay hint by default
          vim.lsp.inlay_hint.enable(true)

          vim.keymap.set('n', '<leader>dk', vim.lsp.buf.signature_help, {desc = "LSP: signature help", buffer = args.buf})
          vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, {desc = "LSP: show line diagnostics", buffer = args.buf})
          vim.keymap.set("n", "<leader>ww", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, {desc = "LSP: Toogle inlay_hint"})
        end,
      })
    end
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    tag = "legacy",
    ft = { "lua", "go", "rust", "c", "cpp", "yaml", "yaml.ansible" },
    opts = {
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
    }
  },
}
