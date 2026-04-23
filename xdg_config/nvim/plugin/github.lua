require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/pwntester/octo.nvim" },
  }, { confirm = false })

  require("octo").setup({
    file_panel = {
      size = 20,
      use_icons = true,
    },
    picker = "snacks",
    mappings = {
      issue = {
        open_in_browser = { lhs = "<space>pb", desc = "open PR in browser" },
      },
      pull_request = {
        checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
        list_commits = { lhs = "<space>pc", desc = "list PR commits" },
        list_changed_files = { lhs = "<ledader>pf", desc = "list PR changed files" },
        show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
        close_issue = { lhs = "<space>ic", desc = "close PR" },
        reopen_issue = { lhs = "<space>io", desc = "reopen PR" },
        reload = { lhs = "<C-r>", desc = "reload PR" },
        open_in_browser = { lhs = "<space>pb", desc = "open PR in browser" },
        copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
        goto_file = { lhs = "gf", desc = "go to file" },
        add_label = { lhs = "<space>la", desc = "add label" },
        remove_label = { lhs = "<space>ld", desc = "remove label" },
        add_comment = { lhs = "<leader>ca", desc = "add comment" },
        delete_comment = { lhs = "<space>cd", desc = "delete comment" },
        next_comment = { lhs = "]c", desc = "go to next comment" },
        prev_comment = { lhs = "[c", desc = "go to previous comment" },
        react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
        react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
        react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
        react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
        react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
        react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
        react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
        react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
      },
      review_thread = {
        goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
        add_comment = { lhs = "<leader>ca", desc = "add comment" },
        add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
        delete_comment = { lhs = "<space>cd", desc = "delete comment" },
        next_comment = { lhs = "]c", desc = "go to next comment" },
        prev_comment = { lhs = "[c", desc = "go to previous comment" },
        select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
        select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
        close_review_tab = { lhs = "<space>cc", desc = "close review tab" },
        react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
        react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
        react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
        react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
        react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
        react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
        react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
        react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
      },
      submit_win = {
        approve_review = { lhs = "<space>sa", desc = "approve review" },
        comment_review = { lhs = "<C-m>", desc = "comment review" },
        request_changes = { lhs = "<C-r>", desc = "request changes review" },
        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      },
      review_diff = {
        add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
        add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
        focus_files = { lhs = "<space>e", desc = "move focus to changed file panel" },
        toggle_files = { lhs = "<space>b", desc = "hide/show changed files panel" },
        next_thread = { lhs = "]t", desc = "move to next thread" },
        prev_thread = { lhs = "[t", desc = "move to previous thread" },
        select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
        select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        toggle_viewed = { lhs = "<space><leader>", desc = "toggle viewer viewed state" },
      },
      file_panel = {
        next_entry = { lhs = "j", desc = "move to next changed file" },
        prev_entry = { lhs = "k", desc = "move to previous changed file" },
        select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
        refresh_files = { lhs = "R", desc = "refresh changed files panel" },
        focus_files = { lhs = "<space>e", desc = "move focus to changed file panel" },
        toggle_files = { lhs = "<space>b", desc = "hide/show changed files panel" },
        select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
        select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
      },
    },
  })

  vim.keymap.set("n", "<leader>go", function()
    ---@diagnostic disable-next-line: missing-parameter
    local raw_output = vim.fn.system("gh pr view | head -n13 | grep number | awk -F':' '{print $2}'")
    local pr_num = string.gsub(string.gsub(raw_output, "\t", ""), "\n", "")
    vim.fn.execute("Octo pr edit " .. pr_num)
  end, { desc = "Github: Edit Pull Requeset" })
  vim.keymap.set("n", "<leader>goo", "<cmd>Octo pr list <cr>", { desc = "Github: List pull requests" })
end)
