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

  vim.keymap.set("n", "<leader>fh", ":ClangdSwitchSourceHeader<cr>", { desc = "Switch C/C++ source header" })
  vim.keymap.set("n", "<leader>dh", ":ClangdTypeHierarchy<cr>", { desc = "Show the type hierarchy" })
  vim.keymap.set("n", "<leader>ww", ":ClangdToggleInlayHints<cr>", { desc = "Toggle inlay hints" })
end

return {
  -- Bitbake
  { "kergoth/vim-bitbake", ft = { "bitbake" } },

  -- C/C++
  -- { "p00f/clangd_extensions.nvim", ft = { "c", "cpp" }, config = clangd_extensions_setup },

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
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Library items can be absolute paths
        -- "~/projects/my-awesome-lib",
        -- Or relative, which means they will be resolved as a plugin
        -- "LazyVim",
        -- When relative, you can also provide a path to the library in the plugin dir
        -- "luvit-meta/library", -- see below
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

  -- Markdown
  { "iamcco/markdown-preview.nvim", ft = "markdown", build = "cd app && yarn install" },
  -- { "jmbuhr/otter.nvim", ft = "markdown" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ft = "markdown",
    opts = {},
  },
  {
    "mpas/marp-nvim",
    ft = "markdown",
    opts = {
      port = 10088,
      wait_for_response_timeout = 30,
      wait_for_response_delay = 1,
    }
  },

  -- Purescript
  { "purescript-contrib/purescript-vim", ft = { "purescript" } },

  -- Python
  {
    "chrisgrieser/nvim-puppeteer",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = false, -- plugin lazy-loads itself
  },

  -- {
  --   'MeanderingProgrammer/py-requirements.nvim',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --       require('py-requirements').setup({
  --         file_patterns = { 'requirements.txt', 'constraints.in' },
  --       })
  --   end,
  -- },

  -- Yaml
  -- { "pearofducks/ansible-vim", ft = { "yaml", "ansible", "yaml.ansible" } },

  -- TeX
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      if vim.fn.has("mac") == 1 then
        vim.api.nvim_set_var("vimtex_view_method", "skim")
        vim.api.nvim_set_var("vimtex_view_general_viewer", "skim")
        vim.api.nvim_set_var("vimtex_syntax_conceal_disable", 0)

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

  -- jinja2
  { "Glench/Vim-Jinja2-Syntax" },
}
