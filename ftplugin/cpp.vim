" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

" set indent - llvm style
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

" Disable Youcompleteme autocomplete
let g:ycm_auto_trigger = 0
let g:ycm_key_invoke_completion = '<C-l>'

