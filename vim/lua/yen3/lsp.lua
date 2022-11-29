local config_util = require("yen3.util.config")
local config_local = require("yen3.local")
local nvim_lsp = require("lspconfig")
local nvim_status = require('lsp-status')
local lsp_selection_range = require('lsp-selection-range')

local buf_map_n = config_util.buf_map_n
local buf_map_call_n = config_util.buf_map_call_n

local M = {
  lsp_server = {},
}

local custom_update_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("keep", capabilities, nvim_status.capabilities)
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  return lsp_selection_range.update_capabilities(capabilities)
end

local lsp_lspsaga_keymap = function(bufnr)
  buf_map_n(bufnr, 'K',          '<cmd>Lspsaga hover_doc<cr>')
  buf_map_n(bufnr, '<leader>dr', '<cmd>Lspsaga rename<cr>')
  buf_map_n(bufnr, '<leader>ds', '<cmd>Lspsaga signature_help<cr>')
  buf_map_n(bufnr, '<leader>dd', '<cmd>Lspsaga peek_definition<cr>')
  buf_map_n(bufnr, '<leader>da', '<cmd>Lspsaga code_action<cr>')
  buf_map_n(bufnr, 'go',         '<cmd>Lspsaga show_line_diagnostics<cr>')
  buf_map_n(bufnr, "gj",         "<cmd>Lspsaga diagnostic_jump_next<cr>")
  buf_map_n(bufnr, "gk",         "<cmd>Lspsaga diagnostic_jump_prev<cr>")
  buf_map_n(bufnr, "<leader>tb", "<cmd>LSoutlineToggle<cr>")

  buf_map_call_n(bufnr, '<leader>dv', lsp_selection_range.trigger)
  config_util.buf_map_call(bufnr, 'v', '<leader>dv', lsp_selection_range.expend)
end

local lsp_keymap = function(bufnr)
  lsp_lspsaga_keymap(bufnr)

  -- lsp format
  buf_map_call_n(bufnr, "<leader>bb", function()
    vim.lsp.buf.format({ filter = function(client) return client.name == "null-ls" end, })
  end)

  -- code search
  require("yen3.search").lsp_key_mapping(bufnr)
end

local lsp_on_attach = function(client, bufnr)
  require("lsp-status").on_attach(client)
  lsp_keymap(bufnr)
end

M.lsp_create_config = function(extra_config)
  local lsp_config = {
    on_attach = lsp_on_attach,
    capabilities = custom_update_capabilities(),
  }

  if extra_config ~= nil then
    lsp_config = vim.tbl_extend('force', lsp_config, extra_config)
  end

  return lsp_config
end

local lsp_server_sumneko_lua_bin_path = function()
  local sumneko_root_path = require('yen3.util.file').get_home_dir() .. "/usr/src/lls"

  if vim.fn.has("mac") == 1 then
    return sumneko_root_path .. "/bin/macOS/lua-language-server"
  elseif vim.fn.has("unix") == 1 then
    return sumneko_root_path .. "/bin/lua-language-server"
  end

  print("Unsupported system for sumneko")
end

local lsp_server_sumneko_lua_macos = function()
  local runtime_path = vim.split(package.path, ";", {})
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  nvim_lsp.sumneko_lua.setup(M.lsp_create_config {
    cmd = { lsp_server_sumneko_lua_bin_path() },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  })
end

local lsp_server_sumneko_lua = function()
  require('neodev').setup({})

  nvim_lsp.sumneko_lua.setup(M.lsp_create_config {
    cmd = { lsp_server_sumneko_lua_bin_path() },
  })
end

