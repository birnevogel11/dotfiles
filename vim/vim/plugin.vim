" zM: foldall
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

function! s:FugitiveGitPullMaster()
  let l:current_patch=system('git branch --show-current')
  execute('silent !git checkout master')
  execute('slient !git pull')
  execute('slient !git checkout ' . l:current_patch)
endfunction

function! s:FugitiveGitRebaseOriginMaster()
  execute('silent !git fetch origin master')
  execute(':Git rebase -i origin/master')
endfunction

nnoremap          <leader>g   :call <SID>FugitiveGitCommand()<cr>

nnoremap          <leader>gc :Git checkout

nnoremap <silent> <leader>gs  :vertical topleft Gstatus<cr>

nnoremap <silent> <leader>gA  :Git add --patch<cr>

nnoremap <silent> <leader>gd  :Git diff<cr>
nnoremap <silent> <leader>gdd :Gvdiffsplit!<cr>
nnoremap <silent> <leader>gb  :Gblame<cr>
nnoremap <silent> <leader>gB  :Gina blame<cr>

nnoremap <silent> <leader>gp  :Git push<cr>
nnoremap <silent> <leader>gpp :Gina! push origin HEAD:refs/for/master<cr>
nnoremap <silent> <leader>gP  :Git pull<cr>
nnoremap <silent> <leader>gpm :call <SID>FugitiveGitRebaseOriginMaster()<cr>

nnoremap <silent> <leader>gr  :Git rebase -i origin/master<cr>
nnoremap <silent> <leader>grr :call <SID>FugitiveGitRebaseOriginMaster()<cr>
nnoremap <silent> <leader>gri :Git rebase -i
" }}}
" vim-gitmessenger: {{{
nnoremap <silent> <leader>gm  :GitMessenger<cr>
" }}}
" vim-extradite: {{{
nnoremap <silent> <leader>gM  :Extradite!<cr>
" }}}
" python-black {{{
let g:black_linelength=120
let g:black_virtualenv="~/.local/share/nvim/black"

function s:BlackAndImportSort()
  :PyImportSortCDM
  :Black
endfunction

function s:BlackLegacy()
  :w!
  :PyImportSortCDM
  :w!
  :silent exec "!black -l 119 -q %"
  :e!
endfunction

if system("black --version") == "black, version 19.10b0\n"
  autocmd FileType python nnoremap <buffer><silent><leader>bb :call <SID>BlackLegacy()<cr>
else
  autocmd FileType python nnoremap <buffer><silent><leader>bb :call <SID>BlackAndImportSort()<cr>
endif
" }}}
" vim-cpp-enhanced-highlight: {{{
let g:load_doxygen_syntax=1
let g:cpp_class_scope_highlight = 1
" }}}
" COOL: {{{
au BufNewFile,BufRead *.cool set ft=cool
au BufNewFile,BufRead *.cl set ft=cool
" }}}
" vim-test: {{{
let test#strategy = "vimux"
let test#python#runner = 'nose'
let test#python#nose#options = {
  \ 'nearest': '-sv --config /dev/null'
\}
nnoremap <silent><leader>rt :TestNearest<cr>
nnoremap <silent><leader>rT :TestFile<cr>
" }}}
" javascript: {{{
" FORMATTERS
" au FileType javascript setlocal formatprg=prettier
" au FileType javascript.jsx setlocal formatprg=prettier
" au FileType typescript setlocal formatprg=prettier\ --parser\ typescript
" au FileType html setlocal formatprg=js-beautify\ --type\ html
" au FileType scss setlocal formatprg=prettier\ --parser\ css
" au FileType css setlocal formatprg=prettier\ --parser\ css
" }}}
" vim-speluker: {{{
let g:enable_spelunker_vim = 0

function Yen3EnableSpelunker(...)
  let l:words = []
  for l:path in a:000
    for l:line in readfile(path)
      call add(l:words, l:line)
    endfor
  endfor

  let g:enable_spelunker_vim = 1
  let g:spelunker_white_list_for_user = l:words
endfunction
" }}}
" vim: ft=vim foldmethod=marker foldcolumn=1
