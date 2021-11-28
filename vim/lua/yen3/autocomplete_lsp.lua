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
end

function M.lsp_config_keymapping(bufnr, enable_diagnostic)
  -- Set key mapping
  -- config_util.lua_key_map(bufnr, 'n', '<c-]>',  'vim.lsp.buf.definition()')
  config_util.lua_key_map(bufnr, 'n', 'K',      "require'lspsaga.hover'.render_hover_doc()")
  config_util.lua_key_map(bufnr, 'n', 'gr',     "require'lspsaga.rename'.rename()")
  config_util.lua_key_map(bufnr, 'n', 'gs',     "require('lspsaga.signaturehelp').signature_help()")
  config_util.lua_key_map(bufnr, 'n', 'gd',     "require'lspsaga.provider'.preview_definition()")
  -- config_util.lua_key_map(bufnr, 'n', 'gh',     "require'lspsaga.provider'.lsp_finder()")
  config_util.lua_key_map(bufnr, 'n', 'ga',     "require'lspsaga.codeaction'.code_action()")
  config_util.create_keymap('v', 'ga', "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>")

  if enable_diagnostic == true then
    config_util.lua_key_map(bufnr, 'n', 'ge',     "require'lspsaga.diagnostic'.show_line_diagnostics()")
    config_util.lua_key_map(bufnr, 'n', '[e',     "require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()")
    config_util.lua_key_map(bufnr, 'n', ']e',     "require'lspsaga.diagnostic'.show_line_diagnostics()")
  end

  require('yen3.search').telescope.lsp_key_mapping()
end

function M.lsp_on_attach(_, bufnr)
  require'lsp_signature'.on_attach { hint_prefix = "λ ", }
  M.lsp_config_diagnostic(bufnr)
  M.lsp_config_keymapping(bufnr, true)
end

function M.lsp_config_lang_lua()
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

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
    capabilities = capabilities,
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

function M.lsp_config_lang_pylsp()
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  nvim_lsp.pylsp.setup {
    -- cmd = { "pylsp", "-v", "--log-file", "/tmp/pylsp.log"},
    capabilities = capabilities,
    settings = {
      pylsp = {
        configurationSources = {},
        plugins = {
          pycodestyle = { enabled = false },
          pyflakes = { enabled = false },
          pylint = { enabled = false },
          yapf = { enabled = false },
          flake8 = { enabled = false },
          pyls_mypy = { enabled = false },
        },
      },
    },
    on_attach = function(_, bufnr)
      require'lsp_signature'.on_attach { hint_prefix = "λ ", }
      M.lsp_config_diagnostic_disable(bufnr)
      M.lsp_config_keymapping(bufnr, false)
    end,
  }
end

function M.lsp_config()
  local local_servers = {'hls', 'ccls', 'rust_analyzer',
    'bashls', 'tsserver', 'html', 'vimls'
  }
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  for _, lsp in ipairs(local_servers) do
    nvim_lsp[lsp].setup {
      on_attach = M.lsp_on_attach,
      capabilities = capabilities,
    }
  end
end

function M.init_nvim_cmp()
  local cmd = api.nvim_command
  local cmp = require'cmp'

  cmd [[ set completeopt-=preview ]]
  cmd [[ set completeopt=menuone,noinsert ]]
  -- cmd [[ set shortmess+=c ]]

   cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      -- ['<CR>'] = cmp.mapping.close(),
      ['<C-e>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
      }),
      ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    sources = cmp.config.sources(
      {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
      },
      {
        { name = 'buffer' },
        { name = 'path' },
        { name = 'tmux' },
      }
    )
  })
end

function M.init_lspsaga()
  -- Init saga
  local saga = require 'lspsaga'
  saga.init_lsp_saga {
    use_saga_diagnostic_sign = false,
    code_action_prompt = {
      enable = false,
      sign = false,
      sign_priority = 20,
      virtual_text = false,
    },
    max_preview_lines = 30,
  }
end

function M.init_vsnip()
  local cmd = api.nvim_command

  -- Expand
  cmd [[ imap <expr> <C-l> vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-l>'  ]]
  cmd [[ smap <expr> <C-l> vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-l>'  ]]

  -- Expand or jump
  cmd [[ imap <expr> <C-e> vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-e>'  ]]
  cmd [[ smap <expr> <C-e> vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-e>'  ]]

  -- Jump forward or backward
  cmd [[ imap <expr> <C-j> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-j>'  ]]
  cmd [[ smap <expr> <C-j> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-j>'  ]]
  cmd [[ imap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'  ]]
  cmd [[ smap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'  ]]

  config_util.set_variables {
    vsnip_filetypes = {
      javascriptreact = {'javascript'},
      typescriptreact = {'typescript'},
    },
    vsnip_snippet_dirs = {'~/.config/nvim/snippets'}
  }
end

function M.setup()
  M.init_lspsaga()
  M.init_vsnip()
  M.init_nvim_cmp()

  -- Haskell, Rust, C++, Typescript, bash, vim and docker
  M.lsp_config()

  -- Python
  M.lsp_config_lang_pylsp()

  -- Lua
  M.lsp_config_lang_lua()
end


return M
