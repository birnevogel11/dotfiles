-- Based on Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir

local M = {}

-- Eviline config for lualine
local lualine = require 'lualine'

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#31353F',
  fg       = '#abb2bf',
  yellow   = '#dcc342',
  cyan     = '#56b6c2',
  darkblue = '#081633',
  green    = '#81ad61',
  orange   = '#d19a66',
  violet   = '#a9a1e1',
  magenta  = '#dc85f7',
  blue     = '#4c81f1',
  red      = '#ca8288',
  darkred  = '#be5046',
  darkgray = '#4E4E4E',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand '%:t') ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand '%:p:h'
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_v = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  -- mode component
  function()
    local mode_char = {
      n = 'N',
      i = 'I',
      v = 'V',
      V = 'V',
      [''] = 'V',
      c = 'C',
      no = 'N',
      s = 'S',
      S = 'S',
      [''] = 'S',
      ic = 'I',
      R = 'R',
      Rv = 'R',
      cv = 'I',
      ce = 'I',
      r = 'R',
      rm = 'R',
      ['r?'] = 'R',
      ['!'] = 'N',
      t = 'N',
    }
    vim.api.nvim_command('hi! LualineMode guifg=' .. colors.fg .. ' guibg=' .. colors.darkgray)
    return mode_char[vim.fn.mode()]
  end,
  color = 'LualineMode',
  padding = { left = 1, right = 1 },
}

ins_left {
  'filename',
  path = 1,
  short_target = 40,
  cond = conditions.buffer_not_empty,
  color = { fg = colors.fg },
}

-- Add components to right sections
ins_right {
  'diagnostics',
  sources = { 'nvim_lsp' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    error = { fg = colors.darkred },
    warn = { fg = colors.fg },
    info = { fg = colors.fg },
    hint = { fg = colors.fg },
  },
}

ins_right {
  'filetype',
  icons_enabled = false,
  color = { fg = colors.fg },
}

ins_right { 'location' }

ins_right { 'progress', color = { fg = colors.fg } }

ins_right {
  'branch',
  icon = '',
  color = { fg = colors.fg },
}

function M.setup()
  lualine.setup(config)
end

return M
