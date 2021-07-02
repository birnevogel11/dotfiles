local api = vim.api
local config_util = require('util.config')
local config_file = require('util.file')

local nvim_lsp = require('lspconfig')
local M = {}

function M.lsp_config_diagnostic_disable(bufnr)
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = false,
      virtual_text = false,
      signs = false,
      update_in_insert =  function(_, _) end,
    }
  )
end

function M.lsp_config_diagnostic(bufnr)
  -- credit: https://github.com/neovim/nvim-lspconfig/issues/69
  local method = "textDocument/publishDiagnostics"
  local default_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
    default_handler(err, method, result, client_id, bufnr, config)
    local diagnostics = vim.lsp.diagnostic.get_all()
    local qflist = {}
    for bufnr, diagnostic in pairs(diagnostics) do
      for _, d in ipairs(diagnostic) do
        d.bufnr = bufnr
        d.lnum = d.range.start.line + 1
        d.col = d.range.start.character + 1
        d.text = d.message
        table.insert(qflist, d)
      end
    end
    vim.lsp.util.set_qflist(qflist)
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

  config_util.lua_key_map(bufnr, 'n', 'ge',     "require'lspsaga.diagnostic'.show_line_diagnostics()")
  config_util.lua_key_map(bufnr, 'n', '[e',     "require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()")
  config_util.lua_key_map(bufnr, 'n', ']e',     "require'lspsaga.diagnostic'.show_line_diagnostics()")
end

function M.lsp_on_attach(_, bufnr)
  -- Set autocomplete
  require'completion'.on_attach()

  -- Add signature setting
  require'lsp_signature'.on_attach()

  -- Set diagnostic
  M.lsp_config_diagnostic(bufnr)
  -- M.lsp_config_diagnostic_disable(bufnr)

  -- Set key mapping
  config_util.lua_key_map(bufnr, 'n', '<c-]>',  'vim.lsp.buf.definition()')
  config_util.lua_key_map(bufnr, 'n', 'K',      "require'lspsaga.hover'.render_hover_doc()")
  config_util.lua_key_map(bufnr, 'n', 'gr',     "require'lspsaga.rename'.rename()")
  config_util.lua_key_map(bufnr, 'n', 'gs',     "require('lspsaga.signaturehelp').signature_help()")
  config_util.lua_key_map(bufnr, 'n', 'gd',     "require'lspsaga.provider'.preview_definition()")
  config_util.lua_key_map(bufnr, 'n', 'gh',     "require'lspsaga.provider'.lsp_finder()")
  config_util.lua_key_map(bufnr, 'n', 'ga',     "require'lspsaga.codeaction'.code_action()")

  config_util.lua_key_map(bufnr, 'n', 'ge',     "require'lspsaga.diagnostic'.show_line_diagnostics()")
  config_util.lua_key_map(bufnr, 'n', '[e',     "require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()")
  config_util.lua_key_map(bufnr, 'n', ']e',     "require'lspsaga.diagnostic'.show_line_diagnostics()")

  config_util.create_keymap('v', 'ga', "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>")
end

function M.lsp_config_lang_lua()
  -- Init saga
  local saga = require 'lspsaga'
  saga.init_lsp_saga()

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

  -- set the path to the sumneko installation
  local sumneko_root_path = vim.fn.fnamemodify('~', ':p')..'usr/src/lua-language-server'
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

function M.lsp_config_lang_pyls()
  local disable_plugin_config = {
      pycodestyle = { enabled = false },
      flake8 = { enabled = false },
      pylint = { enabled = false },
      pyls_mypy = { enabled = false },
  }

  local load_plugins_config = function(name)
    name = name or ".pyls_config_nvim"
    local config = {
      pycodestyle = { enabled = false },
      flake8 = { enabled = true },
      pylint = { enabled = true },
      pyls_mypy = { enabled = true },
    }

    local path = config_file.find_config_path_rec(name)
    if #path ~= 0 then
      local local_config = config_file.read_pyls_plugin_setting(path)
      for k, v in pairs(local_config) do
        config[k] = v
      end
    end

    return config
  end

  nvim_lsp.pyls.setup {
    settings = {
      pyls = {
        plugins = disable_plugin_config,
        -- plugins = load_plugins_config(),
      },
    },
    on_attach = function(_, bufnr)
      require'completion'.on_attach()
      require'lsp_signature'.on_attach({
        hint_prefix = "λ ",
      })

      M.lsp_config_diagnostic_disable(bufnr)
    end,
  }
end


function M.lsp_config()
  local local_servers = {'hls', 'ccls', 'rust_analyzer', 'bashls', 'tsserver', 'html', 'vimls'}

  for _, lsp in ipairs(local_servers) do
    nvim_lsp[lsp].setup {
      on_attach = M.lsp_on_attach,
    }
  end
end

function M.completion_nvim()
  local cmd = api.nvim_command

  -- Set completeopt to have a better completion experience
  cmd [[ set completeopt=menuone,noinsert,noselect ]]

  -- Avoid showing message extra message when using completion
  cmd [[ set shortmess+=c ]]

  local vars = {
    completion_enable_auto_signature = 1,
    completion_enable_auto_hover = 1,
    completion_enable_snippet = 'UltiSnips',
    completion_trigger_on_delete = 1,
    completion_confirm_key = "\\<c-y>",
    completion_tmux_word_min_length = 3,

    completion_chain_complete_list = {
      default = {
        func = {
          { complete_items = {'lsp', 'buffers'}},
        },
        ["string"] = {
          { complete_items = {'lsp', 'snippet', 'ts', 'buffers', 'path', 'tmux'}},
        },
        comment = {
          { complete_items = {'lsp', 'snippet', 'ts', 'buffers', 'path', 'tmux'}},
        },
        default = {
          { complete_items = {'lsp', 'snippet', 'buffers', 'tmux'}},
          { mode = '<c-p>' },
          { mode = '<c-n>' },
        },
      }
    },
  }

  config_util.set_variables(vars)

  -- require'navigator'.setup()
end

function M.ultisnips()
  local vars = {
    UltiSnipsExpandTrigger = "<c-e>",
    UltiSnipsJumpForwardTrigger = "<c-b>",
    UltiSnipsJumpBackwardTrigger = "<c-z>",

    -- If you want :UltiSnipsEdit to split your window.
    UltiSnipsEditSplit = "vertical",
    UltiSnipsSnippetDirectories = {'~/usr/rc/vim/snippets'},
    UltiSnipsSnippetsDir = '~/usr/rc/vim/snippets',
    UltiSnipsEnableSnipMate = 0,

    ultisnips_javascript = {
      ['keyword-spacing'] = 'always',
      semi = 'never',
      ['space-before-function-paren'] = 'always',
    },
  }

  config_util.set_variables(vars)
end

function M.setup()
  M.completion_nvim()
  M.ultisnips()

  -- Haskell, Rust, C++, Typescript, bash, vim and docker
  M.lsp_config()

  -- Python
  M.lsp_config_lang_pyls()

  -- Lua
  if vim.fn.has("unix") then
    M.lsp_config_lang_lua()
  end
end

return M
