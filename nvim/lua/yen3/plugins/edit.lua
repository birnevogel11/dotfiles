local keymap_n = require("yen3.lib.keymap").keymap_n

return {
    -- Edit
    { "tpope/vim-rhubarb",     event = "VeryLazy" },
    { "tpope/vim-speeddating", event = "VeryLazy" },
    { "tpope/vim-surround",    event = "VeryLazy" },
    { "numToStr/Comment.nvim", event = "VeryLazy", config = function() require("Comment").setup() end, },
    { "RRethy/nvim-treesitter-endwise", event = "VeryLazy",
        config = function() require("nvim-treesitter.configs").setup({ endwise = { enable = true } }) end,
    },
    { "junegunn/vim-easy-align", event = "VeryLazy",
        config = function()
          -- Start interactive EasyAlign in visual mode (e.g. vipga)
          vim.cmd([[ xmap ga <Plug>(EasyAlign)]])

          -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
          vim.cmd([[ nmap ga <Plug>(EasyAlign)]])
        end,
    },
    { "windwp/nvim-autopairs", event = "VeryLazy",
        config = function() require("nvim-autopairs").setup({ disable_filetype = { "TelescopePrompt", "vim" }, }) end,
    },
    {
        "luukvbaal/statuscol.nvim",
        config = function() require("statuscol").setup() end,
        event = "VeryLazy",
    },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
          require('neogen').setup({
            snippet_engine = "luasnip",
            languages = {
              python = {
                template = {
                  annotation_convention = "reST"
                }
              },
            },
          })
          keymap_n("<leader>nf", require('neogen').generate, "Generate annotations")
        end,
        event = "InsertEnter",
    },

    -- {
    --   "james1236/backseat.nvim",
    --   event = "VeryLazy",
    --   config = function()
    --       require("backseat").setup({
    --           -- Alternatively, set the env var $OPENAI_API_KEY by putting "export OPENAI_API_KEY=sk-xxxxx" in your ~/.bashrc
    --           openai_api_key = "",
    --           openai_model_id = "gpt-3.5-turbo",
    --
    --           -- additional_instruction = "Respond snarkily", -- (GPT-3 will probably deny this request, but GPT-4 complies)
    --           highlight = {
    --               icon = "", -- ''
    --               group = "Comment",
    --           }
    --       })
    --   end
    -- },
}
