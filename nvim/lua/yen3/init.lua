local M = {}

local preamble = function()
  vim.g.mapleader = ","
  vim.cmd [[ let maplocalleader = ',' ]]
end

local disable_builtin_plugins = function()
  -- Disable some builtin vim plugins
  local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "matchparen",
    "tar",
    "tarPlugin",
    "rrhelper",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
  }

  for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
  end
end

local impatient = function()
  local impatient_ok, _ = pcall(require, "impatient")
  if impatient_ok then
    require("impatient").enable_profile()
  end
end

M.setup = function()
  impatient()
  preamble()
  disable_builtin_plugins()
  require("yen3.general").setup()
  require("yen3.packer").packer()
  require("yen3.diagnostic").diagnostic_setup()
end

return M
