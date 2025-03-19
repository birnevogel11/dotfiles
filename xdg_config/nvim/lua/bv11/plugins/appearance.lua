return {
  {
    "alvarosevilla95/luatab.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = function()
      local luatab = require("luatab")
      local helpers = luatab.helpers

      local title = function(bufnr)
        local name = helpers.title(bufnr)
        if name ~= "[No Name]" then
          name = "[" .. name .. "]"
        end
        return name
      end

      local cell = function(index)
        local isSelected = vim.fn.tabpagenr() == index
        local buflist = vim.fn.tabpagebuflist(index)
        local winnr = vim.fn.tabpagewinnr(index)
        local bufnr = buflist[winnr]
        local hl = (isSelected and "%#TabLineSel#" or "%#TabLine#")

        return hl .. "%" .. index .. "T" .. " " .. index .. ":" .. title(bufnr) .. " " .. helpers.modified(bufnr)
      end

      luatab.setup({ cell = cell })
    end,
  },
  {
    "hedyhli/outline.nvim",
    event = "VeryLazy",
    keys = { { "<leader>tb", ":Outline<cr>", desc = "Show tag bar" } },
    opts = { width = 30 },
  },

  -- {
  --   "rcarriga/nvim-notify",
  --   event = "VeryLazy",
  --   opts = {
  --     background_colour = "#272b33",
  --     stages = "fade",
  --     timeout = 1000,
  --   },
  -- },

  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup()
      require("colorizer").attach_to_buffer(0)
    end,
  },
  {
    "lukas-reineke/virt-column.nvim",
    event = "VeryLazy",
    opts = { highlight = "VirtColumn" },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
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
    end,
  },

  {
    "stevearc/stickybuf.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
}
