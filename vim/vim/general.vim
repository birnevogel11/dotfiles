" Disable readonly warning: {{{
augroup no_ro_warn
    au!
    au FileChangedRO * set noreadonly
augroup END
" }}}
" Programming: {{{
function s:yen3_remove_unncessary_space()
  "" Remove trailing space
  call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

  " Remove blank lines in the end of file
  :%s#\($\n\s*\)\+\%$##
endfunction

augroup remove_unnecessary_space
  au!
  autocmd FileType *
    \ autocmd BufWritePre <buffer>
    \ :silent! call s:yen3_remove_unncessary_space()
augroup END

set completeopt-=preview
"}}}
" Split and window {{{
" set splitbelow

" Resize splits when the Vim window is resized
augroup vim_resized
  au!
  au VimResized * :wincmd =
augroup END

" Only show cursorline in the current window
augroup cline
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * if &filetype !=# 'denite' | setlocal nocursorline | endif
augroup END
" }}}
" Quickfix {{{
command! -bang -nargs=? QFix call QFixToggle(<bang>0)

function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction

nnoremap <silent> <leader>qf :QFix<cr>
nnoremap <silent> ]q :<C-U>execute v:count1 . 'cnext'<CR>
nnoremap <silent> [q :<C-U>execute v:count1 . 'cprevious'<CR>
" }}}
"
" vim: ft=vim foldmethod=marker foldcolumn=1
