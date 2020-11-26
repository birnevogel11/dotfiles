local api = vim.api

local nvim_lsp = require('lspconfig')
local M = {}

function M.lsp_config()
    vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end

    local on_attach = function(_, bufnr)
        api.nvim_command [[nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>]]
        api.nvim_command [[nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>]]
        api.nvim_command [[nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>]]
        api.nvim_command [[nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>]]
        api.nvim_command [[nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>]]
        api.nvim_command [[nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>]]
        api.nvim_command [[nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>]]
        api.nvim_command [[nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>]]
        api.nvim_command [[nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>]]
    end

    local local_servers = {'clangd', 'hls', 'rust_analyzer'}
    for _, lsp in ipairs(local_servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
        }
    end

    api.nvim_command [[autocmd Filetype c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
    api.nvim_command [[autocmd Filetype haskell setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
    api.nvim_command [[autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
end

M.lsp_config()
