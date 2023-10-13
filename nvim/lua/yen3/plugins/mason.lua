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

local mason_dap_setup = function()
  local default_setup = require("mason-nvim-dap").default_setup

  require("mason-nvim-dap").setup({
    ensure_installed = {
      "bash",
      -- required packages:
      --     sudo apt install -y gdb libc++-dev libc++abi-dev libstdc++-12-dev
      "codelldb", -- C/C++/Rust
      "cppdbg", -- C/C++
      -- "haskell",
    },
    handlers = {
      cppdbg = function(config)
        default_setup(config)
      end,
      bash = function(config)
        default_setup(config)
      end,
      codelldb = function(config)
        default_setup(config)
      end,
    },
  })
end

local conform_setup = function()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      shell = { "shfmt" },
    },
  })

  local extend_conform_lint_args = function(name, extra_args)
    local util = require("conform.util")
    local linter = require("conform.formatters." .. name)
    require("conform").formatters[name] = vim.tbl_deep_extend("force", linter, {
      args = util.extend_args(linter.args, extra_args),
      range_args = util.extend_args(linter.range_args, extra_args),
    })
  end

  extend_conform_lint_args("black", { "-l", "119" })
  extend_conform_lint_args("shfmt", { "-i", "2", "-ci" })
  extend_conform_lint_args("stylua", { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "120" })
end

local nvim_lint_setup = function()
  require("lint").linters_by_ft = {
    shell = { "shellcheck" },
    python = { "mypy" },
    dockerfile = { "hadolint" },
    markdown = { "markdownlint" },
    yaml = { "yamllint" },
  }

  require("lint").linters.hadolint.args = {
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
    "-f",
    "json",
    "-",
  }
end

local mason_setup = function()
  require("mason").setup({})

  require("mason-tool-installer").setup({
    ensure_installed = {
      "cspell",
      "hadolint",
      "markdownlint",
      "shellcheck",
      "shfmt",
      "stylua",
      "yamlfmt",
      "yamllint",
    },
  })

  mason_lspconfig_setup()
  conform_setup()
  nvim_lint_setup()
  -- null_ls_setup()
  -- mason_null_ls_setup()
  mason_dap_setup()
end

local pkg_config = {
  -- "nvimtools/none-ls.nvim",
  "williamboman/mason.nvim",
  branch = "main",
  event = "VeryLazy",
  dependencies = {
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    { "stevearc/conform.nvim" },
    { "mfussenegger/nvim-lint" },
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
