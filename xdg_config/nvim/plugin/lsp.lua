local enabled_lsp = {
  "ansiblels",
  'zuul_ls',

  'copilot',

  'ruff',
  "basedpyright",

  "bashls",
  "bitbake_ls",
  "clangd",
  "copilot",
  "docker_compose_language_service",
  "dockerls",
  "esbonio", -- sphinx
  "html",
  "jinja_lsp",
  "jsonls",
  "lua_ls",
  "marksman",

  -- "cssls",
  -- "emmet_language_server",
  -- "gopls",
  -- "ltex",
  -- "purescriptls",
  -- "taplo",
  -- "texlab",
  -- "volar",
}

local get_activated_lsp = function()
  local get_buf_activated_lsp = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if next(clients) == nil then
      return nil
    end

    local client_names = {}
    for _, client in ipairs(clients) do
      table.insert(client_names, client.name)
    end

    return client_names
  end

  local lsp_names = get_buf_activated_lsp()
  if lsp_names == nil then
    return "No Active LSP"
  end

  local info_lines = vim.fn.copy(lsp_names) or {}
  local progress = require("lsp-status").status_progress() or ""
  if progress ~= "" then
    table.insert(info_lines, progress)
  end

  return vim.fn.join(info_lines, "\n")
end

local lsp_server_basedpyright = function()
  vim.lsp.config('basedpyright', {
    settings = {
      single_file_support = true,
      basedpyright = {
        analysis = {
          typeCheckingMode = "off",
          diagnosticMode = "openFilesOnly",
        },
        disableOrganizeImports = true,
        reportMissingTypeStubs = false,
      },
    }
  })
end

local lsp_server_ansiblels = function()
  vim.lsp.config('ansiblels', {
    settings = {
      ansible = {
        ansible = {
          useFullyQualifiedCollectionNames = false,
        },
        validation = {
          enabled = true,
          lint = {
            arguments = { "-c", os.getenv("HOME") .. "/usr/rc/xdg_config/ansible-lint/ansible-lint-config.yaml" },
          }
        },
      },
    }
  })
end

local lsp_server_lua_ls = function()
  vim.lsp.config('lua_ls', {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc')) then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT'
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME
            -- Depending on the usage, you might want to add additional paths here.
            -- "${3rd}/luv/library"
            -- "${3rd}/busted/library",
          }
          -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
          -- library = vim.api.nvim_get_runtime_file("", true)
        }
      })
    end,
    settings = {
      Lua = {}
    }
  })
end

local lsp_server_zuul_ls = function()
  vim.lsp.config("zuul_ls", {
     cmd = { os.getenv("HOME") .. "/Trek/zuul-ls/target/release/zuul-ls" },
  })
end

local lsp_server_copilot = function()
  local auth_provider_url = vim.env.NVIM_GITHUB_COPILOT_URL or nil
  if auth_provider_url ~= nil then
    vim.lsp.config("copilot", {
      settings = {
        ["github-enterprise"] = {
          uri = auth_provider_url
        }
      }
    })
  end
end

local add_legacy_lsp_commands = function()
  vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", { desc = "Show LSP Info", })
  vim.api.nvim_create_user_command("LspLog", function(_)
    local state_path = vim.fn.stdpath("state")
    local log_path = vim.fs.joinpath(state_path, "lsp.log")
    vim.cmd(string.format("edit %s", log_path))
  end, { desc = "Show LSP log", })
  vim.api.nvim_create_user_command("LspRestart", "lsp restart", { desc = "Restart LSP", })
  vim.api.nvim_create_user_command("LspStart", "lsp start", { desc = "Start LSP", })
  vim.api.nvim_create_user_command("LspStop", "lsp stop", { desc = "Stop LSP", })
end

local configure_lsp_server = function()
  lsp_server_ansiblels()
  lsp_server_basedpyright()
  lsp_server_lua_ls()
  lsp_server_zuul_ls()
  lsp_server_copilot()
end


-- require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/nvim-lua/lsp-status.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
  }, { confirm = false })


  -- Extend LSP capabilities with blink.cmp completions for all servers.
  vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
  })

  add_legacy_lsp_commands()
  configure_lsp_server()

  vim.lsp.enable(enabled_lsp)

  -- Enable inlay hint globally
  vim.lsp.inlay_hint.enable(true)

  -- Enable codelens globally
  -- vim.lsp.codelens.enable(true)

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buf = args.buf

      if client then
        -- Disable documentColor
        client.server_capabilities.semanticTokensProvider = nil

        -- Keymap
        vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, {desc = "LSP: show line diagnostics", buffer = buf})
        vim.keymap.set("n", "<leader>dc", vim.lsp.codelens.run, { buffer = buf, desc = "Run codelens" })
        vim.keymap.set("n", "<leader>df", Snacks.rename.rename_file, { buffer = buf, desc = "Rename file" })

        -- Inline completion
        if client:supports_method("textDocument/inlineCompletion", buf) then
          vim.lsp.inline_completion.enable(true)

          -- Try to enable it with blink
          vim.keymap.set("i", "<C-r>",
            function()
              if not vim.lsp.inline_completion.get() then
                return "<C-r>"
              end
            end,
            { expr = true, replace_keycodes = true, desc = "Accept inline completion" })
        end

        -- Linked editing (e.g., paired HTML tags)
        if client:supports_method("textDocument/linkedEditingRange", buf) then
          vim.lsp.linked_editing_range.enable(true, { bufnr = buf })
        end
      end
    end
  })

  vim.keymap.set("n", "<leader>ww", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, {desc = "LSP: Toogle inlay_hint"})
  vim.keymap.set("n", "<leader>wl", function() vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled()) end, {desc = "LSP: Toogle inlay_hint"})
  vim.keymap.set('n', '<leader>dp', function() vim.notify("lsp servers: " .. get_activated_lsp()) end, { desc = "LSP: Show activated lsp" })
-- end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/j-hui/fidget.nvim" },
  }, { confirm = false })

  require("fidget").setup({
    progress = {
      ignore = {
        "basedpyright",
      }
    }
  })
end)
