local null_ls_setup = function()
  local null_ls = require("null-ls")
  local builtins = null_ls.builtins
  local pyenv_bin = require('yen3.lib.python').get_pyenv_virtualenv
  null_ls.setup({
    sources = {
      builtins.diagnostics.mypy.with({ command = pyenv_bin("mypy") }),
      builtins.formatting.black.with({ command = pyenv_bin("black"), extra_args = { "-l", "119" } }),
    },
    builtins.hover.dictionary,
  })
end

local mason_lspconfig_setup = function()
  local yen3_lsp_base = require("yen3.plugins.lsp.base")

  require("mason-lspconfig").setup({
    ensure_installed = {
      "ansiblels",
      "bashls",
      "clangd",
      "dockerls",
      "esbonio", -- sphinx
      "gopls",
      "html",
      "hls",
      "jsonls",
      "marksman",
      "purescriptls",
      "pyright",
      "ruff_lsp",
      "rust_analyzer",
      "lua_ls",
      "taplo",
      "texlab",
      "tsserver",
    },
  })

  require("mason-lspconfig").setup_handlers({
    function(server_name)
      require("lspconfig")[server_name].setup(yen3_lsp_base.lsp_create_config())
    end,

    pyright = function(_)
      require("yen3.plugins.lsp.lsp_server").lsp_server_pyright()
    end,

    ruff_lsp = function(_)
      require("yen3.plugins.lsp.lsp_server").lsp_server_ruff_lsp()
    end,

    rust_analyzer = function(_)
      require("yen3.plugins.lsp.lsp_server").lsp_server_rust_analyzer()
    end,

    purescriptls = function(_)
      require("yen3.plugins.lsp.lsp_server").lsp_server_purescriptls()
    end,

    ansiblels = function(_)
      require("yen3.plugins.lsp.lsp_server").lsp_server_ansiblels()
    end,

    lua_ls = function(_)
      require("yen3.plugins.lsp.lsp_server").lsp_server_sumneko_lua()
    end,

    clangd = function(_)
      require("yen3.plugins.lsp.lsp_server").lsp_server_clangd()
    end,

    hls = function(_)
      require("yen3.plugins.lsp.lsp_server").lsp_server_hls()
    end,
  })
end

local mason_null_ls_setup = function()
  local local_config = require("yen3.local")

  local null_ls = require("null-ls")
  local null_ls_register = null_ls.register
  local builtins = null_ls.builtins

  require("mason-null-ls").setup({
    ensure_installed = {
      "cspell",
      -- "clang-format",
      "hadolint",
      "markdownlint",
      "shellcheck",
      "shfmt",
      "stylua",
      "yamlfmt",
      "yamllint",
    },
    handlers = {
      -- All sources with no handler get passed here
      function(_) end,

      -- Lua
      ["stylua"] = function()
        null_ls_register(builtins.formatting.stylua.with({
          extra_args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "120" },
        }))
      end,

      -- Shell
      ["shellcheck"] = function()
        null_ls_register(builtins.diagnostics.shellcheck)
      end,

      ["shfmt"] = function()
        null_ls_register(builtins.formatting.shfmt.with({ extra_args = { "-i", "2", "-ci" } }))
      end,

      -- Dockerfile
      ["hadolint"] = function()
        null_ls_register(builtins.diagnostics.hadolint.with({
          extra_args = {
            "--ignore",
            "DL3003",
            "--ignore",
            "DL3008",
            "--ignore",
            "DL3009",
            "--ignore",
            "DL3013",
            "--ignore",
            "DL3015",
            "--ignore",
            "DL3018",
            "--ignore",
            "DL3027",
            "--ignore",
            "DL3047",
            "--ignore",
            "DL4006",
          },
        }))
      end,

      -- Yaml
      ["yamllint"] = function()
        null_ls_register(builtins.diagnostics.yamllint)
      end,

      ["yamlfmt"] = function()
        null_ls_register(builtins.formatting.yamlfmt)
      end,

      -- cspell
      ["cspell"] = function()
        null_ls_register(builtins.diagnostics.cspell.with({
          extra_args = local_config.cspell_extra_args,
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity["HINT"]
          end,
          condition = function()
            return local_config.enable_cspell
          end,
        }))
        null_ls_register(builtins.code_actions.cspell)
      end,

      -- clang-format
      -- ["clang-format"] = function()
      --   null_ls_register(builtins.formatting.clang_format)
      -- end,
    },
  })
end

local mason_dap_setup = function()
  local default_setup = require('mason-nvim-dap').default_setup

  require("mason-nvim-dap").setup({
    ensure_installed = {
      "bash",
      -- required packages:
      --     sudo apt install -y gdb libc++-dev libc++abi-dev libstdc++-12-dev
      "codelldb", -- C/C++/Rust
      "cppdbg",   -- C/C++
      -- "haskell",
    },
    handlers = {
      cppdbg = function(config) default_setup(config) end,
      bash = function(config) default_setup(config) end,
      codelldb = function(config) default_setup(config) end,
    },
  })
end

local mason_setup = function()
  require("mason").setup({})

  mason_lspconfig_setup()
  null_ls_setup()
  mason_null_ls_setup()
  mason_dap_setup()
end

local pkg_config = {
  "nvimtools/none-ls.nvim",
  branch = "main",
  event = "VeryLazy",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "jayp0521/mason-null-ls.nvim" },
    { "jay-babu/mason-nvim-dap.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    -- { "davidmh/cspell.nvim" },
  },
  config = function()
    mason_setup()
  end,
}

if os.getenv("NVIM_DAP_DEBUG_ENABLE") ~= nil then
  pkg_config.event = nil
end

return { pkg_config }
