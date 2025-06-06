local utils = require("utils")

local get_config = function()
  local config = {}
  config = utils.merge_tables(config, require("general"))
  config = utils.merge_tables(config, require("fonts"))
  config = utils.merge_tables(config, require("colors"))
  config = utils.merge_tables(config, require("tabs"))
  config = utils.merge_tables(config, require("keys"))

  return config
end

return get_config()
