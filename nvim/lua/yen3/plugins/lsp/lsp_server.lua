local M = {}

M.lsp_server_jedi_language_server = function()
  local yen3_lsp_base = require("yen3.plugins.lsp.base")
  local nvim_lsp = require("lspconfig")
  nvim_lsp.jedi_language_server.setup(yen3_lsp_base.lsp_create_config())
end

M.lsp_server_pylsp = function(extra_pylsp_config)
  local nvim_lsp = require("lspconfig")
  local yen3_lsp_base = require("yen3.plugins.lsp.base")

  local pylsp_config = {
    -- configurationSources = {},
    plugins = {
      black = { enabled = true },
      pylsp_mypy = { enabled = true },
      jedi_completion = { fuzzy = true },
      pyls_isort = { enabled = true },
      -- rope_autoimport = { enabled = true },

      flake8 = { enabled = false },
      pylint = { enabled = false },
      ruff = { enabled = false },
      pycodestyle = { enabled = false },
      pyflakes = { enabled = false },
      yapf = { enabled = false },
      mccabe = { enabled = false },
      preload = { enabled = false },
    },
  }

  if extra_pylsp_config ~= nil then
    pylsp_config = vim.tbl_extend("force", pylsp_config, extra_pylsp_config)
  end

  nvim_lsp.pylsp.setup(yen3_lsp_base.lsp_create_config({
    extra_config = {
      settings = {
        pylsp = pylsp_config,
      },
    },
    use_lsp_syntax_highlight = false,
    enable_inlay_hint = false,
  }))
end

M.lsp_server_pyright = function()
  local yen3_lsp_base = require("yen3.plugins.lsp.base")
  local nvim_lsp = require("lspconfig")
  nvim_lsp.pyright.setup(yen3_lsp_base.lsp_create_config({
    extra_config = {
      -- before_init = function(_, config)
      --   config.settings.python.pythonPath = require("yen3.lib.python").get_pyenv_virtualenv_bin_path("python3")
      --     or "/usr/bin/python3"
      -- end,
      settings = {
        single_file_support = true,
        python = {
          analysis = {
            typeCheckingMode = "off",
            diagnosticMode = "openFilesOnly",
          },
          -- disableLanguageServices = true,
          disableOrganizeImports = true,
          pythonPath = require("yen3.lib.python").get_pyenv_virtualenv_bin_path("python3"),
        },
      },
    },
    use_lsp_syntax_highlight = false,
    enable_inlay_hint = true,
  }))
end

M.lsp_server_basedpyright = function()
  local yen3_lsp_base = require("yen3.plugins.lsp.base")
  local nvim_lsp = require("lspconfig")

  nvim_lsp.basedpyright.setup(yen3_lsp_base.lsp_create_config({
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
        python = {
          pythonPath = require("yen3.lib.python").get_pyenv_virtualenv_bin_path("python3"),
        },
      },
    },
    use_lsp_syntax_highlight = false,
    enable_inlay_hint = true,
  }))
end

M.lsp_server_ruff_lsp = function()
  local nvim_lsp = require("lspconfig")
  local yen3_lsp_base = require("yen3.plugins.lsp.base")

  nvim_lsp.ruff_lsp.setup(yen3_lsp_base.lsp_create_config({
    extra_config = {
      init_options = {
        settings = {
          args = { "--line-length=119" },
        },
      },
    },
  }))
end

