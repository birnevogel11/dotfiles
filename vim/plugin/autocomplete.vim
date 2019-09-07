if g:yen3_auto_complete_selection == 1
" Deoplete:{{{
" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set completeopt-=preview    "no scratch window

inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" : "<Tab>"

" deoplete-jedi options (Python)
function! ChompedSystem( ... )
    return substitute(call('system', a:000), '\n\+$', '', '')
endfunction

let g:python3_host_prog = ChompedSystem('which python3')
""}}}
elseif g:yen3_auto_complete_selection == 2
" LanguageClient: {{{

set hidden

let g:LanguageClient_serverCommands = {
    \ 'cpp': ['ccls'],
    \ 'c': ['ccls'],
    \ 'go': ['gopls'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ }

"
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '$HOME/.config/nvim/settings.json'
let g:LanguageClient_changeThrottle = 0.1
let g:LanguageClient_diagnosticsEnable = 0
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()

nnoremap <leader>mm :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
"nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
" }}}k
" Deoplete:{{{
" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set completeopt-=preview    "no scratch window

inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" : "<Tab>"

" deoplete-jedi options (Python)
function! ChompedSystem( ... )
    return substitute(call('system', a:000), '\n\+$', '', '')
endfunction

let g:python3_host_prog = ChompedSystem('which python3')
""}}}
" GoToDefinition: {{{
function! Yen3GoToDefinition(...) abort
  " ref: https://github.com/davidhalter/jedi-vim/blob/master/pythonx/jedi_vim.py#L329-L345

  " Get the current position
  let l:fname = expand('%:p')
  let l:line = line(".")
  let l:col = col(".")
  let l:word = expand("<cword>")

  " Call the original function to jump to the definition
  let l:result = LanguageClient_runSync(
                  \ 'LanguageClient#textDocument_definition', {
                  \ 'handle': v:true,
                  \ })

  " Get the position of definition
  let l:jump_fname = expand('%:p')
  let l:jump_line = line(".")
  let l:jump_col = col(".")

  " If the position is the same as previous, ignore the jump action
  if l:fname == l:jump_fname && l:line == l:jump_line
    return
  endif

  " Workaround: Jump to origial file. If the function is in rust, there is a
  " way to ignore the behaviour
  if &modified
    exec 'hide edit'  l:fname
  else
    exec 'edit' l:fname
  endif
  call cursor(l:line, l:col)

  " Store the original setting
  let l:ori_wildignore = &wildignore
  let l:ori_tags = &tags

  " Write a temp tags file
  let l:temp_tags_fname = tempname()
  let l:temp_tags_content = printf("%s\t%s\t%s", l:word, l:jump_fname,
      \ printf("call cursor(%d, %d)", l:jump_line, l:jump_col+1))
  call writefile([l:temp_tags_content], l:temp_tags_fname)

  " Set temporary new setting
  set wildignore=
  let &tags = l:temp_tags_fname

  " Add to new stack
  execute ":tjump " . l:word

  " Restore original setting
  let &tags = l:ori_tags
  let &wildignore = l:ori_wildignore

  " Remove temporary file
  if filereadable(l:temp_tags_fname)
    call delete(l:temp_tags_fname, "rf")
  endif
endfunction
" }}}
endif
" UltiSnips :{{{
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
