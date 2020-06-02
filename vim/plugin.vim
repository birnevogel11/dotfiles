" zM: foldall
" Dein {{{

let g:dein#install_log_filename = expand('$HOME/.cache/dein/dein.log')
let g:dein#install_max_processes = 8

nnoremap <silent> <Leader>ul :execute "edit +" g:dein#install_log_filename<cr>

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

let g:airline_theme='sunsetshiba'
" }}}
" ALE: {{{
let g:ale_completion_enabled = 0

let g:ale_set_quickfix = 1

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['pylint', 'flake8', 'mypy'],
\   'c': ['clang'],
\   'cpp': ['clang-format', 'clang', 'clangd'],
\}

" Shell
let g:ale_sh_shellehck_options = '-e SC2086'

" Python
let g:ale_python_flake8_options = '-e E501 -e W503 -e E203'
let g:ale_python_pylint_options = '--max-line-length=120 -d R0201 -d W503'
" }}}
" ClangFormant: {{{
let g:clang_format#detect_style_file = 1

"" map to <Leader>cf in C/C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><leader>bb :<C-u>ClangFormat<cr>
autocmd FileType c,cpp,objc vnoremap <buffer><leader>bf :ClangFormat<cr>

"" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)

" }}}
" LaTex-Box: {{{
let g:LatexBox_latexmk_preview_continuously = 1
autocmd Filetype tex noremap  <silent><leader>ll :silent !/Applications/Skim.app/Contents/SharedSupport/displayline
  \ <C-R>=line('.')<cr> "<C-R>=LatexBox_GetOutputFile()<cr>" "%:p" <cr>
let g:LatexBox_viewer = 'open -a /Applications/Skim.app'
let g:LatexBox_latexmk_options = "-pdflatex='xelatex -file-line-error -shell-escape -synctex=1'"
let $PATH .= ":/Library/TeX/texbin"

autocmd Filetype tex noremap <silent><F5> :Latexmk<cr>
" }}}
" Tagbar: {{{
nnoremap <silent><leader>tb :TagbarOpen jc<cr>

" Settings
let g:tagbar_map_openfold = ['zo', 'l']
let g:tagbar_map_closeallfolds = 'zm'
let g:tagbar_map_openallfolds = 'zr'

let g:tagbar_width = 40
let g:tagbar_autofocus = 1                 " Keep focus on tagbar window
let g:tagbar_sort = 1                      " Sort tags alphabetically
let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_autopreview = 0               " Don't autopreview, enable it with P
let g:tagbar_previewwin_pos = 'belowright'

if g:yen3_enable_dev_icons == 1
  let g:tagbar_iconchars = ['', '']
endif

let g:tagbar_type_python = {
    \ 'kinds' : [
        \ 'i:modules:1:0',
        \ 'c:classes',
        \ 'f:functions',
        \ 'm:members',
        \ 'v:variables:0:0',
        \ 'x:unknowns',
    \ ],
\ }

let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '/home/yen3/.pyenv/shims/markdown2ctags',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
" }}}
" NerdCommenter: {{{

let g:NERDSpaceDelims = 1                  " Leave space after comment delimiter
let g:NERDCreateDefaultMappings = 0        " Disable default mappings
let g:NERDCustomDelimiters = {'python': {'left': '#'}}  " Fix python spacing

" Mappings (for both normal and visual mode)
map <Leader>cc <Plug>NERDCommenterComment
map <Leader>cu <Plug>NERDCommenterUncomment
map <Leader>ce <Plug>NERDCommenterToEOL
map <Leader>ac <Plug>NERDCommenterAppend

" }}}
" nvim-miniyank: {{{
if has('nvim')
  map p <Plug>(miniyank-autoput)
  map P <Plug>(miniyank-autoPut)
endif
" }}}
" vim-devicons: {{{
if g:yen3_enable_dev_icons == 1
  let g:webdevicons_enable_airline_tabline = 0
  let g:webdevicons_enable_airline_statusline = 0
