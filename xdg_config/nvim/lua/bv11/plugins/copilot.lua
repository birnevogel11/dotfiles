local function get_git_diff()
  local handle = io.popen("git diff")
  if not handle then
    return ""
  end

  local result = handle:read("*a")
  handle:close()
  return result
end

local prompts = {
  -- Code related prompts
  Explain = "Please explain how the following code works.",
  Review = "Please review the following code and provide suggestions for improvement.",
  -- Tests = "Please explain how the selected code works, then generate unit tests for it.",
  Tests = "Please generate unit tests for it with pytest format.",
  Refactor = "Please refactor the following code to improve its clarity and readability.",
  FixCode = "Please fix the following code to make it work as intended.",
  BetterNamings = "Please provide better names for the following variables and functions.",
  Documentation = "Please provide documentation for the following code.",
  -- Text related prompts
  Summarize = "Please summarize the following text.",
  Spelling = "Please correct any grammar and spelling errors in the following text.",
  Wording = "Please improve the grammar and wording of the following text.",
  Concise = "Please rewrite the following text to make it more concise.",
}

return {
  -- {
  --   "z0rzi/ai-chat.nvim",
  --   config = function()
  --     require("ai-chat").setup({})
  --   end,
  -- },

  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "VeryLazy",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --       filetypes = {
  --         markdown = true,
  --         yaml = true,
  --       },
  --     })
  --   end,
  -- },

  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },

  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "canary",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
  --     { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --   },
  --   opts = {
  --     show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
  --     debug = false,
  --     prompts = prompts,
  --     disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
  --   },
  --   build = function()
  --     vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
  --   end,
  --   event = "VeryLazy",
  --   filetypes = {
  --     yaml = true,
  --     markdown = true,
  --     help = false,
  --     gitcommit = false,
  --     gitrebase = false,
  --     hgcommit = false,
  --     svn = false,
  --     cvs = false,
  --     -- ["."] = false,
  --   },
  --   keys = {
  --     {
  --       "<leader>cc",
  --       function()
  --         local input = vim.fn.input("Ask Copilot: ")
  --         if input ~= "" then
  --           vim.cmd("CopilotChat " .. input)
  --         end
  --       end,
  --       desc = "CopilotChat - Ask input",
  --     },
  --     {
  --       "<leader>cl",
  --       function()
  --         vim.cmd("CopilotChatToggle")
  --       end,
  --       desc = "CopilotChat - Toggle",
  --     },
  --     {
  --       "<leader>cd",
  --       function()
  --         local input = vim.fn.input("Document the function: ")
  --         if input ~= "" then
  --           vim.cmd("CopilotChat " .. "Please help to document the method " .. input .. " in sphinx format")
  --         end
  --       end,
  --       mode = "x",
  --       desc = "CopilotChat - Document the function",
  --     },
  --     {
  --       "<leader>ct",
  --       function()
  --         local input = vim.fn.input("Test the function: ")
  --         if input ~= "" then
  --           vim.cmd("CopilotChat " .. "Please generate tests for '" .. input .. "' with pytest format")
  --         end
  --       end,
  --       mode = "x",
  --       desc = "CopilotChat - Test the function",
  --     },
  --
  --     { "<leader>cv", ":CopilotChatVisual", mode = "x", desc = "CopilotChat - Open in vertical split" },
  --     { "<leader>cx", ":CopilotChatInPlace<cr>", mode = "x", desc = "CopilotChat - Run in-place code" },
  --
  --     { "<leader>cb", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Name" },
  --     { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
  --     { "<leader>cr", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor Code" },
  --     { "<leader>cd", "<cmd>CopilotChatDocumentation<cr>", desc = "CopilotChat - Add documentation for code" },
  --
  --     -- { "<leader>cs", "<cmd>CopilotChatSummarize<cr>", desc = "CopilotChat - Summarize text" },
  --     -- { "<leader>cS", "<cmd>CopilotChatSpelling<cr>", mode = "x", desc = "CopilotChat - Correct spelling" },
  --     -- { "<leader>cw", "<cmd>CopilotChatWording<cr>", desc = "CopilotChat - Improve wording" },
  --     { "<leader>cC", "<cmd>CopilotChatConcise<cr>", desc = "CopilotChat - Make text concise" },
  --
  --     -- Require time to study the code
  --     -- {
  --     --   "<leader>cm",
  --     --   function()
  --     --     local diff = get_git_diff()
  --     --     if diff ~= "" then
  --     --       vim.fn.setreg('"', diff)
  --     --       vim.cmd("CopilotChat Write commit message for the change with commit-zen convention.")
  --     --     end
  --     --   end,
  --     --   desc = "CopilotChat - Generate commit message",
  --     -- },
  --     -- { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
  --     -- { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
  --     -- { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
  --     -- { "<leader>cr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review Code" },
  --     -- { "<leader>cR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor Code" },
  --     -- { "<leader>cf", "<cmd>CopilotChatFixCode<cr>", desc = "CopilotChat - Fix code" },
  --     -- { "<leader>cS", "<cmd>CopilotChatSpelling<cr>", desc = "CopilotChat - Correct spelling" },
  --   },
  -- },
}
