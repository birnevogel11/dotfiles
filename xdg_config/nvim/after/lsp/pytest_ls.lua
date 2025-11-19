-- https://github.com/bellini666/pytest-language-server
return {
  cmd = { "pytest-language-server" },
  filetypes = { 'python' },
  root_markers = {
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  single_file_support = true,
}
