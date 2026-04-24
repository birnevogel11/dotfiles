-- Experimental Lua module loader.
vim.loader.enable()

require("beaver.options")
require("beaver.keymap")
require("beaver.sunsetshiba")
require("beaver.autocommand")
require("beaver.diagnostic")

require("vim._core.ui2").enable()
