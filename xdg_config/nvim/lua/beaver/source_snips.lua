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

  if vim.fn.filereadable(local_snippet_path) == 1 then
    vim.cmd("source " .. local_snippet_path)
  end

end

source_local_snippets()
