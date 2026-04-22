if vim.env.NVIM_DISABLE_COPILOT == nil then
  require("beaver.lazyload").on_vim_enter(function()
    vim.pack.add({
      { src = "https://github.com/zbirenbaum/copilot.lua" },
      { src = "https://github.com/copilotlsp-nvim/copilot-lsp" },
    }, { confirm = false })

    vim.g.copilot_nes_debounce = 500

    require("copilot").setup({
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
    })
  end)
end
