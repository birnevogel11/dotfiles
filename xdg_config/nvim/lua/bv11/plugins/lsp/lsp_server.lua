local M = {}

-- M.lsp_server_jedi_language_server = function()
--   local bv11_lsp_lib = require("bv11.plugins.lsp.lib")
--   local nvim_lsp = require("lspconfig")
--   nvim_lsp.jedi_language_server.setup(bv11_lsp_lib.lsp_create_config())
-- end
--
-- M.lsp_server_pylsp = function(extra_pylsp_config)
--   local nvim_lsp = require("lspconfig")
--   local bv11_lsp_lib = require("bv11.plugins.lsp.lib")
--
--   local pylsp_config = {
--     -- configurationSources = {},
--     plugins = {
--       black = { enabled = true },
--       pylsp_mypy = { enabled = true },
--       jedi_completion = { fuzzy = true },
--       pyls_isort = { enabled = true },
--       -- rope_autoimport = { enabled = true },
--
--       flake8 = { enabled = false },
--       pylint = { enabled = false },
--       ruff = { enabled = false },
--       pycodestyle = { enabled = false },
--       pyflakes = { enabled = false },
--       yapf = { enabled = false },
--       mccabe = { enabled = false },
--       preload = { enabled = false },
--     },
--   }
--
--   if extra_pylsp_config ~= nil then
--     pylsp_config = vim.tbl_extend("force", pylsp_config, extra_pylsp_config)
--   end
--
--   nvim_lsp.pylsp.setup(bv11_lsp_lib.lsp_create_config({
--     extra_config = {
--       settings = {
--         pylsp = pylsp_config,
--       },
--     },
--     use_lsp_syntax_highlight = false,
--     enable_inlay_hint = false,
--   }))
-- end
--
-- M.lsp_server_pyright = function()
--   local bv11_lsp_lib = require("bv11.plugins.lsp.lib")
--   local nvim_lsp = require("lspconfig")
--   nvim_lsp.pyright.setup(bv11_lsp_lib.lsp_create_config({
--     extra_config = {
--       -- before_init = function(_, config)
--       --   config.settings.python.pythonPath = require("bv11.lib.python").get_pyenv_virtualenv_bin_path("python3")
--       --     or "/usr/bin/python3"
--       -- end,
--       settings = {
--         single_file_support = true,
--         python = {
--           analysis = {
--             typeCheckingMode = "off",
--             diagnosticMode = "openFilesOnly",
--           },
--           -- disableLanguageServices = true,
--           disableOrganizeImports = true,
--           pythonPath = require("bv11.lib.python").get_pyenv_virtualenv_bin_path("python3"),
--         },
--       },
--     },
--     use_lsp_syntax_highlight = false,
--     enable_inlay_hint = true,
--   }))
-- end

M.lsp_server_basedpyright = function()
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")
  local nvim_lsp = require("lspconfig")

  nvim_lsp.basedpyright.setup(bv11_lsp_lib.lsp_create_config({
    extra_config = {
      settings = {
        single_file_support = true,
        basedpyright = {
          analysis = {
            typeCheckingMode = "off",
            diagnosticMode = "openFilesOnly",
          },
          disableOrganizeImports = true,
        },
      },
    },
    use_lsp_syntax_highlight = false,
    enable_inlay_hint = true,
  }))
end

M.lsp_server_ruff = function()
  local nvim_lsp = require("lspconfig")
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")

  nvim_lsp.ruff.setup(bv11_lsp_lib.lsp_create_config())
end

local get_rust_lldb_dap_config = function()
  local this_os = vim.loop.os_uname().sysname

  local codelldb_dir = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/codelldb")
  local codelldb_path = codelldb_dir .. "/codelldb"
  local liblldb_path = codelldb_dir .. "extension/lldb/lib/liblldb" .. (this_os == "Linux" and ".so" or ".dylib")

  return require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path)
end

