local keymap_n = require("yen3.lib.keymap").keymap_n

local lsp_status_setup = function()
  local nvim_status = require("lsp-status")

  nvim_status.config({
    select_symbol = function(cursor_pos, symbol)
      if symbol.valueRange then
        local value_range = {
          ["start"] = {
            character = 0,
            line = vim.fn.byte2line(symbol.valueRange[1]),
          },
          ["end"] = {
            character = 0,
            line = vim.fn.byte2line(symbol.valueRange[2]),
          },
        }

        return require("lsp-status.util").in_range(cursor_pos, value_range)
      end
    end,
    spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  })

  nvim_status.register_progress()
end

local init_lsp_query_keymap = function()
  -- Show active lsp server name
  keymap_n("<leader>dp", function()
    require("yen3.lib.notify").notify("lsp status", require("yen3.plugins.lsp.base").get_activated_lsp())
  end, "Show activated lsp")
end

local lsp_server_sumneko_lua = function()
  require("neodev").setup {}

  local yen3_lsp_base = require("yen3.plugins.lsp.base")

  require("lspconfig").lua_ls.setup(yen3_lsp_base.lsp_create_config({
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
        telemetry = {
          enable = false,
        },
      },
    },
  }))
end

local lsp_server_pylsp = function(extra_pylsp_config)
  local nvim_lsp = require("lspconfig")
  local yen3_lsp_base = require("yen3.plugins.lsp.base")

  local config_local = require("yen3.local")
  local pylsp_config = {
    -- configurationSources = {},
    plugins = {
      flake8 = config_local.pylsp_flake8_config,
      pylsp_mypy = config_local.pylsp_mypy_config,
      pylint = config_local.pylsp_pylint_config,
      rope_autoimport = { enabled = false },
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
    settings = {
      pylsp = pylsp_config,
    },
    true,
  }))

end

local lsp_server_pyright = function()
  local get_pyenv_virtualenv = function()
    if vim.fn.executable("pyenv") ~= 1 then
      return nil
    end

    local raw_name = vim.fn.system({"pyenv", "version"})
    local virtualenv_name = ""
    for token in raw_name:gmatch("%S+") do
      virtualenv_name = token
      break
    end

    return os.getenv("HOME") .. "/.pyenv/versions/" .. virtualenv_name .. "/bin/python3"
  end

  local yen3_lsp_base = require("yen3.plugins.lsp.base")
  local nvim_lsp = require("lspconfig")
  nvim_lsp.pyright.setup(yen3_lsp_base.lsp_create_config({
    before_init = function(_, config)
      config.settings.python.pythonPath = get_pyenv_virtualenv() or "/usr/bin/python3"
    end,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
        }
      }
    }
  }), true)


end

local lsp_server_hls = function()
  -- local nvim_lsp = require("lspconfig")
  local yen3_lsp_base = require("yen3.plugins.lsp.base")

  local hs_on_attach = function(client, bufnr)
    local ht = require("haskell-tools")
    local telescope = require("telescope")
    telescope.load_extension("hoogle")

    local nmap = function(lhs, func, desc)
      keymap_n(lhs, func, desc, bufnr)
    end

    yen3_lsp_base.mk_lsp_on_attach_func()(client, bufnr)

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
      on_attach = hs_on_attach,
      settings = {
        haskell = {
          formattingProvider = "stylish-haskell",
        },
      },
    }),
  })
end

local lsp_server_ruff_lsp = function()
  local nvim_lsp = require("lspconfig")
  local yen3_lsp_base = require("yen3.plugins.lsp.base")

  nvim_lsp.ruff_lsp.setup(yen3_lsp_base.lsp_create_config({
    init_options = {
      settings = {
        args = {"--line-length=119"},
      },
    },
  }, true))
end

local lsp_config_setup = function()
  init_lsp_query_keymap()

  lsp_server_hls() -- Hasekll
  lsp_server_sumneko_lua() -- Lua
  -- lsp_server_pylsp() -- Python
  lsp_server_pyright()
  lsp_server_ruff_lsp()
end

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufRead",
    dependencies = {
      { "nvim-lua/lsp-status.nvim" },
      { "MrcJkb/haskell-tools.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      lsp_config_setup()
      lsp_status_setup()
    end,
  },
  {
    "j-hui/fidget.nvim",
    ft = { "lua", "go", "rust" },
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots",
        },
        align = {
          bottom = true,
        },
        window = {
          blend = 0,
          relative = "editor",
        },
      })
    end,
  },
}
