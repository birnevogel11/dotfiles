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
}

if vim.env.NVIM_DISABLE_COPILOT ~= nil then
  return {}
else
  return copilot_plugins
end
