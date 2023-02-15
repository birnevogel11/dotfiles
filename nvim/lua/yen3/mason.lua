local nvim_lsp = require("lspconfig")
local local_lsp = require("yen3.lsp")

local M = {}

local null_ls_setup = function()
  local null_ls = require("null-ls")
  local builtins = null_ls.builtins
  null_ls.setup({
    sources = {},
    builtins.hover.dictionary,
  })
end

local mason_lspconfig_setup = function()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "bashls",
      "clangd",
      "dockerls",
      "html",
      "gopls",
      "rust_analyzer",
      "tsserver",
      "purescriptls",
      "marksman",
      "texlab",
    },
  })
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      nvim_lsp[server_name].setup(local_lsp.lsp_create_config())
    end,
    ["purescriptls"] = local_lsp.lsp_server_purescriptls,
  })
end

local mason_null_ls_setup = function()
  local local_config = require("yen3.local")

  local null_ls = require("null-ls")
  local null_ls_register = null_ls.register
  local builtins = null_ls.builtins

  require("mason-null-ls").setup({
    ensure_installed = {
      "black",
      "cspell",
      "hadolint",
      "markdownlint",
      "shellcheck",
      "shfmt",
      "stylua",
      "yamlfmt",
      "yamllint",
      "ruff",
    },
  })

  require("mason-null-ls").setup_handlers({
    -- all sources with no handler get passed here
    function(_) end,

    -- Python
    ["black"] = function()
      null_ls_register(builtins.formatting.black.with({ extra_args = { "-l", "119" } }))
    end,
    ["ruff"] = function()
      null_ls_register(builtins.diagnostics.ruff.with({ extra_args = { "--line-length=119" } }))
      null_ls_register(builtins.formatting.ruff.with({ extra_args = { "--line-length=119" } }))
    end,

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
  })
end

M.mason_setup = function()
  require("mason").setup({})

  mason_lspconfig_setup()
  null_ls_setup()
  mason_null_ls_setup()
end

return M
