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
  "cpp",
  "clojure",
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
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}

local nvim_treesitter_setup = function()
  -- Set foldmethod under treesitter
  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.wo[0][0].foldmethod = 'expr'
  vim.api.nvim_command("set nofoldenable")

  local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

  -- Source: https://codeberg.org/dannyfritz/dotfiles/src/commit/
  --   10662ea68ac49cb4aa7e941e744b9c92f01e2878/mini/lua/utils/treesitter_enable.lua
  vim.api.nvim_create_autocmd('FileType', {
      group = group,
      desc = "Enable treesitter",
      callback =
        function(event)
          local lang = vim.treesitter.language.get_lang(event.match) or event.match

    			if vim.treesitter.query.get(lang, "highlights") then
    				vim.treesitter.start()
    			end
    			if vim.treesitter.query.get(lang, "indents") then
    				vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    			end
    			if vim.treesitter.query.get(lang, "folds") then
    				vim.wo.foldmethod = "expr"
    				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    			end
        end
  })

  -- Define a vim command to install required treesitter-supported language
  vim.api.nvim_create_user_command("TreesitterInstallRequiredLanguage", function()
    require'nvim-treesitter'.install(prerequired_language)
  end, { desc = "Install prerequired treesitter language" })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = nvim_treesitter_setup,
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
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
