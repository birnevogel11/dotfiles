" fzf: {{{
let g:fzf_preview_window = ['up:50%', 'ctrl-/']

let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 1.0, 'border': 'no' } }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" autocmd VimEnter * command! Yen3BTags
  " \ call fzf#vim#buffer_tags(<q-args>, {'options': '--prompt "λ "'}, <bang>0)

autocmd VimEnter * command! Yen3Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--reverse --prompt "> "'}), <bang>0)
  " \ call fzf#vim#grep(<q-args>, {'left': '80%', 'options': '--reverse --prompt=""'})

autocmd VimEnter * command! Yen3RgCursorWord
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(expand('<cword>')),  1, fzf#vim#with_preview({'options': '--reverse --prompt "> "'}), <bang>0)
  " \ call fzf#vim#grep(<q-args>, {'left': '80%', 'options': '--reverse --prompt="" -q '. shellescape(expand('<cword>'))})

" noremap <silent><leader>o  :Yen3BTags<CR>
noremap <silent><leader>ds :Yen3RgCursorWord<CR>
noremap <silent><leader>dS :Yen3Rg<CR>
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
