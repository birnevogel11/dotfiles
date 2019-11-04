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
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['pylint', 'flake8', 'mypy'],
\}
" }}}
" Defx: {{{
nnoremap <leader>f :Defx<CR>
nnoremap <leader>ff :Defx -split=vertical -winwidth=40 -direction=topleft<CR>

" Ref: https://github.com/petobens/dotfiles/blob/master/vim/init.vim
autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
     " Define mappings
      nnoremap <silent><buffer><expr> <CR>
     \ defx#is_directory() ? defx#do_action('open') :
     \ defx#do_action('multi', ['drop'])
      nnoremap <silent><buffer><expr> s
     \ defx#do_action('multi', [['drop', 'split'], 'quit'])
      nnoremap <silent><buffer><expr> v
     \ defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
      nnoremap <silent><buffer><expr> c
     \ defx#do_action('copy')
      nnoremap <silent><buffer><expr> m
     \ defx#do_action('move')
      nnoremap <silent><buffer><expr> p
     \ defx#do_action('paste')
      nnoremap <silent><buffer><expr> l
     \ defx#is_directory() ? defx#do_action('open') :
     \ defx#do_action('multi', ['drop'])
      nnoremap <silent><buffer><expr> K
     \ defx#do_action('new_directory')
      nnoremap <silent><buffer><expr> N
     \ defx#do_action('new_file')
      nnoremap <silent><buffer><expr> d
     \ defx#do_action('remove')
      nnoremap <silent><buffer><expr> r
     \ defx#do_action('rename')
      nnoremap <silent><buffer><expr> x
     \ defx#do_action('execute_system')
      nnoremap <silent><buffer><expr> yy
     \ defx#do_action('yank_path')
      nnoremap <silent><buffer><expr> .
     \ defx#do_action('toggle_ignored_files')
      nnoremap <silent><buffer><expr> h
     \ defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> ~
     \ defx#do_action('cd')
      nnoremap <silent><buffer><expr> q
     \ defx#do_action('quit')
      nnoremap <silent><buffer><expr> <Space>
     \ defx#do_action('toggle_select') . 'j'
      nnoremap <silent><buffer><expr> *
     \ defx#do_action('toggle_select_all')
      nnoremap <silent><buffer><expr> j
     \ line('.') == line('$') ? 'gg' : 'j'
      nnoremap <silent><buffer><expr> k
     \ line('.') == 1 ? 'G' : 'k'
      nnoremap <silent><buffer><expr> <C-l>
     \ defx#do_action('redraw')
      nnoremap <silent><buffer><expr> <C-g>
     \ defx#do_action('print')
      nnoremap <silent><buffer><expr> cd
     \ defx#do_action('change_vim_cwd')
      nnoremap <silent><buffer><expr> <Leader>th
     \ defx#do_action('toggle_ignored_files')
     " Tree editing, opening and closing
      nnoremap <silent><buffer><expr> e
     \ defx#is_directory() ? defx#do_action('open_tree') :
     \ defx#do_action('multi', ['drop', 'quit'])
      nnoremap <silent><buffer><expr> zo defx#do_action('open_tree')
      nnoremap <silent><buffer><expr> zc defx#do_action('close_tree')
      nnoremap <silent><buffer><expr> zr defx#do_action('open_tree_recursive',
     \ [3])
    endfunction
" }}}
" Tagbar: {{{
nnoremap <leader>tb :TagbarToggle<CR>
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
