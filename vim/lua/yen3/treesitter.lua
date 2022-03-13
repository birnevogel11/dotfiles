local M = {}

M.ignore_install_lang = {'tex', 'grammar.js'}
M.disable_highlight_lang = {'yaml', 'haskell', 'vim', 'purescript'}

M.set_treesitter_compiler = function()
  if vim.fn.has("mac") == 1 then
    require'nvim-treesitter.install'.compilers = { "gcc-11" }
  elseif vim.fn.has("unix") == 1 then
    require'nvim-treesitter.install'.compilers = { "gcc" }
  end
end

M.nvim_treesitter = function()
  M.set_treesitter_compiler()

  if vim.fn.has("mac") == 1 then
    table.insert(M.disable_highlight_lang, "dockerfile")
  end

  require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
    ignore_install = M.ignore_install_lang,
    highlight = {
      enable = true,
      disable = M.disable_highlight_lang,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    textobjects = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
  }
end

return M