endif
" }}}
" GV: {{{
function! s:GVYankCommit()
    let commit_hash = matchstr(getline('.'), '-\d\+\s\zs\w*\ze\s')
    call setreg('+', commit_hash)
endfunction

function s:GVNextCommit()
  if winnr('$') > 1
    call search('^.*[a-z0-9]')
  endif
  normal o
endfunction

function s:GVPrevCommit()
  if winnr('$') > 1
    call search('^.*[a-z0-9]', 'b')
  endif
  normal o
endfunction

function s:GVOpen()
  :GV
  normal o
endfunction

function s:GVOpenCurrentFile()
  :GV!
  normal o
endfunction

autocmd FileType git setlocal nofoldenable

augroup ps_gv
  au!
  au FileType GV call s:GVKeyMapping()
augroup END

nnoremap <silent> <leader>gv :call <SID>GVOpen()<cr>
nnoremap <silent> <leader>gV :call <SID>GVOpenCurrentFile()<cr>

function s:GVKeyMapping()
  nmap <silent> <buffer> <C-y> :call <SID>GVYankCommit()<cr>

  nmap <silent> <buffer> j      :call <SID>GVNextCommit()<cr>
  nmap <silent> <buffer> k      :call <SID>GVPrevCommit()<cr>
endfunction
" }}}
" vim-fugitive.vim + gina.vim: {{{
function! s:FugitiveGitCommand()
  let l:cmd_args=input('git ')
  execute("Git " . l:cmd_args)
endfunction

nnoremap          <leader>g   :call <SID>FugitiveGitCommand()<cr>

nnoremap          <leader>gco :Git checkout

nnoremap <silent> <leader>gs  :vertical topleft Gstatus<cr>

nnoremap <silent> <leader>gA  :Git add --patch<cr>

nnoremap <silent> <leader>gd  :Git diff<cr>
nnoremap <silent> <leader>gD  :Gvdiffsplit!<cr>
nnoremap <silent> <leader>gb  :Gblame<cr>
nnoremap <silent> <leader>gB  :Gina blame<cr>

nnoremap <silent> <leader>gp  :Git push<cr>
nnoremap <silent> <leader>gpp :Gina!! push origin HEAD:refs/for/master<cr>
nnoremap <silent> <leader>gP  :Git pull<cr>

nnoremap <silent> <leader>gr  :Git rebase -i origin/master<cr>
nnoremap <silent> <leader>gri :Git rebase -i
" }}}
" vim-gitmessenger: {{{
nnoremap <silent> <leader>gm  :GitMessenger<cr>
" }}}
" vim-extradite: {{{
nnoremap <silent> <leader>gM  :Extradite!<cr>
" }}}
" vim-signify: {{{
set updatetime=1000
" }}}
" vim-markdown {{{
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_override_foldtext = 0
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
" }}}
" python-black {{{
let g:black_linelength=120
let g:black_virtualenv="~/.local/share/nvim/black"

autocmd FileType python nnoremap <buffer><leader>bb :Black<cr>
" }}}
" vim-cpp-enhanced-highlight: {{{
let g:load_doxygen_syntax=1
let g:cpp_class_scope_highlight = 1
" }}}
" vim-localvimrc: {{{
let g:localvimrc_ask = 0
" }}}
" COOL: {{{
au BufNewFile,BufRead *.cool set ft=cool
au BufNewFile,BufRead *.cl set ft=cool
" }}}
" IndentLine: {{{
let g:indentLine_char = '│'
let g:indentLine_faster     = 1
" }}}
" Neoformat: {{{
let g:neoformat_enabled_c= ['clang-format']
let g:neoformat_enabled_cpp = ['clang-format']
let g:neoformat_enabled_python = ['black']

let g:neoformat_python_black= {
  \ 'exe': 'black',
  \ 'stdin': 1,
  \ 'args': ['-l', 119, '-q', '-'],
  \ }
" }}}


" vim: ft=vim foldmethod=marker foldcolumn=1
