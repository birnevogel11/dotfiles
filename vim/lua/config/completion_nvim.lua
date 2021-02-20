local api = vim.api
local config_util = require('util.config')

local nvim_lsp = require('lspconfig')
local M = {}

function M.lsp_on_attach(_, bufnr)
  -- Set autocomplete
  require'completion'.on_attach()

  -- Set diagnostic
  M.lsp_config_diagnostic()

  -- Set key mapping
  config_util.create_keymap('n', '<c-]>',  '<cmd>lua vim.lsp.buf.definition()<CR>')

  config_util.create_keymap('n', 'K',      "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")
  config_util.create_keymap('n', 'gr',     "<cmd>lua require('lspsaga.rename').rename()<CR>")
  config_util.create_keymap('n', 'gs',     "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>")
  -- config_util.create_keymap('n', 'gd',     "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>")
  config_util.create_keymap('n', 'gh',     "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>")
  config_util.create_keymap('n', 'ga',     "<cmd>lua require('lspsaga.codeaction').code_action()<CR>")
  config_util.create_keymap('v', 'ga',     "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>")

  config_util.create_keymap('n', 'ge',     "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>")
  config_util.create_keymap('n', '[e',     "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>")
  config_util.create_keymap('n', ']e',     "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>")

  api.nvim_command([[ set omnifunc=v:lua.vim.lsp.omnifunc ]])
end

function M.pyls_on_attach(_, bufnr)
  -- Set autocomplete
  require'completion'.on_attach()

  api.nvim_command([[ set omnifunc=v:lua.vim.lsp.omnifunc ]])
end

function M.lsp_config_lua()
  local system_name
  local home_name
  if vim.fn.has("mac") == 1 then
    system_name = "macOS"
    home_name = '/Users/yen3'
  elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
    home_name = '/home/yen3'
  elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
  else
    print("Unsupported system for sumneko")
  end

  -- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
  local sumneko_root_path = home_name..'/usr/src/lua-language-server'
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

function M.lsp_config_diagnostic()
  -- credit: https://github.com/neovim/neovim/pull/12655
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = true,
      signs = true,
      update_in_insert =  function(_, _) end,
    }
  )

  -- credit: https://github.com/neovim/nvim-lspconfig/issues/69
  local method = "textDocument/publishDiagnostics"
  local default_callback = vim.lsp.callbacks[method]
  vim.lsp.callbacks[method] = function(err, method, result, client_id)
    default_callback(err, method, result, client_id)
    if result and result.diagnostics then
      for _, v in ipairs(result.diagnostics) do
        v.bufnr = vim.uri_to_bufnr(result.uri)
        v.lnum = v.range.start.line + 1
        v.col = v.range.start.character + 1
        v.text = v.message
      end
      vim.lsp.util.set_qflist(result.diagnostics)
    end
  end

  -- credit: https://gist.github.com/tjdevries/ccbe3b79bd918208f2fa8dfe15b95793
  vim.lsp.diagnostic.get_virtual_text_chunks_for_line = function(bufnr, line, line_diagnostics)
    if #line_diagnostics == 0 then
      return nil
    end

    local line_length = #(vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or '')
    local get_highlight = vim.lsp.diagnostic._get_severity_highlight_name

    -- Create a little more space between virtual text and contents
    local virt_texts = {{string.rep(" ", 80 - line_length)}}

    for i = 1, #line_diagnostics - 1 do
      table.insert(virt_texts, {"■", get_highlight(line_diagnostics[i].severity)})
    end
    local last = line_diagnostics[#line_diagnostics]
    -- TODO(ashkan) use first line instead of subbing 2 spaces?

    -- TODO(tjdevries): Allow different servers to be shown first somehow?
    -- TODO(tjdevries): Display server name associated with these?
    if last.message then
      table.insert(
        virt_texts,
        {
          string.format("■ %s", last.message:gsub("\r", ""):gsub("\n", "  ")),
          get_highlight(last.severity)
        }
      )

      return virt_texts
    end

    return virt_texts
  end
end

function M.lsp_config()
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

function M.lsp_gaga()
  local saga = require 'lspsaga'
  saga.init_lsp_saga()
end

function M.setup()
  M.lsp_config()
  M.lsp_config_lua()
end

return M
