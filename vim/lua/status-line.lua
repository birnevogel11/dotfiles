local gl = require('galaxyline')

local gls = gl.section
gl.short_line_list = { 'defx', 'packager', 'vista' }

-- Colors
local colors = {
  bg = '#282a36',
  fg = '#abb2bf',
  section_bg = '#38393f',
  yellow = '#f1fa8c',
  cyan = '#8be9fd',
  green = '#50fa7b',
  orange = '#ffb86c',
  magenta = '#ff79c6',
  blue = '#8be9fd',
  red = '#ff5555'
}

-- Local helper functions
local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

local get_virtual_env = function()
  local name = os.getenv("VIRTUAL_ENV")
  if name == nil or name == '' then
    return ''
  end
  return string.gsub(name, "(.*/)(.*)", "%2")
end

local mode_color = function()
  local mode_colors = {
    n = colors.cyan,
    i = colors.green,
    c = colors.orange,
    V = colors.magenta,
    [''] = colors.magenta,
    v = colors.magenta,
    R = colors.red,
  }

  return mode_colors[vim.fn.mode()]
end

-- Left side
gls.left[1] = {
  FirstElement = {
    -- provider = function() return '▋' end,
    provider = function() return ' ' end,
    highlight = { colors.fg, colors.bg }
  },
}
gls.left[2] = {
  ViMode = {
    provider = function()
      local alias = {
        n = 'N',
        i = 'I',
        c = 'C',
        V = 'V',
        [''] = 'V',
        v = 'V',
        R = 'R',
      }
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color())
      return alias[vim.fn.mode()]..' '
    end,
    highlight = { colors.bg, colors.bg },
    separator = " ",
    separator_highlight = {colors.bg, colors.section_bg},
  },
}
gls.left[3] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.section_bg },
  },
}
gls.left[4] = {
  FileName = {
    provider = { 'FileName' },
    condition = buffer_not_empty,
    highlight = { colors.fg, colors.section_bg },
    separator = " ",
    separator_highlight = {colors.section_bg, colors.bg},
  }
}
gls.left[5] = {
  GitIcon = {
    provider = function() return ' ' end,
    condition = buffer_not_empty,
    highlight = {colors.fg, colors.bg},
  }
}
gls.left[6] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = buffer_not_empty,
    highlight = {colors.fg,colors.bg},
  }
}
gls.left[7] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = ' ',
    highlight = { colors.green, colors.bg },
  }
}
gls.left[8] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = ' ',
    highlight = { colors.orange, colors.bg },
  }
}
gls.left[9] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = ' ',
    highlight = { colors.red,colors.bg },
  }
}
gls.left[10] = {
  LeftEnd = {
    -- provider = function() return ' ' end,
    provider = function() return '' end,
    condition = buffer_not_empty,
    highlight = {colors.section_bg,colors.bg}
  }
}
gls.left[11] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.section_bg}
  }
}
gls.left[12] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.section_bg},
  }
}
gls.left[13] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.orange,colors.section_bg},
  }
}
gls.left[14] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.section_bg},
  }
}
gls.left[15] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue,colors.section_bg},
    separator = " ",
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

-- Right side
gls.right[1]= {
  FileFormat = {
    provider = function() return vim.bo.filetype end,
    highlight = { colors.fg,colors.section_bg },
    separator = " ",
    separator_highlight = { colors.section_bg,colors.bg },
  }
}
gls.right[2] = {
  RightLineInfoEmpty = {
    provider = function() return ' ' end,
    highlight = { colors.fg, colors.section_bg },
    separator = "",
    separator_highlight = { colors.bg, colors.section_bg },
  },
}
gls.right[3] = {
  LineInfo = {
    provider = 'LineColumn',
    highlight = { colors.fg, colors.section_bg },
    separator = " ",
    separator_highlight = { colors.bg, colors.section_bg },
  },
}
gls.right[4] = {
  RightLineInfoEmpty2 = {
    provider = function() return ' ' end,
    highlight = { colors.fg, colors.section_bg },
    separator = "",
    separator_highlight = { colors.bg, colors.section_bg },
  },
}
gls.right[5] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {colors.darkblue,colors.purple},
    highlight = {colors.grey,colors.darkblue},
  }
}
gls.right[6] = {
  RightLineInfoEmpty3 = {
    provider = function() return ' ' end,
    highlight = { colors.fg, colors.section_bg},
    separator = " ",
    separator_highlight = {colors.section_bg, colors.bg},
  },
}
gls.right[7] = {
  FileSize = {
    provider = { 'FileSize' },
    condition = buffer_not_empty,
    highlight = { colors.fg, colors.section_bg},
    separator = "",
    separator_highlight = {colors.section_bg, colors.bg},
  }
}
gls.right[8] = {
  PyVirtualenv = {
    provider = get_virtual_env,
    condition = buffer_not_empty,
    separator = ' ',
    separator_highlight = {colors.darkblue,colors.purple},
    highlight = {colors.grey,colors.darkblue},
  }
}

-- Short status line
gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    highlight = { colors.fg, colors.section_bg },
    separator = " ",
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = { colors.yellow, colors.section_bg },
    separator = " ",
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
