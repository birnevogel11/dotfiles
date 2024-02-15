local cmp_kinds = {
  Text = " ",
  Method = "󰡱 ",
  Function = "󰡱 ",
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
  Copilot = "",
}

-- local has_words_before = function()
--   if vim.api.nvim_get_option_value("buftype", { scope = "local" }) == "prompt" then
--     return false
--   end
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
-- end

-- local select_item = function(select_func, select_behavior)
--   local cmp = require("cmp")
--   return vim.schedule_wrap(function(fallback)
--     if cmp.visible() and has_words_before() then
--       select_func({ behavior = select_behavior })
--     else
--       fallback()
--     end
--   end)
-- end

local nvim_cmp_setup = function()
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  local cmp = require("cmp")
  ---@diagnostic disable-next-line: missing-fields
  cmp.setup({
    enabled = function()
      local is_ok, cmp_dap = pcall(require, "cmp_dap")
      if not is_ok then
        return vim.api.nvim_get_option_value("buftype", { scope = "local" }) ~= "prompt"
      end
      return vim.api.nvim_get_option_value("buftype", { scope = "local" }) ~= "prompt" or cmp_dap.is_dap_buffer()
    end,
    experimental = {
      native_menu = false,
      ghost_text = false, -- this feature conflict with copilot.vim's preview.
    },
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
      -- ["<C-n>"] = select_item(cmp.select_next_item, cmp.SelectBehavior.Insert),
      -- ["<C-p>"] = select_item(cmp.select_prev_item, cmp.SelectBehavior.Insert),
      -- ["<Down>"] = select_item(cmp.select_next_item, cmp.SelectBehavior.Select),
      -- ["<Up>"] = select_item(cmp.select_prev_item, cmp.SelectBehavior.Select),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "copilot" },
      { name = "luasnip" },
      { name = "nvim_lua" },
      { name = "buffer", keyword_length = 3 },
      { name = "path" },
      { name = "tmux" },
      { name = "nvim_lsp_signature_help" },
    },
    ---@diagnostic disable-next-line: missing-fields
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. " " .. vim_item.kind
        -- vim_item.kind = cmp_kinds[vim_item.kind] or ""
        return vim_item
      end,
    },
  })

  -- Command
  ---@diagnostic disable-next-line: missing-fields
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
      { name = "cmdline", keyword_length = 2 },
    }),
  })
  ---@diagnostic disable-next-line: missing-fields
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
end

return {
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    branch = "main",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", branch = "main" },
      { "andersevenrud/cmp-tmux", branch = "main" },
      { "hrsh7th/cmp-buffer", branch = "main" },
      { "hrsh7th/cmp-path", branch = "main" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", branch = "main" },
      { "hrsh7th/cmp-cmdline", branch = "main" },
      { "hrsh7th/cmp-omni", branch = "main", ft = "tex" },
      { "dmitmel/cmp-cmdline-history" },
    },
    config = nvim_cmp_setup,
  },
}