local lsp_server_pylsp = function(extra_pylsp_config)
  local pylsp_config = {
    configurationSources = {},
    plugins = {
      flake8          = config_local.pylsp_flake8_config,
      pylsp_mypy      = config_local.pylsp_mypy_config,
      pylint          = config_local.pylsp_pylint_config,
      rope_autoimport = { enabled = true },
      pycodestyle     = { enabled = false },
      pyflakes        = { enabled = false },
      yapf            = { enabled = false },
      mccabe          = { enabled = false },
      preload         = { enabled = false },
    },
  }

  if extra_pylsp_config ~= nil then
    pylsp_config = vim.tbl_extend('force', pylsp_config, extra_pylsp_config)
  end

  nvim_lsp.pylsp.setup(
    M.lsp_create_config {
      settings = {
        pylsp = pylsp_config
      },
    }
  )
end

local lsp_server_hls = function()
  local search_theme = require('yen3.search').search_theme
  local search_theme_opts = require('yen3.search').theme_search_preview_opts

  local ht = require('haskell-tools')

  local hs_on_attach = function(client, bufnr)
    local telescope = require('telescope')

    lsp_on_attach(client, bufnr)

    buf_map_call_n(bufnr, '<leader>dl', vim.lsp.codelens.run)
    buf_map_call_n(bufnr, "<leader>fq", function() ht.hoogle.hoogle_signature(search_theme_opts()) end)
    buf_map_call_n(bufnr, "<leader>fQ", function() telescope.extensions.scout.scout(search_theme({})) end)
    buf_map_call_n(bufnr, "<leader>fqq", function() telescope.extensions.hoogle.hoogle(search_theme({})) end)
  end

  ht.setup({
    hoogle = {
      mode = "telescope-local",
    },
    hls = M.lsp_create_config{
      on_attach = hs_on_attach,
      settings = {
        haskell = {
          formattingProvider = "stylish-haskell",
        },
      },
    }
  })
end

M.lsp_server_purescriptls = function()
  nvim_lsp.purescriptls.setup(M.lsp_create_config {
    settings = {
      purescript = {
        addSpagoSources = true -- e.g. any purescript language-server config here
      }
    },
    flags = {
      debounce_text_changes = 150,
    }
  })
end

local get_buf_activated_lsp = function()
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return nil
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and client.name ~= 'null-ls' then
      return client.name
    end
  end
  return nil
end

local get_activated_lsp = function()
  local lsp_name = get_buf_activated_lsp()
  if lsp_name == nil then
    return "No Active LSP"
  end

  return lsp_name .. '  ' .. (require('lsp-status').status_progress() or '')
end

local init_lsp_query_keymap = function()
  -- Show active lsp server name
  config_util.map_call_n("<leader>dp",
    function()
      config_util.notify("lsp status", get_activated_lsp())
    end
  )

  -- Show lsp server config in detail
  vim.api.nvim_create_user_command("ShowLspServerDetail",
    function() print(vim.inspect(vim.lsp.get_active_clients())) end, { desc = "Show lsp server detail"}
  )
end

M.lsp_status = function()
  nvim_status.config {
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
  }

  nvim_status.register_progress()
end

M.lspsaga_setup = function()
  require("lspsaga").init_lsp_saga({
    max_preview_lines = 15,
    code_action_lightbulb = {
      enable = false,
      cache_code_action = true,
      sign = false,
      update_time = 150,
      sign_priority = 20,
      virtual_text = false,
    },
    show_outline = {
      win_position = 'right',
      --set special filetype win that outline window split.like NvimTree neotree
      -- defx, db_ui
      win_with = '',
      win_width = 50,
      auto_enter = true,
      auto_preview = false,
      virt_text = '┃',
      jump_key = 'o',
      -- auto refresh when change buffer
      auto_refresh = true,
    },
    symbol_in_winbar = {
      enable = config_local.lspsaga_winbar_enable,
      separator = ' > ',
    },
  })
end

M.lsp_config_setup = function()
  init_lsp_query_keymap()

  lsp_server_hls()
  lsp_server_pylsp()
  if vim.fn.has("mac") == 1 then
    -- My macOS is 10.14. It uses the old config.
    lsp_server_sumneko_lua_macos()
  else
    lsp_server_sumneko_lua()
  end
  M.lsp_server.pylsp = lsp_server_pylsp
end

return M
