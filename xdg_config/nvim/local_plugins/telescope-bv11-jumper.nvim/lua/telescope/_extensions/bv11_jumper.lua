return require("telescope").register_extension({
  setup = function(ext_config, config) end,
  exports = {
    dirs = require("telescope-bv11-jumper.dirs").dirs,
    files = require("telescope-bv11-jumper.dirs").files,
  },
})
