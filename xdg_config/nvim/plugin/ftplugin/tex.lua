require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/lervag/vimtex" },
  }, { confirm = false })

  if vim.fn.has("mac") == 1 then
    vim.api.nvim_set_var("vimtex_view_method", "skim")
    vim.api.nvim_set_var("vimtex_view_general_viewer", "skim")
    vim.api.nvim_set_var("vimtex_syntax_conceal_disable", 0)

    -- <leader>ll - Compile and open skim in macOS
    -- <leader>lv - Open skim in macOS
  end
end)
