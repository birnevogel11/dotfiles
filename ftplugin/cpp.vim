" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

" GNU Coding Style
"setlocal cindent
"setlocal tabstop=8
"setlocal softtabstop=2
"setlocal shiftwidth=2
"setlocal noexpandtab
"setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,f0,h2,p4,t0,+2,(0,u0,w1,m0
"setlocal textwidth=80
"setlocal formatoptions-=ro formatoptions+=cqlt

" Google Coding Style
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab
setlocal textwidth=80
setlocal wrap

setlocal cindent
setlocal cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4

" Remap the shortcut to jump to defnition
if g:yen3_auto_complete_enable_lsp == 1
  autocmd FileType cpp nnoremap <c-]> :call Yen3GoToDefinition()<cr>
endif
