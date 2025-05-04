local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set( "n", "gra", function() vim.cmd.RustLsp('codeAction') end, { silent = true, buffer = bufnr })
vim.keymap.set( "n", "K",  function() vim.cmd.RustLsp({'hover', 'actions'}) end, { silent = true, buffer = bufnr, desc = "LSP: hover documentation" })
vim.keymap.set( "n", "<leader>df", vim.diagnostic.open_float, {silent = true, buffer=bufnr, desc="LSP: show line diagnostics"})
