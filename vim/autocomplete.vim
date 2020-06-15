if g:yen3_auto_complete_selection == 1
" Deoplete:{{{
" Use deoplete.
let g:deoplete#enable_at_startup = 1
call deoplete#custom#var("smart_case", 1)

set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set completeopt-=preview    "no scratch window

inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" : "<Tab>"

" deoplete-jedi options (Python)
function! ChompedSystem( ... )
    return substitute(call('system', a:000), '\n\+$', '', '')
endfunction

let g:python3_host_prog = ChompedSystem('which python3')

" racer options for rust
let g:deoplete#sources#rust#racer_binary= ChompedSystem('which racer')
if has("mac")
  let g:deoplete#sources#rust#rust_source_path='/Users/yen3/.cache/rust-src/src'
else
  let g:deoplete#sources#rust#rust_source_path='/home/yen3/.cache/rust-src/src'
endif
let g:deoplete#sources#rust#disable_keymap=1

""}}}
  if g:yen3_auto_complete_enable_lsp == 1
    " LanguageClient: {{{

    set hidden

    let g:LanguageClient_serverCommands = {
        \ 'cpp': ['clangd'],
        \ 'c': ['clangd'],
        \ }

    let g:LanguageClient_hoverPreview = "Never"
    let g:LanguageClient_useVirtualText = 0
    let g:LanguageClient_changeThrottle = 0.1
    let g:LanguageClient_diagnosticsEnable = 0
    set completefunc=LanguageClient#complete
    set formatexpr=LanguageClient_textDocument_rangeFormatting()
    " }}}
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
    " Keymapping {{{
      autocmd FileType c,cpp call s:language_client_yen3_settings()

      function! s:language_client_yen3_settings() abort
          nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
          nnoremap <silent> gr :call LanguageClient#textDocument_rename()<CR>
          nnoremap <silent> gu :call LanguageClient#textDocument_references()<CR>
          nnoremap <silent><buffer> <C-]> :call Yen3GoToDefinition()<CR>
          " nnoremap <leader>mm :call LanguageClient_contextMenu()<CR>
          " nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
          " nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
      endfunction
    " }}}
  endif
elseif g:yen3_auto_complete_selection == 2
" Deoplete:{{{
" Use deoplete.
let g:deoplete#enable_at_startup = 1
call deoplete#custom#var("smart_case", 1)

set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set completeopt-=preview    "no scratch window

" inoremap <silent><expr> <Tab>
            " \ pumvisible() ? "\<C-n>" : "<Tab>"

" deoplete-jedi options (Python)
function! ChompedSystem( ... )
    return substitute(call('system', a:000), '\n\+$', '', '')
endfunction

let g:python3_host_prog = ChompedSystem('which python3')
""}}}
" nvim-lsp: {{{
" ref: https://neovim.io/doc/user/lsp.html
:lua<< EOF
  local nvim_lsp = require'nvim_lsp'
  nvim_lsp.clangd.setup{on_attach=require'diagnostic'.on_attach}
EOF

" Use LSP omni-completion in c/cpp files.
autocmd Filetype c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
" }}}
" diagnostic-nvim: {{{
autocmd BufEnter * highlight LspDiagnosticsError gui=italic ctermbg=88 guibg=#870000
autocmd BufEnter * highlight LspDiagnosticsWarning gui=italic ctermbg=21 guibg=#878700

let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_show_sign = 0
let g:diagnostic_insert_delay = 1
" }}}
" nvim-lsp-keymapping: {{{
autocmd FileType c,cpp call s:language_client_yen3_settings()

function! s:language_client_yen3_settings() abort
  nnoremap <silent><buffer> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent><buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent><buffer> K     <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent><buffer> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent><buffer> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent><buffer> gD    <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent><buffer> gr    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent><buffer> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
endfunction
" }}}
endif
" UltiSnips :{{{
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:UltiSnipsSnippetDirectories = ['~/usr/rc/vim/snippets']
let g:UltiSnipsSnippetsDir = '~/usr/rc/vim/snippets'
let g:UltiSnipsEditSplit = 'context'
let g:UltiSnipsEnableSnipMate = 0

" Automatically insert header when creating new files (Note: the header snippet
" is defined in all.snippets file) or when we opening a blank file (if we only
" want this for new file use BufNew event instead)
augroup ps_ultisnips
    au!
    " au BufNewFile,BufRead *.{bib,py,snippets,tex,txt,vim,m,R,r,src,js,sh}
                " \ call s:ExpandHeader()
    au BufNewFile,BufRead *.py call s:ExpandHeader('python')
    au BufNewFile,BufRead *.{yaml,yml} call s:ExpandHeader('yaml')
augroup END
function! s:ExpandHeader(ft)
    " Don't try to expand a header from a Gdiff (when file path includes .git)
    " or if the file is not empty
    if expand('%:p') =~# "/\\.git/" || line('$') > 1 || getline(1) !=# ''
        return
    endif
    let snippet_trigger = 'hea'
    if a:ft ==# 'python'
        let snippet_trigger = 'md'
    elseif a:ft ==# 'yaml'
        let snippet_trigger = 'wp'
    endif
    if line('$') == 1 && getline(1) ==# ''
        startinsert
        call feedkeys(snippet_trigger . "\<C-s>")
    endif
endfunction
" }}}

" vim: ft=vim foldmethod=marker foldcolumn=1
