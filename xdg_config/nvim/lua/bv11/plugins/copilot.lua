is_copilot_enabled = true

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

local function get_git_diff()
  local handle = io.popen("git diff")
  if not handle then
    return ""
  end

  local result = handle:read("*a")
  handle:close()
  return result
end

local get_user_input = function(prompt)
  return vim.fn.input(prompt)
end

local copilot_chat_config = function()
  local copilot_chat = require("CopilotChat")
  local copilot_chat_select = require("CopilotChat.select")

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

  local keymap = require("bv11.lib.keymap")
  local select_prompt_keymap = function(key, name, prompt)
    keymap.keymap("x", key, function()
      copilot_chat.ask(prompt, { selection = copilot_chat_select.visual })
    end, "CopilotChat - " .. name)
  end

  -- keybindings
  keymap.keymap_n("<leader>ce", copilot_chat.toggle, "CopilotChat - Toggle")
  keymap.keymap_n("<leader>cc", function()
    copilot_chat.ask(get_user_input("Ask Copilot: "))
  end, "CopilotChat - Ask input")

  select_prompt_keymap("<leader>ct", "Test", "Please write test cases with pytest format")
  select_prompt_keymap("<leader>cd", "Document", "Please document the method with sphinx format")
  select_prompt_keymap(
    "<leader>cr",
    "Refactor",
    "Please refactor the following code to improve its clarity and readability."
  )
  select_prompt_keymap(
    "<leader>cn",
    "BetterNaming",
    "Please provide better names for the following variables and functions."
  )
  select_prompt_keymap(
    "<leader>cs",
    "Spelling",
    "Please correct any grammar and spelling errors in the following text."
  )
  select_prompt_keymap("<leader>cw", "Concise", "Please improve the grammar and wording of the following text.")
  select_prompt_keymap(
    "<leader>cR",
    "Review",
    "Please review the following code and provide suggestions for improvement."
  )
  select_prompt_keymap("<leader>cf", "Fix code", "Please fix the following code to make it work as intended.")
  select_prompt_keymap("<leader>cx", "Explain", "Please explain how the following code works.")

  -- Require time to study the code
  -- {
  --   "<leader>cm",
  --   function()
  --     local diff = get_git_diff()
  --     if diff ~= "" then
  --       vim.fn.setreg('"', diff)
  --       vim.cmd("CopilotChat Write commit message for the change with commit-zen convention.")
  --     end
  --   end,
  --   desc = "CopilotChat - Generate commit message",
  -- },
end

return {

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VeryLazy",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
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
      })

      local keymap = require("bv11.lib.keymap")
      keymap.keymap_n("<leader>ci", toggle_copilot, "Copilot - Toggle")

      keymap.keymap("i", "<c-r>", require("copilot.suggestion").accept)
      keymap.keymap("i", "<C-b>", require("copilot.suggestion").next)
      keymap.keymap("i", "<C-x>", require("copilot.suggestion").dismiss)
      -- keymap.keymap("i", "<C-]>", require("copilot.suggestion").next)
    end,
  },

  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },

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
}
