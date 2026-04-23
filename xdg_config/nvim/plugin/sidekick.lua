require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/folke/sidekick.nvim" },
  }, { confirm = false })

  require("sidekick").setup({
    nes = { enabled = true },
  })

  vim.keymap.set("n", "<tab>",
    function()
      -- if there is a next edit, jump to it, otherwise apply it if any
      if not require("sidekick").nes_jump_or_apply() then
        return "<tab>" -- fallback to normal tab
      end
    end,
    { expr = true, desc = "Goto/Apply Next Edit Suggestion",}
  )
  vim.keymap.set("n", "<leader>aa",
    function()
      require("sidekick.cli").toggle({ name = "copilot" })
    end,  { desc = "Sidekick: Toggle CLI" })
  vim.keymap.set({"x", "n"}, "<leader>at",
    function()
      require("sidekick.cli").send({ msg = "{this}" })
    end, { desc = "Sidekick: Send This" })


  vim.keymap.set("n", "<leader>af",
    function()
      require("sidekick.cli").send({ msg = "{file}" })
    end, { desc = "Sidekick: Send File" })
  vim.keymap.set("x", "<leader>av",
    function()
      require("sidekick.cli").send({ msg = "{selection}" })
    end, { desc = "Sidekick: Send Visual Selection" })
end)
