local api = vim.api
local config_util = require("yen3.util.config")

local M = {}


 M.vsnip_setup = function()
  local cmd = api.nvim_command

  local vsnip_key_map = function(key, func_name, plug_func_name)
    local plug_func = "'<Plug>(" .. plug_func_name .. ")'"
    local map_func = func_name .. " ? " .. plug_func .. " : " .. "'" .. key .. "'"
    local map_command = " <expr> " .. key .. " " .. map_func
    cmd("imap" .. map_command)
    cmd("smap" .. map_command)
  end

  -- Expand
  vsnip_key_map("<C-l>", "vsnip#expandable()", "vsnip-expand")

  -- Expand or jump
  vsnip_key_map("<C-e>", "vsnip#available(1)", "vsnip-expand-or-jump")

  -- Jump forward or backward
  vsnip_key_map("<C-j>", "vsnip#jumpable(1)", "vsnip-jump-next")
  vsnip_key_map("<C-k>", "vsnip#jumpable(-1)", "vsnip-jump-prev")

  config_util.set_variables({
    -- vsnip_filetypes = {
    --   javascriptreact = { "javascript" },
    --   typescriptreact = { "typescript" },
    -- },
    vsnip_snippet_dirs = { "~/.config/nvim/snippets" },
  })
end

M.nvim_cmp_setup = function()
  local cmp_kinds = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  }
  local cmd = api.nvim_command
  local cmp = require("cmp")

  cmd [[ set completeopt-=preview ]]
  cmd [[ set completeopt=menuone,noinsert ]]

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      -- ['<CR>'] = cmp.mapping.close(),
      ["<C-e>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<C-n>"]  = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"]  = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ["<Up>"]   = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "vsnip" },
    }, {
      { name = "buffer", keyword_length = 3 },
      { name = "path" },
      { name = "tmux" },
    }),
    formatting = {
      format = function(_, vim_item)
        -- vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. ' ' .. vim_item.kind
        vim_item.kind = cmp_kinds[vim_item.kind] or ""
        return vim_item
      end,
    },
  })
end

M.setup = function()
  M.vsnip_setup()
  M.nvim_cmp_setup()
end

return M
