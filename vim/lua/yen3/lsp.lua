local config_util = require("yen3.util.config")
local nvim_lsp = require("lspconfig")
local nvim_status = require('lsp-status')

local M = {
  lsp_server = {},
}

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

M.lsp_server.update_capabilities = function()
  local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
  updated_capabilities = vim.tbl_deep_extend("keep", updated_capabilities, nvim_status.capabilities)
  updated_capabilities = require("cmp_nvim_lsp").update_capabilities(updated_capabilities)
  return require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

M.lsp_server.setup_keymap = function(bufnr)
  local map = function(key, cmd)
    config_util.buf_map_n(bufnr, key, cmd)
  end
  map('K',          '<cmd>Lspsaga hover_doc<cr>')
  map('<leader>dr', '<cmd>Lspsaga rename<cr>')
  map('<leader>ds', '<cmd>Lspsaga signature_help<cr>')
  map('<leader>dd', '<cmd>Lspsaga preview_definition<cr>')
  map('<leader>da', '<cmd>Lspsaga code_action<cr>')
  map('go',         '<cmd>Lspsaga show_line_diagnostics<cr>')
  map("gj",         "<cmd>Lspsaga diagnostic_jump_next<cr>")
  map("gk",         "<cmd>Lspsaga diagnostic_jump_prev<cr>")
  map("<C-u>",      "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>")
  map("<C-d>",      "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>")
  vim.api.nvim_buf_set_keymap(bufnr, "x",
    "<leader>da", ":<c-u>Lspsaga range_code_action<cr>", {silent = true, noremap = true}
  )
  config_util.lua_key_map(bufnr, "n", "<leader>df", "vim.lsp.buf.formatting()")

  require("yen3.search").telescope.lsp_key_mapping(bufnr)
end

M.lsp_server.lsp_on_attach = function(client, bufnr)
  -- require("lsp_signature").on_attach({ hint_prefix = "λ " })
  require("lsp-status").on_attach(client)

  M.lsp_server.setup_keymap(bufnr)
end

M.lsp_server._create_config = function(extra_config)
  local lsp_config = {
    on_attach = M.lsp_server.lsp_on_attach,
    capabilities = M.lsp_server.update_capabilities(),
  }

  if extra_config ~= nil then
    lsp_config = vim.tbl_extend('force', lsp_config, extra_config)
  end

  return lsp_config
end

M.lsp_server._sumneko_lua_bin_path = function()
  local system_name
  if vim.fn.has("mac") == 1 then
    system_name = "macOS"
  elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
  elseif vim.fn.has("win32") == 1 then
    system_name = "Windows"
  else
    print("Unsupported system for sumneko")
  end

  -- set the path to the sumneko installation
  local sumneko_root_path = vim.fn.fnamemodify("~", ":p") .. "usr/src/lls"

  return sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"
end

M.lsp_server.sumneko_lua = function()
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  nvim_lsp.sumneko_lua.setup(M.lsp_server._create_config {
    cmd = { M.lsp_server._sumneko_lua_bin_path() },
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

M.lsp_server.pylsp = function(extra_pylsp_config)
  local pylsp_config = {
    configurationSources = {},
    plugins = {
      flake8      = { enabled = false },
      pylint      = { enabled = false },
      pylsp_mypy  = { enabled = false },
      pycodestyle = { enabled = false },
      pyflakes    = { enabled = false },
      yapf        = { enabled = false },
      mccabe      = { enabled = false },
      preload     = { enabled = false },
    },
  }

  if extra_pylsp_config ~= nil then
    pylsp_config = vim.tbl_extend('force', pylsp_config, extra_pylsp_config)
  end

  nvim_lsp.pylsp.setup(
    M.lsp_server._create_config {
      settings = {
        pylsp = pylsp_config
      },
    }
  )
end

M.lsp_server.hls = function()
  nvim_lsp.hls.setup(M.lsp_server._create_config{
    settings = {
      haskell = {
        formattingProvider = "stylish-haskell",
      },
    },
  })
end

M.lsp_server.html_languageserver = function()
  nvim_lsp.html.setup (M.lsp_server._create_config {
    cmd = { 'html-languageserver', },
  })
end

M.lsp_server.purescriptls = function()
  nvim_lsp.purescriptls.setup(M.lsp_server._create_config {
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

M.lsp_server.general = function()
  local local_servers = {
    "clangd", "rust_analyzer", "bashls", "tsserver", "vimls", "racket_langserver"
  }

  for _, lsp in ipairs(local_servers) do
    nvim_lsp[lsp].setup(M.lsp_server._create_config())
  end
end

M.lspsaga_setup = function()
  require("lspsaga").init_lsp_saga({
    use_saga_diagnostic_sign = false,
    code_action_prompt = {
      enable = false,
      sign = false,
      sign_priority = 20,
      virtual_text = false,
    },
    max_preview_lines = 15,
  })
end

M.lsp_server._get_buf_activated_lsp = function()
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

M.lsp_server.get_activated_lsp = function()
  local lsp_name = M.lsp_server._get_buf_activated_lsp()
  if lsp_name == nil then
    return "No Active LSP"
  end

  return lsp_name .. '  ' .. (require('lsp-status').status_progress() or '')
end

M.init_lsp_query_keymap = function()
  config_util.map_n("<leader>dp", ':lua print(require("yen3.lsp").lsp_server.get_activated_lsp())<cr>')
  config_util.map_n("<leader>dP", ":lua print(vim.inspect(vim.lsp.buf_get_clients()))<cr>")
end

M.lsp_servers_setup = function()
  M.lsp_server.hls()
  M.lsp_server.pylsp()
  M.lsp_server.sumneko_lua()
  M.lsp_server.html_languageserver()
  M.lsp_server.purescriptls()
  M.lsp_server.general()  -- Rust, Elm, C++, Typescript, bash, vim, Racket and docker
end

return M
