local config_util = require("yen3.util.config")
local nvim_lsp = require("lspconfig")
local nvim_status = require('lsp-status')

local M = {
  lsp_server = {},
}

function M.lsp_server.update_capabilities()
  local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
  updated_capabilities = vim.tbl_deep_extend( "keep", updated_capabilities, nvim_status.capabilities)
  updated_capabilities = require("cmp_nvim_lsp").update_capabilities(updated_capabilities)
  return require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

function M.lsp_server.setup_keymap(bufnr)
  local lspsaga_key_map = function (key, submodule, func)
    config_util.lua_key_map(bufnr, "n", key, "require('lspsaga')." ..  submodule .."'." .. func)
  end

  lspsaga_key_map("K",          "hover",         "render_hover_doc()")
  lspsaga_key_map("<leader>dr", "rename",        "rename()")
  lspsaga_key_map("<leader>s",  "signaturehelp", "signature_help()")
  lspsaga_key_map("<leader>d",  "provider",      "preview_definition()")
  lspsaga_key_map("<leader>a",  "codeaction",    "code_action()")
  lspsaga_key_map("ge",         "diagnostic",    "show_line_diagnostics()")
  lspsaga_key_map("[e",         "diagnostic",    "lsp_jump_diagnostic_prev()")
  lspsaga_key_map("]e",         "diagnostic",    "show_line_diagnostics()")
  lspsaga_key_map("<C-u>",      "action",        "smart_scroll_with_saga(-1)")
  lspsaga_key_map("<C-d>",      "action",        "smart_scroll_with_saga(1)")

  vim.api.nvim_buf_set_keymap(
    bufnr, "v", "<leader>ga", "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>",
    { noremap = true, silent = true }
  )

  config_util.lua_key_map(bufnr, "n", "<leader>df", "vim.lsp.buf.formatting()")

  require("yen3.search").telescope.lsp_key_mapping(bufnr)
end

function M.lsp_server.lsp_on_attach(client, bufnr)
  require("lsp_signature").on_attach({ hint_prefix = "λ " })
  require('yen3.lsp_status').on_attach(client)
  M.lsp_server.setup_keymap(bufnr)
end

function M.lsp_server._sumneko_lua_bin_path()
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

function M.lsp_server.sumneko_lua()
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  nvim_lsp.sumneko_lua.setup({
    cmd = { M.lsp_server._sumneko_lua_bin_path() },
    on_attach = M.lsp_server.lsp_on_attach,
    capabilities = M.lsp_server.update_capabilities(),
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

function M.lsp_server.pylsp(pylsp_config)
  local default_pylsp_config = {
    configurationSources = {},
    plugins = {
      flake8 = { enabled = false },
      pylint = { enabled = false },
      pyls_mypy = { enabled = false },
      pycodestyle = { enabled = false },
      pyflakes = { enabled = false },
      yapf = { enabled = false },
    },
  }
  pylsp_config = pylsp_config or default_pylsp_config

  nvim_lsp.pylsp.setup({
    capabilities = M.lsp_server.update_capabilities(),
    on_attach = M.lsp_server.lsp_on_attach,
    settings = { pylsp = pylsp_config },
  })
end

function M.lsp_server.hls()
  nvim_lsp.hls.setup({
    on_attach = M.lsp_server.lsp_on_attach,
    capabilities = M.lsp_server.update_capabilities(),
    settings = {
      haskell = {
        formattingProvider = "stylish-haskell",
      },
    },
  })
end

function M.lsp_server.general()
  local local_servers = {
    "ccls", "rust_analyzer", "bashls", "tsserver", "html", "vimls",
  }

  for _, lsp in ipairs(local_servers) do
    nvim_lsp[lsp].setup({
      on_attach = M.lsp_server.lsp_on_attach,
      capabilities = M.lsp_server.update_capabilities(),
    })
  end
end

function M.lspsaga_setup()
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

function M.lsp_server._get_buf_activated_lsp()
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

function M.lsp_server.get_activated_lsp()
  local lsp_name = M.lsp_server._get_buf_activated_lsp()
  if lsp_name == nil then
    return "No Active LSP"
  end

  return lsp_name .. '  ' .. (require('lsp-status').status_progress() or '')
end

function M.init_lsp_query_keymap()
  config_util.map_n("<leader>dp", ':lua print(require("yen3.lsp").lsp_server.get_activated_lsp())<cr>')
  config_util.map_n("<leader>dP", ":lua print(vim.inspect(vim.lsp.buf_get_clients()))<cr>")
end

function M.lsp_servers_setup()
  -- Haskell
  M.lsp_server.hls()

  -- Python
  M.lsp_server.pylsp()

  -- Lua
  M.lsp_server.sumneko_lua()

  -- Rust, C++, Typescript, bash, vim and docker
  M.lsp_server.general()
end

function M.setup()
  M.init_lsp_query_keymap()
  M.lspsaga_setup()
  M.lsp_servers_setup()
end

return M
