" Keymap for vim-rust
set hidden

let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

augroup Racer
  autocmd!
  autocmd FileType rust nnoremap <buffer> <c-]>       <Plug>(rust-def)
  autocmd FileType rust nnoremap <buffer> gd          <Plug>(rust-def)
  autocmd FileType rust nnoremap <buffer> K           <Plug>(rust-doc)
augroup END

nnoremap <buffer> <leader>bb  :Autoformat<cr>
