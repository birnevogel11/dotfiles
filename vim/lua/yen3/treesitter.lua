local M = {}

M.ignore_install_lang = {'tex', 'grammar.js'}
M.disable_highlight_lang = {'yaml'}

function M.set_treesitter_compiler()
  if vim.fn.has("mac") == 1 then
    require'nvim-treesitter.install'.compilers = { "gcc-11" }
  elseif vim.fn.has("unix") == 1 then
    require'nvim-treesitter.install'.compilers = { "clang-12" }
  end
end

function M.nvim_treesitter()
  if vim.fn.has("mac") == 1 then
    table.insert(M.disable_highlight_lang, "dockerfile")
    table.insert(M.disable_highlight_lang, "haskell")
  end

  require'nvim-treesitter.configs'.setup {
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
  }
end

function M.setup()
  M.set_treesitter_compiler()
  M.nvim_treesitter()
end

return M
