local copilot_plugins = {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
      config = function()
        vim.g.copilot_nes_debounce = 500
      end
    },
    cmd = "Copilot",
    event = "VeryLazy",
    opts = {
      auth_provider_url = os.getenv("NVIM_GITHUB_COPILOT_URL") or nil,
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
      },
      panel = { enabled = true },
      keymap = {
        accept = "",
        accept_word = false,
        accept_line = false,
        next = "",
        prev = "",
        dismiss = "",
      },
      filetypes = {
        markdown = true,
        yaml = true,
        gitcommit = true,
      },
      nes = {
        enabled = true,
        keymap = {
          accept_and_goto = "<C-y>",
          accept = false,
          dismiss = "<Esc>",
        },
      },
    },
    keys = {
      { "<leader>ci", toggle_copilot, desc = "Copilot: Toggle ability" },
      { "<C-r>", function() require("copilot.suggestion").accept() end , mode = "i", desc = "Copilot: accept" },
      { "<C-]>", function() require("copilot.suggestion").next() end, mode = "i", desc = "Copilot: next"},
      { "<C-x>", function() require("copilot.suggestion").dismiss() end, mode = "i", desc = "Copilot: dissmiss" },
    }
  },

  -- {
  --   "folke/sidekick.nvim",
  --   opts = {
  --     -- add any options here
  --     cli = {
  --       mux = {
  --         backend = "tmux",
  --         enabled = true,
  --       },
  --     },
  --   },
  --   keys = {
  --     {
  --       "<C-e>",
  --       function()
  --         -- if there is a next edit, jump to it, otherwise apply it if any
  --         if not require("sidekick").nes_jump_or_apply() then
  --           return "<C-e>" -- fallback to normal tab
  --         end
  --       end,
  --       expr = true,
  --       desc = "Goto/Apply Next Edit Suggestion",
  --     },
  --     {
  --       "<leader>aa",
  --       function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
  --       desc = "Sidekick Toggle Copilot",
  --     },
  --     {
  --       "<leader>as",
  --       function() require("sidekick.cli").select() end,
  --       -- Or to select only installed tools:
  --       -- require("sidekick.cli").select({ filter = { installed = true } })
  --       desc = "Select CLI",
  --     },
  --     {
  --       "<leader>at",
  --       function() require("sidekick.cli").send({ msg = "{this}" }) end,
  --       mode = { "x", "n" },
  --       desc = "Send This",
  --     },
  --     {
  --       "<leader>av",
  --       function() require("sidekick.cli").send({ msg = "{selection}" }) end,
  --       mode = { "x" },
  --       desc = "Send Visual Selection",
  --     },
  --     {
  --       "<leader>ap",
  --       function() require("sidekick.cli").prompt() end,
  --       mode = { "n", "x" },
  --       desc = "Sidekick Select Prompt",
  --     },
  --     {
  --       "<c-.>",
  --       function() require("sidekick.cli").focus() end,
  --       mode = { "n", "x", "i", "t" },
  --       desc = "Sidekick Switch Focus",
  --     },
  --   },
  -- },

}

if os.getenv("NVIM_DISABLE_COPILOT") ~= nil then
  return {}
else
  return copilot_plugins
end
