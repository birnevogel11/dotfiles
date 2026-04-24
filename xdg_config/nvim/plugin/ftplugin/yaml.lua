-- Filetype
vim.filetype.add({
  patterns = {
    [".*/playbooks/.*.yml"] = "yaml.ansible",
    [".*/playbooks/.*.yaml"] = "yaml.ansible",
  },
})
