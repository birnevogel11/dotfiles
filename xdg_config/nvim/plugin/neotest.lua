require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-neotest/neotest-python" },
    { src = "https://github.com/rouge8/neotest-rust" },
    { src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/nvim-neotest/neotest" },
  }, { confirm = false })

  ---@diagnostic disable-next-line: missing-fields
  require("neotest").setup({
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
        runner = "pytest",
        args = { "--log-level", "DEBUG", "-svv" },
      }),
      require("rustaceanvim.neotest")({
        dap = { justMyCode = false },
      }),
    },
  })

  vim.keymap.set("n","<leader>tt", function() require("neotest").run.run() end, { desc = "Neotest: run nearest" })
  vim.keymap.set("n","<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Neotest: run the file" })
  vim.keymap.set("n","<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Neotest: show Test summary" })
  vim.keymap.set("n","<leader>to", function() require("neotest").output_panel.toggle() end, { desc = "Neotest: show output pannel" })
  vim.keymap.set("n","<leader>tw", function() require("neotest").output.open({ enter = true }) end, { desc = "Neotest: show float output window" })
end)
