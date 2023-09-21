-- Google Coding style indention
require('yen3.lib.ftplugin').indention_setup(2, 80)

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("yen3_CppAutoBlackFormat", { clear = true }),
  callback = function()
    vim.lsp.buf.format()
  end,
})
-- vim.opt_local.cident = true
-- vim.opt_local.cinoptions = "h1,l1,g1,t0,i4,+4,(0,w1,W4"

-- " Clangformat: {{{
-- " "" map to <Leader>cf in C/C++ code
-- " nnoremap <buffer><leader>bb :<C-u>ClangFormat<cr>
-- " vnoremap <buffer><leader>bf :ClangFormat<cr>
-- " "" if you install vim-operator-user
-- " map <buffer><Leader>x <Plug>(operator-clang-format)
-- " }}}
-- " GNU Coding Style Indention: {{{
-- "setlocal cindent
-- "setlocal tabstop=8
-- "setlocal softtabstop=2
-- "setlocal shiftwidth=2
-- "setlocal noexpandtab
-- "setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,f0,h2,p4,t0,+2,(0,u0,w1,m0
-- "setlocal textwidth=80
-- "setlocal formatoptions-=ro formatoptions+=cqlt
-- " }}}
