local api = vim.api

local nvim_lsp = require('lspconfig')
local M = {}

function M.lsp_config()
    vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end

    -- Enable the block after the next nightly release
    -- ref: https://github.com/nvim-lua/diagnostic-nvim/issues/73
    -- vim.lsp.callbacks["textDocument/publishDiagnostics"] = vim.lsp.with(
      -- vim.lsp.diagnostic.on_publish_diagnostics, {
        -- -- This will disable virtual text, like doing:
        -- -- let g:diagnostic_enable_virtual_text = 0
        -- -- virtual_text = false,
        -- virtual_text = true,

        -- -- This is similar to:
        -- -- let g:diagnostic_show_sign = 1
        -- -- To configure sign display,
        -- --  see: ":help vim.lsp.diagnostic.set_signs()"
        -- signs = true,

        -- -- This is similar to:
        -- -- "let g:diagnostic_insert_delay = 1"
        -- update_in_insert = false,
      -- }
    -- )

    local on_attach = function(_, bufnr)
        api.nvim_command [[nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>]]
        -- api.nvim_command [[nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>]]
        api.nvim_command [[nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>]]
        api.nvim_command [[nnoremap <silent> K     <cmd>lua vim.lsp.buf.signature_help()<CR>]]
        api.nvim_command [[nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>]]
        api.nvim_command [[nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>]]
        api.nvim_command [[nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>]]
        api.nvim_command [[nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>]]
        api.nvim_command [[nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>]]
        api.nvim_command [[set omnifunc=v:lua.vim.lsp.omnifunc]]
    end

    local local_servers = {'clangd', 'hls', 'rust_analyzer', 'tsserver', 'ocamllsp'}
    for _, lsp in ipairs(local_servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
        }
    end
end

function M.treesitter_config()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      highlight = {
        enable = true,                -- false will disable the whole extension
        disable = { "cpp", "python" },  -- list of language that will be disabled
      },
    }
end

M.lsp_config()
M.treesitter_config()
