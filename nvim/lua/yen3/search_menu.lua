return {
  default = {
    items = {
      -- Git
      { "Git rebase remote master", require("yen3.lib.git").rebase_remote_master },
      { "Git update upstream master", require("yen3.lib.git").pull_upstream_rebase },
      { "Git toggle delete lines", require("gitsigns").toggle_deleted },

      -- LSP
      {
        "Show lsp server detail",
        function()
          print(vim.inspect(vim.lsp.get_active_clients()))
        end,
      },
      {
        "Show lsp status",
        function()
          require("yen3.lib.notify").notify("lsp status", require("yen3.plugins.lsp.lsp_util").get_activated_lsp())
        end,
      },

      -- Tree sitter
      { "TSPlaygroundToggle", "TSPlaygroundToggle" },
      { "TSHighlightCapturesUnderCursor", "TSHighlightCapturesUnderCursor" },
    },
  },
  octo = {
    items = {
      { "Resolve the review thread", "Octo thread resolve" },
      {
        "Review start",
        function()
          vim.fn.execute("Octo review start")
          vim.fn.execute("resize +15")
        end,
      },
      { "Review discard", "Octo review discard" },
      { "Review submit", "Octo review submit" },
      { "Add WIP label", "Octo label add WIP" },
      { "Add merge label", "Octo label add merge" },
      { "Show PR diff", "Octo pr diff" },
      { "Reacttion thumbs up 👍", "Octo reaction thumbs_up" },
      { "Delete the comment", "Octo comment delete" },
      { "Remove WIP label", "Octo label remove WIP" },
      { "Remove merge label", "Octo label remove merge" },
      { "Unresolve the review thread", "Octo thread unresolve" },
      { "Reacttion rocket  🚀", "Octo reaction rocket" },
      { "Reacttion hooray 🎉", "Octo reaction hooray" },
    },
  },
}
