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
    "simrat39/symbols-outline.nvim",
    -- event = "VeryLazy",
    keys = { "<leader>tb" },
    config = function()
      require("symbols-outline").setup({
        width = 30,
      })
      require("yen3.lib.keymap").keymap_n("<leader>tb", ":SymbolsOutline<cr>", "Show tag bar")
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#272b33",
      stages = "fade",
      timeout = 1000,
    },
    event = "VeryLazy",
  },
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
    config = function()
      require("virt-column").setup({
        highlight="VirtColumn"
      })
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    opts = {
      filetype_exclude = {
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
      space_char_blankline = " ",
      show_first_indent_level = false,
      show_current_context = false,
      show_current_context_start = false,
      show_current_context_start_on_current_line = false,
      context_highlight_list = false,
    },
  },
  {
    "stevearc/stickybuf.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
