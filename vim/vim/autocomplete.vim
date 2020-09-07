if g:yen3_auto_complete_selection == 1
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

" source: https://www.reddit.com/r/neovim/comments/h0ndj0/to_those_who_have_integrated_lsp_functionality/
:lua << EOF
  local nvim_lsp = require('nvim_lsp')

  local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require'diagnostic'.on_attach()

    -- Mappings.
    -- local opts = { noremap=true, silent=true }
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  end

  local local_servers = {'clangd', 'ghcide', 'rust_analyzer', 'dockerls'}
  for _, lsp in ipairs(local_servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

function! s:language_client_yen3_settings() abort
  nnoremap <silent><buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent><buffer> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent><buffer> K     <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent><buffer> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent><buffer> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent><buffer> gD    <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent><buffer> gr    <cmd>lua vim.lsp.buf.rename()<CR>
  nnoremap <silent><buffer> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
endfunction

" Use LSP omni-completion in c/cpp files.
autocmd Filetype c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype dockerfile setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype haskell setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc

autocmd FileType c,cpp call s:language_client_yen3_settings()
autocmd FileType dockerfile call s:language_client_yen3_settings()
autocmd FileType haskell call s:language_client_yen3_settings()
autocmd FileType rust call s:language_client_yen3_settings()
" }}}
" diagnostic-nvim: {{{
autocmd BufEnter * highlight LspDiagnosticsError gui=italic ctermbg=88 guibg=#870000
autocmd BufEnter * highlight LspDiagnosticsWarning gui=italic ctermbg=21 guibg=#878700

let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_show_sign = 0
let g:diagnostic_insert_delay = 1
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
