require("beaver.snips.all")
require("beaver.snips.all")
require("beaver.snips.dockerfile")
require("beaver.snips.haskell")
require("beaver.snips.lua")
require("beaver.snips.markdown")
require("beaver.snips.python")
require("beaver.snips.rust")
require("beaver.snips.shell")
require("beaver.snips.tex")
require("beaver.snips.yaml")

local source_local_snippets = function()
  local local_snippet_path = os.getenv("HOME") .. "/usr/rc_local/vim/snippets/snippets_local.lua"

  -- TODO: rewrite without plenary.path
  local Path = require("plenary.path")
  local path = Path:new(local_snippet_path)
  if path:exists() then
    vim.cmd("source " .. local_snippet_path)
  end
end

-- TODO: enable it again
-- source_local_snippets()
