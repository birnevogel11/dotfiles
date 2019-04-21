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

let g:vimfiler_ignore_pattern = '^\%(\.git\|\.DS_Store\)$'

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
" ALE: {{{
let g:ale_completion_enabled = 0
let g:ale_lint_on_enter = 0

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['pylint', 'flake8'],
\}
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
