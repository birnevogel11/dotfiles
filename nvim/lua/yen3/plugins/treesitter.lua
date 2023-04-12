local ignore_install_lang = { "grammar.js" }
local disable_highlight_lang = { "latex", "yaml" }

local nvim_treesitter_setup = function()
  if vim.fn.has("mac") == 1 then
    require("nvim-treesitter.install").compilers = { "gcc-12" }
  end

  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "diff",
      "dockerfile",
      "dot",
      "go",
      "git_rebase",
      "gitcommit",
      "haskell",
      "html",
      "javascript",
      "json",
      "json5",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "rst",
      "rust",
      "tsx",
      "typescript",
      "vim",
      -- "vimdoc",
    },
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
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
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
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
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
  })
end

return {
  { "nvim-treesitter/nvim-treesitter",
    config = function() nvim_treesitter_setup() end,
    build = function() pcall(require("nvim-treesitter.install").update({ with_sync = true })) end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = { "BufReadPost" } },
  { "nvim-treesitter/playground", build = ":TSInstall query", event = { "BufReadPost" }, },
}
