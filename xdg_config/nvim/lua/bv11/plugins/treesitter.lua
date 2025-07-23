local ignore_install_lang = { "grammar.js" }
local disable_highlight_lang = { "latex", "yaml" }

local nvim_treesitter_setup = function()
  require("nvim-treesitter.configs").setup({
    sync_install = true,
    auto_install = true,
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "clojure",
      "diff",
      "dockerfile",
      "dot",
      "git_config",
      "git_rebase",
      "gitcommit",
      "gitignore",
      "go",
      "haskell",
      "hcl",
      "html",
      "javascript",
      "json",
      "json5",
      "lua",
      "luadoc",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "requirements",
      "rst",
      "rust",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    },
    additional_vim_regex_hightlighting = false,
    ignore_install = ignore_install_lang,
    highlight = {
      enable = true,
      disable = disable_highlight_lang,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-e>",
        node_incremental = "<c-e>",
        scope_incremental = "<c-s>",
        node_decremental = "<c-backspace>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
          ["]a"] = "@parameter.inner",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
          ["[a"] = "@parameter.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>ea"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>eA"] = "@parameter.inner",
        },
      },
    },
    modules = {},
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = nvim_treesitter_setup,
    -- event = "VeryLazy",
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = { "BufReadPost" } },
  { "nvim-treesitter/playground", event = { "BufReadPost" } },
}
