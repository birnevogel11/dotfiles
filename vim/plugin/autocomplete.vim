if g:yen3_auto_complete_selection == 1
" Deoplete:{{{
" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set completeopt-=preview    "no scratch window

inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" : "<Tab>"

" deoplete-clang opions
"let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
"let g:deoplete#sources#clang#clang_header ="/usr/include/clang/"

" clang_complete settings
if has("mac")
let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
else
let g:clang_library_path='/usr/lib/llvm-3.8/lib/libclang.so.1'
endif

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
    \ 'cpp': ['clangd'],
    \ 'c': ['clangd'],
    \ 'go': ['gopls'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['pyls'],
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
""}}}
" GoToDefinition: {{{

" ref: https://github.com/fatih/vim-go/blob/8b4b0e3cea0f41aeb6810fbc30d57e4a639d1ee6/autoload/go/def.vim

let s:lsp_stack = []
let s:lsp_stack_level = 0

function! Yen3GoToDefinition(...) abort
  " Get the current position
  let l:fname = expand('%:p')
  let l:line = line(".")
  let l:col = col(".")

  " Call the original function to jump to the definition
  let l:result = LanguageClient_runSync('LanguageClient#textDocument_definition', {
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

  " Remove anything newer than the current position, just like basic
  " vim tag support
  if s:lsp_stack_level == 0
    let s:lsp_stack = []
  else
    let s:lsp_stack = s:lsp_stack[0:s:lsp_stack_level-1]
  endif

  " Push entry into stack
  let s:lsp_stack_level += 1
  let l:stack_entry = {'line': l:line, 'col': l:col, 'file': l:fname}
  call add(s:lsp_stack, l:stack_entry)
endfunction

function! Yen3TagStackPop() abort
  if s:lsp_stack_level == 0
    echo "lsp stack empty!"
    return
  endif

  " Get previous position
  let l:curr_stack_level = s:lsp_stack_level - 1
  let l:jump_entry = s:lsp_stack[l:curr_stack_level]

  " Pop stack
  let s:lsp_stack = s:lsp_stack[0:l:curr_stack_level]
  let s:lsp_stack_level = s:lsp_stack_level - 1

  " Jump to previous location
  if &modified
    exec 'hide edit'  l:jump_entry['file']
  else
    exec 'edit' l:jump_entry['file']
  endif

  call cursor(l:jump_entry['line'], l:jump_entry['col'])
  normal! zz
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
