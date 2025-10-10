local is_copilot_enabled = true

local toggle_copilot = function()
  if is_copilot_enabled == true then
    vim.cmd("Copilot disable")
    require("bv11.lib.notify").notify("Copilot", "Disable Copilot auto", "info")
    is_copilot_enabled = false
  else
    vim.cmd("Copilot enable")
    require("bv11.lib.notify").notify("Copilot", "Enable Copilot", "info")
    is_copilot_enabled = true
  end
end

local get_user_input = function(prompt)
  return vim.fn.input(prompt)
end

local select_prompt_keymap = function(key, name, prompt)
  local copilot_chat = require("CopilotChat")
  local copilot_chat_select = require("CopilotChat.select")

  vim.keymap.set("x", key, function()
    copilot_chat.ask(prompt, { selection = copilot_chat_select.visual })
  end, { desc = "CopilotChat - " .. name})
end


local copilot_chat_config = function()
  local copilot_chat = require("CopilotChat")
  copilot_chat.setup({
    debug = false,
    disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
    mapping = {
      reset = {
        normal = "<C-c>",
        insert = "<C-c>",
      },
      close = {
        normal = "<C-q>",
        insert = "<C-q>",
      },
    },
  })

  -- keybindings
  vim.keymap.set("n", "<leader>ct", copilot_chat.toggle, { desc = "CopilotChat - Toggle" })
  vim.keymap.set({"n", "x"}, "<leader>cc", function() copilot_chat.ask(get_user_input("Ask Copilot: ")) end, { desc = "CopilotChat - Ask input"})

  select_prompt_keymap("<leader>cx", "Test", "Please write test cases with pytest format")
  select_prompt_keymap("<leader>cd", "Document", "Please document the method with sphinx format")
  select_prompt_keymap("<leader>cr", "Refactor", "Please refactor the following code to improve its clarity and readability.")
  select_prompt_keymap("<leader>cn", "BetterNaming", "Please provide better names for the following variables and functions.")
  select_prompt_keymap("<leader>cs", "Spelling", "Please correct any grammar and spelling errors in the following text.")
  select_prompt_keymap("<leader>cw", "Concise", "Please improve the grammar and wording of the following text.")
  select_prompt_keymap("<leader>crr", "Review", "Please review the following code and provide suggestions for improvement."
  )
  select_prompt_keymap("<leader>cf", "Fix code", "Please fix the following code to make it work as intended.")
  select_prompt_keymap("<leader>ce", "Explain", "Please explain how the following code works.")
end

local copilot_plugins = {


  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VeryLazy",
    opts = {
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
    },
    keys = {
      { "<leader>ci", toggle_copilot, desc = "Copilot: Toggle ability" },
      { "<C-r>", function() require("copilot.suggestion").accept() end , mode = "i", desc = "Copilot: accept" },
      { "<C-]>", function() require("copilot.suggestion").next() end, mode = "i", desc = "Copilot: next"},
      { "<C-x>", function() require("copilot.suggestion").dismiss() end, mode = "i", desc = "Copilot: dissmiss" },
    }
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    config = copilot_chat_config,
    build = "make tiktoken",
    event = "VeryLazy",
    filetypes = {
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = true,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      -- ["."] = false,
    },
  },

  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<C-r>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<C-r>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        mode = { "n", "x", "i", "t" },
        desc = "Sidekick Switch Focus",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Toggle Claude",
      },
    },
  },

}

if os.getenv("BV11_NVIM_DISABLE_COPILOT") ~= nil then
  copilot_plugins = {}
end

return copilot_plugins
