" Keymap for vim-rust
set hidden

if has("mac")
  let g:deoplete#sources#rust#racer_binary='/Users/yen3/.cargo/bin/racer'
  let g:deoplete#sources#rust#rust_source_path='/Users/yen3/.cargo/'
else
  let g:deoplete#sources#rust#racer_binary='/home/yen3/.cargo/bin/racer'
endif

let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

augroup Racer
  autocmd!
  autocmd FileType rust nmap <buffer> <c-]>  <Plug>(rust-def)
  autocmd FileType rust nmap <buffer> gd     <Plug>(rust-def)
  autocmd FileType rust nmap <buffer> K      <Plug>(rust-doc)
augroup END