M.lsp_server_rust_analyzer = function()
  local yen3_lsp_base = require("yen3.plugins.lsp.base")
  local rt = require("rust-tools")

  -- DAP config
  local mason_registry = require("mason-registry")
  local codelldb = mason_registry.get_package("codelldb")
  local extension_path = codelldb:get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local this_os = vim.loop.os_uname().sysname
  local liblldb_path = extension_path .. "lldb/lib/liblldb" .. (this_os == "Linux" and ".so" or ".dylib")

  local extra_attach_func = function(_, bufnr)
    -- Code action groups
    vim.keymap.set(
      "n",
      "<Leader>da",
      rt.code_action_group.code_action_group,
      { buffer = bufnr, desc = "rust-tools code action group" }
    )
    -- Hover actions
    vim.keymap.set(
      "n",
      "<leader>daa",
      rt.hover_actions.hover_actions,
      { buffer = bufnr, desc = "rust-tools code action" }
    )
    vim.keymap.set(
      "n",
      "<leader>fh",
      rt.parent_module.parent_module,
      { buffer = bufnr, desc = "Find the parent module" }
    )
    vim.keymap.set("n", "<leader>dm", rt.expand_macro.expand_macro()({ buffer = bufnr, desc = "Expand the macro" }))
  end

  rt.setup({
    dap = {
      adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    server = {
      on_attach = yen3_lsp_base.mk_lsp_on_attach_func({
        use_lsp_syntax_highlight = false,
        enable_inlay_hint = true,
        extra_attach_func = extra_attach_func,
      }),
      capabilities = yen3_lsp_base.custom_update_capabilities(),
    },
    tools = {
      hover_actions = {
        auto_focus = true,
      },
      inlay_hints = {
        auto = false,
      },
    },
  })
end

M.lsp_server_purescriptls = function()
  local yen3_lsp_base = require("yen3.plugins.lsp.base")

  require("lspconfig").purescriptls.setup(yen3_lsp_base.lsp_create_config({
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
  local yen3_lsp_base = require("yen3.plugins.lsp.base")
  local config_path = os.getenv("HOME") .. "/usr/rc/xdg_config/ansible-lint/ansible-lint-config.yaml"

  require("lspconfig").ansiblels.setup(yen3_lsp_base.lsp_create_config({
    extra_config = {
      settings = {
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
  local keymap_n = require("yen3.lib.keymap").keymap_n
  -- local nvim_lsp = require("lspconfig")
  local yen3_lsp_base = require("yen3.plugins.lsp.base")

  local extra_attach_func = function(_, bufnr)
    local ht = require("haskell-tools")
    local telescope = require("telescope")
    telescope.load_extension("hoogle")

    local nmap = function(lhs, func, desc)
      keymap_n(lhs, func, desc, bufnr)
    end

    local search_theme = require("yen3.plugins.search.base").search_theme
    local search_theme_opts = require("yen3.plugins.search.base").theme_search_preview_opts
    nmap("<leader>dl", vim.lsp.codelens.run, "LSP: code lens run")
    nmap("<leader>fq", function()
      ht.hoogle.hoogle_signature(search_theme_opts())
    end, "LSP-haskell: Hoogle signatue")
    nmap("<leader>fqq", function()
      telescope.extensions.hoogle.hoogle(search_theme({}))
    end, "LSP-haskell: Hoogle signature directly")
  end

  require("haskell-tools").setup({
    hoogle = {
      mode = "telescope-local",
    },
    hls = yen3_lsp_base.lsp_create_config({
      on_attach = yen3_lsp_base.mk_lsp_on_attach_func({
        use_lsp_syntax_highlight = false,
        enable_inlay_hint = true,
        extra_attach_func = extra_attach_func,
      }),
      settings = {
        haskell = {
          formattingProvider = "stylish-haskell",
        },
      },
    }),
  })
end

M.lsp_server_clangd = function()
  local yen3_lsp_base = require("yen3.plugins.lsp.base")
  -- local extra_config = require("clangd_extensions").prepare()

  -- require("lspconfig").clangd.setup(yen3_lsp_base.lsp_create_config({extra_config = extra_config}))
  require("lspconfig").clangd.setup(yen3_lsp_base.lsp_create_config({
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
  require("neodev").setup({})

  local yen3_lsp_base = require("yen3.plugins.lsp.base")

  require("lspconfig").lua_ls.setup(yen3_lsp_base.lsp_create_config({
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

return M
