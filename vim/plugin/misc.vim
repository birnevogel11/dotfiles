" Airline: {{{
let g:airline_powerline_fonts = 0
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline_detect_iminsert = 0
let g:airline#extensions#whitespace#enabled = 0

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
" }}}
" VimFiler: {{{
let g:vimfiler_as_default_explorer = 1

if has("gui_macvim")
	" Like Textmate icons.
	let g:vimfiler_tree_leaf_icon = ' '
	let g:vimfiler_tree_opened_icon = '▾'
	let g:vimfiler_tree_closed_icon = '▸'
	let g:vimfiler_file_icon = '-'
	let g:vimfiler_marked_file_icon = '*'
endif

nnoremap <leader>f :VimFiler<CR>
nnoremap <leader>ff :VimFilerExplorer<CR>

" }}}
" Markdown: {{{
let g:vim_markdown_folding_disabled=1
" }}}
" Doxygentoolkit: {{{

nnoremap <leader>d :Dox<CR>

" }}}
" Pymode: {{{
"
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_rope = 0
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_completion = 0

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" }}}
" Syntastic: {{{

nnoremap <leader>e :Errors<CR>
nnoremap <Leader>ee :SyntasticToggleMode<CR>

let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++ -I./inc'

"" setting for javascript
let g:syntastic_javascript_checkers = ['eslint']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" }}}
" EasyMotion: {{{
"
let g:EasyMotion_leader_key = '\'
nnoremap <Leader>w <Plug>(easymotion-prefix)

" }}}
" ClangFormant: {{{
let g:clang_format#style_options = {
            \ "BasedOnStyle": "LLVM",
            \ "PointerAlignment": "Left",
            \ "UseTab": "Never",
            \ "BreakBeforeBraces": "Allman",
            \ "Standard" : "C++11" }

"" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

"" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)

" }}}
" VimShell: {{{
let g:vimshell_prompt = "$ "
let g:vimshell_user_prompt = 'getcwd()'
" }}}
" Tabline: {{{
hi TabLine      ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineFill  ctermfg=Black  ctermbg=Green     cterm=NONE
hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE
" }}}
" Haskell-Vim: {{{
"let g:haskell_enable_quantification = 1
"let g:haskell_enable_arrowsyntax = 1
"let g:haskell_indent_where = 6
"let g:haskell_indent_do = 3
"let g:haskell_enable_pattern_synonyms = 1
" }}}
" Vim-jsx: {{{
let g:jsx_ext_required = 0
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

" vim: ft=vim foldmethod=marker foldcolumn=1
