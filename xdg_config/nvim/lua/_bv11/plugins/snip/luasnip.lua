local M = {}

local local_snippet_path = os.getenv("HOME") .. "/usr/rc_local/vim/snippets/snippets_local.lua"
local snippet_files = {
  "all.lua",
  "dockerfile.lua",
  "haskell.lua",
  "lua.lua",
  "markdown.lua",
  "python.lua",
  "rust.lua",
  "shell.lua",
  "tex.lua",
  "yaml.lua",
}

local source_local_snippets = function()
  local Path = require("plenary.path")
  local path = Path:new(local_snippet_path)
  if path:exists() then
    vim.cmd("source " .. local_snippet_path)
  end
end

M.source_snippets = function()
  for _, name in ipairs(snippet_files) do
    vim.cmd("source ~/.config/nvim/lua/bv11/plugins/snip/" .. name)
  end

  source_local_snippets()
end

M.add_snippets = function(lang, raw_snippets)
  local ls = require("luasnip")
  local s = ls.s

  local snippets = {}
  for k, v in pairs(raw_snippets) do
    table.insert(snippets, s(k, v))
  end

  ls.add_snippets(lang, snippets)
end

return M
