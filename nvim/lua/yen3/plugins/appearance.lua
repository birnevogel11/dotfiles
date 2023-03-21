local set_variables = function(variables)
  for k, v in pairs(variables) do
    vim.api.nvim_set_var(k, v)
  end
end

return {
  -- Apperence
  { "alvarosevilla95/luatab.nvim",
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
  { "majutsushi/tagbar",
    cmd = { "TagbarOpen" },
    keys = { "<leader>tb" },
    config = function() require("yen3.plugin_setup").tagbar()
      set_variables({
        tagbar_map_openfold = { "zo", "l" },
        tagbar_map_closeallfolds = "zm",
        tagbar_map_openallfolds = "zr",

        tagbar_width = 40,
        tagbar_autofocus = 1, -- Keep focus on tagbar window
        tagbar_sort = 1, -- Sort tags alphabetically
        tagbar_compact = 1,
        tagbar_indent = 1,
        tagbar_autopreview = 0, -- Don't autopreview, enable it with P
        tagbar_previewwin_pos = "belowright",

        tagbar_type_python = {
          kinds = {
            "i:modules:1:0",
            "c:classes",
            "f:functions",
            "m:members",
            "v:variables:0:0",
            "x:unknowns",
          },
        },
      })

      require("yen3.lib.keymap").keymap_n("<leader>tb", ":TagbarOpen jc<cr>", "Show tag bar")
    end,
  },
  { 'simrat39/symbols-outline.nvim',
    event = "VeryLazy",
    config = function ()
      require("symbols-outline").setup()
    end,
  },
  { "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#272b33",
        stages = "fade",
        timeout = 1000,
      })
    end,
    event = "VeryLazy",
  },
  { "shortcuts/no-neck-pain.nvim",
    keys = { "<leader>zz" },
    config = function()
      require("no-neck-pain").setup({ width = 120 })
      require("yen3.lib.keymap").keymap_n("<leader>zz", "<cmd>NoNeckPain<cr>", "centralize the buffer")
    end,
  },
  { "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup()
      require("colorizer").attach_to_buffer(0)
    end,
  },
  { "lukas-reineke/virt-column.nvim",
    event = "VeryLazy",
    config = function() require("virt-column").setup() end
  },
  { "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
      require("indent_blankline").setup({
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
      })
      end,
  },
  { 'stevearc/dressing.nvim',
    event = "VeryLazy",
    config = function() require('dressing').setup() end
  },
}
