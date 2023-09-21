local set_variables = function(variables)
  for k, v in pairs(variables) do
    vim.api.nvim_set_var(k, v)
  end
end

local clangd_extensions_setup = function()
  require("clangd_extensions").setup({
      ast = {
        role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
        },

        kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
        },
      },
  })

  local keymap_n = require("yen3.lib.keymap").keymap_n
  keymap_n("<leader>fh", ":ClangdSwitchSourceHeader<cr>", "Switch C/C++ source header")
  keymap_n("<leader>dh", ":ClangdTypeHierarchy<cr>", "Show the type hierarchy")
  keymap_n("<leader>nr", ":ClangdToggleInlayHints<cr>", "Toggle inlay hints")
end

return {
  -- Bitbake
  { "kergoth/vim-bitbake", ft = { "bitbake" } },

  -- C/C++
  { "p00f/clangd_extensions.nvim", ft = { "c", "cpp" }, config = clangd_extensions_setup },

  -- CSV
  -- { "chrisbra/csv.vim", ft = "csv" },

  -- Dhall
  -- { "vmchale/dhall-vim", ft = "dhall" },

  -- Haskell
  -- { "alx741/vim-stylishask", ft = "haskell" },
  -- { "ndmitchell/ghcid", ft = "haskell", rtp = "plugins/nvim" },

  -- JavaScript/TypeScript
  -- local js_types = { "javascript", "typescript", "typescriptreact" }
  -- { "alvan/vim-closetag", ft = js_types },
  -- { "pangloss/vim-javascript", ft = js_types },
  -- { "mxw/vim-jsx", ft = js_types },
  -- { "othree/yajs.vim", ft = js_types },
  -- { "HerringtonDarkholme/yats.vim", ft = js_types, build = "rm -rf UltiSnips" },
  -- { "turbio/bracey.vim", ft = js_types, build = "npm install --prefix server" },
  -- { "prettier/vim-prettier", ft = js_types },

  -- Log
  { "mtdl9/vim-log-highlighting", ft = { "log" } },

  -- Lua
  { "folke/lua-dev.nvim", ft = "lua" },
  {
    "folke/neodev.nvim",
    ft = { "lua" },
    opts = {},
  },

  -- Markdown
  { "iamcco/markdown-preview.nvim", ft = "markdown", build = "cd app && yarn install" },

  -- Purescript
  { "purescript-contrib/purescript-vim", ft = { "purescript" } },

  -- Yaml
  -- { "pearofducks/ansible-vim", ft = { "yaml", "ansible", "yaml.ansible" } },

  -- TeX
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      if vim.fn.has("mac") == 1 then
        set_variables({
          vimtex_view_method = "skim",
          vimtex_view_general_viewer = "skim",
          vimtex_syntax_conceal_disable = 0,
        })

        -- <leader>ll - Compile and open skim in macOS
        -- <leader>lv - Open skim in macOS
      end
    end,
  },

  -- TOML
  { "cespare/vim-toml", ft = "toml" },

  -- Go
  {
    "ray-x/go.nvim",
    ft = "go",
    config = function()
      require("go").setup()

      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimport()
        end,
        group = format_sync_grp,
      })
    end,
  },

  -- Racket
  -- { "wlangstroth/vim-racket", ft = "racket" },

  -- PlantUML
  {
    "aklt/plantuml-syntax",
    ft = "plantuml",
    config = function()
      vim.api.nvim_set_var("plantuml_set_makeprg", 0)
    end,
  },
  {
    "https://gitlab.com/itaranto/plantuml.nvim",
    ft = "plantuml",
    opts = {
      renderer = {
        type = "imv",
        options = {
          dark_mode = false,
        },
      },
    },
  },
  -- { "skanehira/preview-uml.vim", cmd = { "PreviewUML" },
  --   config = function() vim.api.nvim_set_var("preview_uml_url", "http://localhost:8080") end
  -- },
}
