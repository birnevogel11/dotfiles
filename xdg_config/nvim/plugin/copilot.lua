require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/folke/sidekick.nvim" },
  }, { confirm = false })

  require("sidekick").setup({
    nes = { enabled = true },
  })

  vim.keymap.set("n", "<C-y>",
    function()
      -- if there is a next edit, jump to it, otherwise apply it if any
      if not require("sidekick").nes_jump_or_apply() then
        return "<C-y>" -- fallback to normal tab
      end
    end,
    { expr = true, desc = "Goto/Apply Next Edit Suggestion",}
  )
  vim.keymap.set("n", "<leader>aa", function() require("sidekick.cli").toggle() end,  { desc = "Sidekick Toggle CLI" })
end)
