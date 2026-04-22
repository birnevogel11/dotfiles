---@param cmd table<string>
---@param title string
---@return any
local mk_git_cmd_func = function(cmd, title)
  return function()
    require("bv11.lib.notify").async_cmd_notify(cmd, title)
  end
end

require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/tpope/vim-fugitive" },
  }, { confirm = false })
end)