M.lsp_server_rust_analyzer = function()
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")
  vim.g.rustaceanvim = {
    dap = {
      adapter = get_rust_lldb_dap_config(),
    },
    server = {
      on_attach = bv11_lsp_lib.mk_lsp_on_attach_func({
        use_lsp_syntax_highlight = false,
        enable_inlay_hint = true,
      }),
      capabilities = bv11_lsp_lib.custom_update_capabilities(),
    },
  }
end

M.lsp_server_purescriptls = function()
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")

  require("lspconfig").purescriptls.setup(bv11_lsp_lib.lsp_create_config({
    extra_config = {
      settings = {
        purescript = {
          addSpagoSources = true, -- e.g. any purescript language-server config here
        },
      },
      flags = {
        debounce_text_changes = 150,
      },
    },
  }))
end

M.lsp_server_ansiblels = function()
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")
  local config_path = os.getenv("HOME") .. "/usr/rc/xdg_config/ansible-lint/ansible-lint-config.yaml"
  local util = require("lspconfig.util")

  require("lspconfig").ansiblels.setup(bv11_lsp_lib.lsp_create_config({
    extra_config = {
      settings = {
        root_dir = util.find_git_ancestor(),
        ansible = {
          ansible = {
            useFullyQualifiedCollectionNames = false,
          },
          validation = {
            enabled = true,
            lint = {
              enabled = true,
              path = "ansible-lint -c " .. config_path,
            },
          },
        },
      },
    },
    use_lsp_syntax_highlight = true,
  }))
end

M.lsp_server_hls = function()
  local keymap_n = require("bv11.lib.keymap").keymap_n
  -- local nvim_lsp = require("lspconfig")
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")

  local extra_attach_func = function(_, bufnr)
    -- local ht = require("haskell-tools")
    local telescope = require("telescope")
    telescope.load_extension("hoogle")

    local nmap = function(lhs, func, desc)
      keymap_n(lhs, func, desc, bufnr)
    end

  end

  -- require("haskell-tools").setup({
  --   hoogle = {
  --     mode = "telescope-local",
  --   },
  --   hls = bv11_lsp_lib.lsp_create_config({
  --     on_attach = bv11_lsp_lib.mk_lsp_on_attach_func({
  --       use_lsp_syntax_highlight = false,
  --       enable_inlay_hint = true,
  --       extra_attach_func = extra_attach_func,
  --     }),
  --     settings = {
  --       haskell = {
  --         formattingProvider = "stylish-haskell",
  --       },
  --     },
  --   }),
  -- })
end

M.lsp_server_clangd = function()
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")
  -- local extra_config = require("clangd_extensions").prepare()

  -- require("lspconfig").clangd.setup(bv11_lsp_lib.lsp_create_config({extra_config = extra_config}))
  require("lspconfig").clangd.setup(bv11_lsp_lib.lsp_create_config({
    extra_config = {
      use_lsp_syntax_highlight = false,
      enable_inlay_hint = true,
    },
    -- extra_attach_func = function()
    --   require("clangd_extensions.inlay_hints").setup_autocmd()
    --   require("clangd_extensions.inlay_hints").set_inlay_hints()
    -- end,
  }))
end

M.lsp_server_lua_ls = function()
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")

  require("lspconfig").lua_ls.setup(bv11_lsp_lib.lsp_create_config({
    extra_config = {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
          hint = { enable = true },
        },
      },
    },
    enable_inlay_hint = true,
  }))
end

M.lsp_server_zuul_ls = function()
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")
  local nvim_lsp = require("lspconfig")
  nvim_lsp.zuul_ls.setup(bv11_lsp_lib.lsp_create_config({
    extra_config = {
      cmd = { vim.loop.os_homedir() .. "/Trek/zuul-ls/target/debug/zuul-ls" },
    },
  }))
end

M.lsp_server_bashls = function()
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")
  local nvim_lsp = require("lspconfig")
  nvim_lsp.bashls.setup(bv11_lsp_lib.lsp_create_config())
end

M.lsp_server_marksman = function()
  local bv11_lsp_lib = require("bv11.plugins.lsp.lib")
  local nvim_lsp = require("lspconfig")
  nvim_lsp.marksman.setup(bv11_lsp_lib.lsp_create_config())
end

return M
