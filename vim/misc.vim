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

let g:airline_theme='minimalist'
" }}}
" ClangFormant: {{{
let g:clang_format#style_options = {
            \ "BasedOnStyle": "google",
            \ "Standard" : "C++11" }

"" map to <Leader>cf in C/C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<cr>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<cr>

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
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
    \ ]
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
" GV {{{
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
" fugitive.vim {{{
function! s:FugitiveGitUpdate()
  execute("Git add .")
  execute("Gcommit --amend --no-edit")
endfunction

function! s:FugitiveGitCommitWithMessage()
  let l:commit_msg=input('commit msg: ')
  execute("Gcommit -m \"" . l:commit_msg. "\"" )
endfunction

function! s:FugitiveGitCommand()
  let l:cmd_args=input('git ')
  execute("Git " . l:cmd_args)
endfunction

nnoremap          <leader>g   :call <SID>FugitiveGitCommand()<cr>

nnoremap          <leader>gc  :call <SID>FugitiveGitCommitWithMessage()<cr>
nnoremap <silent> <leader>gs  :vertical topleft Gstatus<cr>

nnoremap <silent> <leader>gA  :Git add --patch<cr>
nnoremap <silent> <leader>gu  :call <SID>FugitiveGitUpdate()<cr>

nnoremap <silent> <leader>gd  :Gvdiffsplit!<cr>

nnoremap <silent> <leader>gp  :Gpush<cr>
nnoremap <silent> <leader>gP  :Gpull<cr>
nnoremap <silent> <leader>gpp :Gpush origin HEAD:refs/for/master<cr>

nnoremap <silent> <leader>gr  :Git rebase -i origin/master<cr>

nnoremap <silent> <leader>gb  :Denite gitbranch -no-start-filter<cr>
" }}}
" vim-gitgutter {{{
nnoremap <silent> <leader>gt  :GitGutterToggle<cr>
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
let g:black_linelength=79
let g:black_virtualenv="~/.local/share/nvim/black"

nnoremap <leader>bb :Black<cr>
" }}}


" vim: ft=vim foldmethod=marker foldcolumn=1
