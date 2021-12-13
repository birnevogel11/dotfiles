local ftplugin_util = require('yen3.util.ftplugin')
local config_util = require('yen3.util.config')
local sunsetshiba_color = require('yen3.sunsetshiba')

local M = {}

function M.haskell_vim_setup()
  config_util.set_variables {
    haskell_enable_quantification = 1,
    haskell_enable_recursivedo = 1,
    haskell_enable_arrowsyntax = 1,
    haskell_enable_pattern_synonyms = 1,
    haskell_enable_typeroles = 1,
    haskell_enable_static_pointers = 1,
    haskell_backpack = 1,

    haskell_indent_if = 3,
    haskell_indent_case = 2,
    haskell_indent_let = 2,
    haskell_indent_where = 6,
    haskell_indent_after_bare_where = 2,
    haskell_indent_do = 3,
    haskell_indent_in = 1,
    haskell_indent_guard = 2,
    haskell_indent_case_alternative = 2,
  }
end

function M.stylishask_setup()
  config_util.set_variables {stylishask_on_save = 0,}
  config_util.buf_map_n(0, '<leader>bb', ':Stylishask<cr>')
end

function M.fzf_hoogle_setup()
  config_util.buf_map_n(0, '<leader>fq', ':Hoogle <C-r><C-w><cr>')
  config_util.buf_map_n(0, '<leader>fQ', ':Hoogle')

  if vim.fn.has('mac') == 1 then
    config_util.set_variables {hoogle_open_link = 'open -a Safari',}
  end
end

function M.ghcid_setup()
  config_util.buf_map_n(0, '<leader>dc', ':Ghcid<cr>')
  config_util.buf_map_n(0, '<leader>dC', ':GhcidKill<cr>')
end

function M.hasktags_setup()
  if vim.fn.executable("hasktags") ~= 1 then
    return
  end

  config_util.set_variables {
    ctagsbin    = 'hasktags',
    ctagsargs   = '-x -c -o-',
    kinds       = {
      'm:modules:0:1',
      'd:data:0:1',
      'd_gadt:data gadt:0:1',
      'nt:newtype:0:1',
      'c:classes:0:1',
      'i:instances:0:1',
      'cons:constructors:0:1',
      'c_gadt:constructor gadt:0:1',
      'c_a:constructor accessors:1:1',
      't:type names:0:1',
      'pt:pattern types:0:1',
      'pi:pattern implementations:0:1',
      'ft:function types:0:1',
      'fi:function implementations:0:1',
      'o:others:0:1'
    },
    sro          = '.',
    kind2scope   = {
      m       = 'module',
      d       = 'data',
      d_gadt  = 'd_gadt',
      c_gadt  = 'c_gadt',
      nt      = 'newtype',
      cons    = 'cons',
      c_a     = 'accessor',
      c       = 'class',
      i       = 'instance',
    },
    scope2kind   = {
      module   = 'm',
      data     = 'd',
      newtype  = 'nt',
      cons     = 'c_a',
      d_gadt   = 'c_gadt',
      class    = 'ft',
      instance = 'ft',
    },
  }
end

function M.setup()
  ftplugin_util.indention_setup(2, 80)
  sunsetshiba_color.ftplugin.haskell()

  M.haskell_vim_setup()
  M.stylishask_setup()
  M.ghcid_setup()
  M.fzf_hoogle_setup()
  M.hasktags_setup()
end

M.setup()
