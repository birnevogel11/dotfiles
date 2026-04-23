require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/kyazdani42/nvim-web-devicons" },
    { src = "https://github.com/folke/trouble.nvim", version = "main" },
  }, { confirm = false })

  require("trouble").setup({
    auto_preview = false,
    modes = {
      symbols = {
        win = {
          position = "left",
          width = 60,
        },
      }
    }
  })

  vim.keymap.set("n", "<leader>dt", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble: toggle buffer" })
  vim.keymap.set("n", "<leader>dT", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble: toggle workspace"  })
  vim.keymap.set("n", "<leader>dr", "<cmd>Trouble lsp_references toggle auto_jump=false<cr>", { desc = "LSP: Reference"  })
end)
