local api = vim.api
local config_util = require("yen3.util.config")
local fun         = require("plenary.fun")
local function_component = require("lualine.components.special.function_component")

local M = {}

local cmp_kinds = {
  Text = ' ',
  Method = ' ',
  Function = ' ',
  Constructor = ' ',
  Field = ' ',
  Variable = ' ',
  Class = ' ',
  Interface = ' ',
  Module = ' ',
  Property = ' ',
  Unit = ' ',
  Value = ' ',
  Enum = ' ',
  Keyword = ' ',
  Snippet = ' ',
  Color = ' ',
  File = ' ',
  Reference = ' ',
  Folder = ' ',
  EnumMember = ' ',
  Constant = ' ',
  Struct = ' ',
  Event = ' ',
  Operator = ' ',
  TypeParameter = ' ',
}

M.nvim_cmp_setup = function()
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  local cmp = require("cmp")
  cmp.setup({
    enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
    end,
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<C-n>"]  = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"]  = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ["<Up>"]   = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    sources = cmp.config.sources(
      {
        { name = "nvim_lua "},
        { name = "nvim_lsp" },
        { name = "luasnip" },
      },
      {
        { name = "buffer", keyword_length = 3 },
        { name = "path" },
        { name = "tmux" },
        { name = "git" },
        { name = 'nvim_lsp_signature_help' },
      }
    ),
    formatting = {
      format = function(_, vim_item)
        -- vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. ' ' .. vim_item.kind
        vim_item.kind = cmp_kinds[vim_item.kind] or ""
        return vim_item
      end,
    },
  })

  -- Command
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline', keyword_length = 2 }
    })
  })
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- DAP
  cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
    sources = {
      { name = "dap" },
    },
  })

  require("cmp_git").setup()
end

M.luasnip_setup = function()
  local ls = require('luasnip')
  local types = require("luasnip.util.types")

  ls.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "choiceNode", "Comment" } },
        },
      },
    },
  })
  vim.keymap.set({'i', 's'}, '<c-e>', function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, { silent = true})
  vim.keymap.set({'i', 's'}, '<c-k>', function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end)
  vim.keymap.set('i', '<c-l>', function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)
  vim.keymap.set({'i', 's'}, '<c-j>', function()
    if ls.jumpable(1) then
      ls.jump(1)
    end
  end)

  require("luasnip.loaders.from_vscode").lazy_load()
end

return M
