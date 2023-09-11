require("yen3.lib.ftplugin").indention_setup(4, 119)

vim.opt.colorcolumn = "79,119"

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("yen3_PythonAutoBlackFormat", { clear = true }),
  callback = function()
    vim.lsp.buf.format({
      filter = function(client)
        return client.name == "null-ls"
      end,
    })
  end,
})
