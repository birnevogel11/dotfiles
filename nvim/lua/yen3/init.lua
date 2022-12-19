local M = {}

local preamble = function()
  vim.g.mapleader = ","
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

local local_setup = function()
  local local_vimrc = vim.fn.fnamemodify("~", ":p") .. ".vimrc_local"

  if vim.fn.filereadable(local_vimrc) == 1 then
    vim.cmd("source " .. local_vimrc)
  end
end

M.setup = function()
  impatient()
  preamble()
  disable_builtin_plugins()
  require("yen3.general").setup()
  require("yen3.packer").packer()
  require("yen3.diagnostic").diagnostic_setup()

  local_setup()
end

return M
