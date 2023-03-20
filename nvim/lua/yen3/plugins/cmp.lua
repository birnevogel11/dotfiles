local keymap = require("yen3.lib.keymap").keymap

local cmp_kinds = {
  Text = " ",
  Method = " ",
  Function = " ",
  Constructor = " ",
  Field = " ",
  Variable = " ",
  Class = " ",
  Interface = " ",
  Module = " ",
  Property = " ",
  Unit = " ",
  Value = " ",
  Enum = " ",
  Keyword = " ",
  Snippet = " ",
  Color = " ",
  File = " ",
  Reference = " ",
  Folder = " ",
  EnumMember = " ",
  Constant = " ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
}

local nvim_cmp_setup = function()
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  local cmp = require("cmp")
  cmp.setup({
    enabled = function()
      local is_ok, cmp_dap = pcall(require, "cmp_dap")
      if not is_ok then
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
      end
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or cmp_dap.is_dap_buffer()
    end,
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    sources = cmp.config.sources({
      { name = "nvim_lua " },
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer", keyword_length = 3 },
      { name = "path" },
      { name = "tmux" },
      { name = "nvim_lsp_signature_help" },
    }),
    formatting = {
      format = function(_, vim_item)
        -- vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. ' ' .. vim_item.kind
        vim_item.kind = cmp_kinds[vim_item.kind] or ""
        return vim_item
      end,
    },
  })

  -- Command
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline", keyword_length = 2 },
    }),
  })
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
end

return {
  { "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    branch = "main",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", branch = "main" },
      { "andersevenrud/cmp-tmux", branch = "main" },
      { "hrsh7th/cmp-buffer", branch = "main" },
      { "hrsh7th/cmp-path", branch = "main" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", branch = "main"},
      { "hrsh7th/cmp-cmdline", branch = "main" },
      { "hrsh7th/cmp-omni", branch = "main", ft = "tex"},
    },
    config = function() nvim_cmp_setup() end,
  },
}
