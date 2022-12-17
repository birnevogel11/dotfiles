local M = {}

local macos_fix = function()
  if vim.fn.has("mac") == 1 then
    require('nvim-treesitter.install').compilers = { "gcc-12" }

    -- table.insert(M.disable_highlight_lang, "dockerfile")
    -- table.insert(M.disable_highlight_lang, "markdown")
  end
end

M.nvim_treesitter = function()
  macos_fix()

  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help',
      'haskell', 'yaml', 'markdown', 'html', 'json', 'rst', 'toml',
      'dockerfile', 'bash', 'javascript', 'diff', 'dot', 'tsx',
      'git_rebase', 'gitcommit', 'gitignore', 'latex', 'markdown_inline',
    },
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-e>",
        node_incremental = "<c-e>",
        scope_incremental = "<c-s>",
        node_decremental = "<c-backspace>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end

return M
