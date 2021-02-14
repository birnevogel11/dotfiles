local api = vim.api
local config_util = require('util.config')

local nvim_lsp = require('lspconfig')
local M = {}

function M.lsp_on_attach(_, bufnr)
  -- Set autocomplete
  require'completion'.on_attach()

  -- Set key mapping
  config_util.create_keymap('n', '<c-]>',  '<cmd>lua vim.lsp.buf.definition()<CR>')
  config_util.create_keymap('n', 'K',      '<cmd>lua vim.lsp.buf.hover()<CR>')
  config_util.create_keymap('n', 'gD',     '<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- config_util.create_keymap('n', 'K',      '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  config_util.create_keymap('n', '1gD',    '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  config_util.create_keymap('n', 'gr',     '<cmd>lua vim.lsp.buf.references()<CR>')
  config_util.create_keymap('n', 'g0',     '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  config_util.create_keymap('n', 'gW',     '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  config_util.create_keymap('n', 'gd',     '<cmd>lua vim.lsp.buf.declaration()<CR>')

  api.nvim_command([[ set omnifunc=v:lua.vim.lsp.omnifunc ]])
end

function M.pyls_on_attach(_, bufnr)
  -- Set autocomplete
  require'completion'.on_attach()

  local vars = {
    ['jedi#goto_command'] = "<c-]>",
    ['jedi#goto_assignments_command'] = "ga",
    ['jedi#goto_definitions_command'] = "gd",
    ['jedi#documentation_command'] = "K",
    ['jedi#usages_command'] = "gu",
    ['jedi#rename_command'] = "gr",
  }
  config_util.set_variables(vars)

  api.nvim_command([[ set omnifunc=v:lua.vim.lsp.omnifunc ]])
end

function M.lsp_config_lua()
  local system_name
  if vim.fn.has("mac") == 1 then
    system_name = "macOS"
  elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
  elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
  else
    print("Unsupported system for sumneko")
  end

  -- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
  local sumneko_root_path = '/Users/yen3/usr/src/lua-language-server'
  local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

  nvim_lsp.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
    on_attach = M.lsp_on_attach,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
      },
    },
  }
end

function M.lsp_config()
  -- Disable diangostics. Use ALE to manage it
  vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end

  local local_servers = {'hls', 'clangd', 'rust_analyzer', 'tsserver'}
  for _, lsp in ipairs(local_servers) do
    nvim_lsp[lsp].setup {
      on_attach = M.lsp_on_attach,
    }
  end

  nvim_lsp.pyls.setup {
    on_attach = M.pyls_on_attach,
  }
end

function M.setup()
  M.lsp_config()
  M.lsp_config_lua()
end

return M
