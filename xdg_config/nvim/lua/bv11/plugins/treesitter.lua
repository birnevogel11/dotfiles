local ignore_filetypes = {
  'checkhealth',
  'lazy',
  'mason',
  'snacks_dashboard',
  'snacks_notif',
  'snacks_win',
}

local prerequired_language = {
  "bash",
  "c",
  "clojure",
  "cpp",
  "diff",
  "dockerfile",
  "dot",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "go",
  "haskell",
  "hcl",
  "html",
  "javascript",
  "json",
  "json5",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "requirements",
  "rst",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}


return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Set foldmethod under treesitter
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      vim.api.nvim_command("set nofoldenable")

      -- Define a vim command to install required treesitter-supported language
      vim.api.nvim_create_user_command("TSInstallRequiredLanguage", function()
        for _, lang in ipairs(prerequired_language) do
          vim.cmd( ":TSInstall " ..  lang)
        end
        -- require'nvim-treesitter'.install(prerequired_language)
      end, { desc = "Install prerequired treesitter language" })
    end,
  },

  -- { "nvim-treesitter/nvim-treesitter-textobjects", event = { "BufReadPost" },
  --   branch = "main",
  --   dependencies = { "nvim-treesitter/nvim-treesitter", branch = "main" },
  -- },

  -- { "LiadOz/nvim-dap-repl-highlights",
  --   config = function()
  --     require('nvim-dap-repl-highlights').setup()
  --   end
  -- },
}
