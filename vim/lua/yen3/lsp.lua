local api = vim.api
local config_util = require('util.config')
local nvim_lsp = require('lspconfig')

local M = {
}


function M.update_capabilities()
  return require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

function M.lsp_config_diagnostic_disable(bufnr)
  vim.diagnostic.disable(bufnr)
end

function M.lsp_config_diagnostic(_)
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = false,
    }
  )
end

function M.lsp_config_keymapping(bufnr)
  -- Set key mapping
  config_util.lua_key_map(bufnr, 'n', 'K',          "require'lspsaga.hover'.render_hover_doc()")
  config_util.lua_key_map(bufnr, 'n', '<leader>dr', "require'lspsaga.rename'.rename()")
  config_util.lua_key_map(bufnr, 'n', 'gs',         "require('lspsaga.signaturehelp').signature_help()")
  config_util.lua_key_map(bufnr, 'n', 'gd',         "require'lspsaga.provider'.preview_definition()")
  config_util.lua_key_map(bufnr, 'n', 'ga',         "require'lspsaga.codeaction'.code_action()")
  vim.api.nvim_buf_set_keymap(bufnr, 'v', 'ga',
    "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>", {noremap = true, silent = true})

  config_util.lua_key_map(bufnr, 'n', 'ge',     "require'lspsaga.diagnostic'.show_line_diagnostics()")
  config_util.lua_key_map(bufnr, 'n', '[e',     "require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()")
  config_util.lua_key_map(bufnr, 'n', ']e',     "require'lspsaga.diagnostic'.show_line_diagnostics()")
  config_util.lua_key_map(bufnr, 'n', '<C-u>',  "require'lspsaga.action'.smart_scroll_with_saga(-1)")
  config_util.lua_key_map(bufnr, 'n', '<C-d>',  "require'lspsaga.action'.smart_scroll_with_saga(1)")

  config_util.lua_key_map(bufnr, 'n', '<leader>df',  "vim.lsp.buf.formatting()")

  require('yen3.search').telescope.lsp_key_mapping(bufnr)
end

function M.lsp_on_attach(_, bufnr)
  require('lsp_signature').on_attach { hint_prefix = "λ ", }
  M.lsp_config_diagnostic(bufnr)
  M.lsp_config_keymapping(bufnr)
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

  -- set the path to the sumneko installation
  local sumneko_root_path = vim.fn.fnamemodify('~', ':p') .. 'usr/src/lls'
  local sumneko_binary = sumneko_root_path.."/bin/" .. system_name .. "/lua-language-server"

  nvim_lsp.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
    on_attach = M.lsp_on_attach,
    capabilities = M.update_capabilities(),
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

function M.lsp_config_pylsp(pylsp_config)
  local default_pylsp_config = {
    configurationSources = {},
    plugins = {
      flake8      = { enabled = true  },
      pylint      = { enabled = false },
      pyls_mypy   = { enabled = false },
      pycodestyle = { enabled = false },
      pyflakes    = { enabled = false },
      yapf        = { enabled = false },
    },
  }
  pylsp_config = pylsp_config or default_pylsp_config

  nvim_lsp.pylsp.setup {
    -- cmd = { "pylsp", "-vvvvvv", "--log-file", "/tmp/pylsp.log"},
    capabilities = M.update_capabilities(),
    on_attach = M.lsp_on_attach,
    settings = { pylsp = pylsp_config, },
  }
end


function M.lsp_hls_fixed_cwd()
  nvim_lsp.hls.setup{
    on_attach = M.lsp_on_attach,
    capabilities = M.update_capabilities(),
    settings = {
      haskell = {
        formattingProvider = "stylish-haskell"
      }
    },
    root_dir = function()
      return vim.fn.getcwd()
    end,
  }
end

function M.lsp_hls()
  nvim_lsp.hls.setup {
    on_attach = M.lsp_on_attach,
    capabilities = M.update_capabilities(),
    settings = {
      haskell = {
        formattingProvider = "stylish-haskell"
      }
    },
  }
end

function M.lsp_config()
  local local_servers = {
    'ccls', 'rust_analyzer',
    'bashls', 'tsserver', 'html', 'vimls'
  }

  for _, lsp in ipairs(local_servers) do
    nvim_lsp[lsp].setup {
      on_attach = M.lsp_on_attach,
      capabilities = M.update_capabilities(),
    }
  end
end

function M.init_nvim_cmp()
  local cmp_kinds = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = ""
  }
  local cmd = api.nvim_command
  local cmp = require'cmp'

  cmd [[ set completeopt-=preview ]]
  cmd [[ set completeopt=menuone,noinsert ]]

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
        { name = 'buffer', keyword_length = 3 },
        { name = 'path' },
        { name = 'tmux' },
      }
    ),
    formatting = {
      format = function(_, vim_item)
        -- vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. ' ' .. vim_item.kind
        vim_item.kind = cmp_kinds[vim_item.kind] or ''
        return vim_item
      end,
    },
  })

end

function M.init_lspsaga()
  require('lspsaga').init_lsp_saga {
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

  local vsnip_key_map = function(key, func_name, plug_func_name)
    local plug_func = "'<Plug>(" .. plug_func_name .. ")'"
    local map_func = func_name .. ' ? ' .. plug_func .. ' : ' .. "'" .. key .. "'"
    local map_command = ' <expr> '.. key .. ' ' .. map_func
    cmd('imap' .. map_command)
    cmd('smap' .. map_command)
  end

  -- Expand
  vsnip_key_map('<C-l>', 'vsnip#expandable()', 'vsnip-expand')

  -- Expand or jump
  vsnip_key_map('<C-e>', 'vsnip#available(1)', 'vsnip-expand-or-jump')

  -- Jump forward or backward
  vsnip_key_map('<C-j>', 'vsnip#jumpable(1)', 'vsnip-jump-next')
  vsnip_key_map('<C-k>', 'vsnip#jumpable(-1)', 'vsnip-jump-prev')

  config_util.set_variables {
    vsnip_filetypes = {
      javascriptreact = {'javascript'},
      typescriptreact = {'typescript'},
    },
    vsnip_snippet_dirs = {'~/.config/nvim/snippets'}
  }
end

function M.init_null_ls()
  local null_ls = require("null-ls")
  local builtins = null_ls.builtins
  null_ls.config({
      sources = {
        builtins.formatting.black.with({
          args =  {"-l", "119", "--stdin-filename", "$FILENAME", "--quiet", "-",}
        }),
      },
  })

  require("lspconfig")["null-ls"].setup({
      on_attach = M.lsp_on_attach,
      capabilities = M.update_capabilities(),
  })
end

function M.init_lsp_query_keymap()
  config_util.map_n('<leader>dp', ':lua print(vim.inspect(vim.lsp.buf_get_clients()))<cr>')
end

function M.setup()
  M.init_lsp_query_keymap()

  M.init_lspsaga()
  M.init_vsnip()
  M.init_nvim_cmp()

  -- Rust, C++, Typescript, bash, vim and docker
  M.lsp_config()

  -- Haskell
  M.lsp_hls()

  -- Python
  M.lsp_config_pylsp()

  -- Lua
  M.lsp_config_lua()

  -- Null-ls
  M.init_null_ls()

  require('calltree').setup({})
end

return M
