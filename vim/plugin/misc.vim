" Vim-polyglot: {{{
let g:polyglot_disabled = ['python']
" }}}
" Airline: {{{
let g:airline_powerline_fonts = 0
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline_detect_iminsert = 0

let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }

let g:airline_left_sep='>'
let g:airline_right_sep='<'
let g:airline_theme='minimalist'
" }}}
" VimFiler: {{{
let g:vimfiler_as_default_explorer = 1

nnoremap <leader>f :VimFiler<CR>
nnoremap <leader>ff :VimFilerExplorer<CR>

" }}}
" ClangFormant: {{{
"let g:clang_format#style_options = {
            "\ "BasedOnStyle": "google",
            "\ "PointerAlignment": "Left",
            "\ "UseTab": "Never",
            "\ "BreakBeforeBraces": "Allman",
            "\ "Standard" : "C++11" }

let g:clang_format#style_options = {
            \ "BasedOnStyle": "google",
            \ "Standard" : "C++11" }

"" map to <Leader>cf in C/ C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

"" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)

" }}}
" Tabline: {{{
hi TabLine      ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineFill  ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE
" }}}
" LaTex-Box: {{{
let g:LatexBox_latexmk_preview_continuously = 1
autocmd Filetype tex noremap  <silent><leader>ll :silent !/Applications/Skim.app/Contents/SharedSupport/displayline
  \ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>" "%:p" <CR>
let g:LatexBox_viewer = 'open -a /Applications/Skim.app'
let g:LatexBox_latexmk_options = "-pdflatex='xelatex -file-line-error -shell-escape -synctex=1'"
let $PATH .= ":/Library/TeX/texbin"

autocmd Filetype tex noremap <silent><F5> :Latexmk<CR>
" }}}
" Syntastic: {{{
nnoremap <leader>e :Errors<CR>
nnoremap <Leader>ee :SyntasticToggleMode<CR>

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_loc_list = 0

"" Set C/ C++ syntax checker
if has("mac")
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++ -I./inc'
else
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -Wall -Wextra -std=c++11'
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_compiler_options = ' -Wall -Wextra -std=c++11'
endif

let g:syntastic_cpp_cpplint_exec = "cpplint"
let g:syntastic_cpp_checkers = ['cpplint']
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
