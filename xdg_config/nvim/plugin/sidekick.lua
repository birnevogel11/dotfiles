if vim.env.NVIM_DISABLE_COPILOT == nil then
  require("beaver.lazyload").on_vim_enter(function()
    vim.pack.add({
      { src = "https://github.com/folke/sidekick.nvim" },
    }, { confirm = false })

    require("sidekick").setup({
      nes = { enabled = true },
    })

    local cli = require("sidekick.cli")
    -- Try to enable with blink
    -- vim.keymap.set("n", "<tab>",
    --   function()
    --     -- if there is a next edit, jump to it, otherwise apply it if any
    --     if not require("sidekick").nes_jump_or_apply() then
    --       return "<C-i>" -- fallback to normal tab
    --     end
    --   end,
    --   { expr = true, desc = "Goto/Apply Next Edit Suggestion",}
    -- )
    vim.keymap.set("n", "<leader>aa", function() cli.toggle({ name = "copilot" }) end,  { desc = "Sidekick: Toggle CLI" })
    vim.keymap.set({"x", "n"}, "<leader>at", function() cli.send({ msg = "{this}" }) end, { desc = "Sidekick: Send This" })

    vim.keymap.set("n", "<leader>af", function() cli.send({ msg = "{file}" }) end, { desc = "Sidekick: Send File" })
    vim.keymap.set("x", "<leader>av", function() cli.send({ msg = "{selection}" }) end, { desc = "Sidekick: Send Visual Selection" })
    vim.keymap.set({"n", "x"}, "<leader>ap", function() cli.prompt() end, { desc = "Sidekick: Select prompt" })
  end)
end
