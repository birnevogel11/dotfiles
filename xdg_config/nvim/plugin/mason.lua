local required_programs = {
  "ansible-language-server",
  "ansible-lint",
  -- "basedpyright",
  "bash-debug-adapter",
  "bash-language-server",
  "cljfmt",
  "clojure-lsp",
  "copilot-language-server",
  -- "cspell",
  "debugpy",
  "docker-compose-language-service",
  "dockerfile-language-server",
  "hadolint",
  "html-lsp",
  "jinja-lsp",
  "json-lsp",
  "lua-language-server",
  "markdownlint",
  "marksman",
  "prettier",
  "ruff",
  "shellcheck",
  "shfmt",
  "stylua",
  "vue-language-server",
  "yaml-language-server",
  "yamlfmt",
  "yamllint",
  "yq",
  -- "codelldb",
  -- "cpptools",
  "ty",
}

local ensure_installed_lsp = {
  "ansiblels",
  -- "basedpyright",
  "bashls",
  "docker_compose_language_service",
  "dockerls",
  -- "esbonio", -- sphinx
  "html",
  "jinja_lsp",
  "jsonls",
  "lua_ls",
  "marksman",
}

local ensure_installed_dap = {
  "bash",
  -- required packages:
  --     sudo apt install -y gdb libc++-dev libc++abi-dev libstdc++-12-dev
  -- "codelldb", -- C/C++/Rust
  -- "cppdbg", -- C/C++
  -- "haskell",
}

local mason_lspconfig_setup = function()
  require("mason-lspconfig").setup({
    automatic_enable = true,
    automatic_installation = true,
    ensure_installed = ensure_installed_lsp,
  })
end

local mason_dap_setup = function()
  require("mason-nvim-dap").setup({
    ensure_installed = ensure_installed_dap,
    automatic_installation = true,
    handlers = {
      function(config)
        require('mason-nvim-dap').default_setup(config)
      end
    }
  })
end

local mason_setup = function()
  require("mason").setup({})
  mason_lspconfig_setup()
  mason_dap_setup()

  -- Define a vim command to install required Mason packages
  vim.api.nvim_create_user_command("MasonInstallRequiredPackages", function()
    for _, item in ipairs(required_programs) do
      vim.cmd("MasonInstall " .. item)
    end
  end, { desc = "Install required packages" })
end

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/mfussenegger/nvim-dap" },
  }, { confirm = false })

  mason_setup()
end)
