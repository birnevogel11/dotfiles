require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/hedyhli/outline.nvim" },
  }, { confirm = false })

  require("outline").setup({ width = 40 })

  vim.keymap.set("n", "<leader>tb", ":Outline<cr>", { silent = true, desc = "Show tag bar" })
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/norcalli/nvim-colorizer.lua" },
  }, { confirm = false })

  require('colorizer').attach_to_buffer(0)
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/lukas-reineke/virt-column.nvim" },
  }, { confirm = false })

  require('virt-column').setup({ highlight = "VirtColumn" } )
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  }, { confirm = false })

  require("ibl").setup({
      debounce = 100,
      indent = { char = "│", smart_indent_cap = true },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "dashpreview",
          "LuaTree",
          "vista",
          "sagahover",
          "NvimTree",
          "fzf",
          "floaterm",
          "startify",
          "packer",
          "toggleterm",
        },
      },
      scope = {
        enabled = false,
      },
    })

    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
end)

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/stevearc/stickybuf.nvim" },
  }, { confirm = false })

  require("stickybuf").setup()
end)
