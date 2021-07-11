" fzf: {{{
autocmd VimEnter * command! Yen3Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--reverse --prompt "> "'}), <bang>0)

autocmd VimEnter * command! Yen3RgCursorWord
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(expand('<cword>')),  1, fzf#vim#with_preview({'options': '--reverse --prompt "> "'}), <bang>0)

noremap <silent><leader>ds :Yen3RgCursorWord<CR>
noremap <silent><leader>dS :Yen3Rg<CR>
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1 foldlevelstart=0
