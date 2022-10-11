-- Name:         SunsetShiba
-- Description:  Dark Theme from onedarkish
--               The theme is original desgined by Pedro Ferrai
--               Please refer http://github.com/petobens/colorish to get more
--               details. The file convert it to lua format.
--               The color is adopted from onedarkish by sunsetshiba.
-- Author:       Pedro Ferrari (http://github.com/petobens/colorish)
--               sunsetshiba
--               yen3 <yerc@gmail.com>
-- Maintainer:   yen3 <yen3@gmail.com>
-- Website:      https://gitlab.com/yen3/dotfiles/-/blob/master/vim/lua/sunsetshiba.lua
-- License:      Vim License (see `:help license`)

-- ref: https://github.com/Th3Whit3Wolf/spacebuddy/blob/main/lua/spacebuddy.lua

local M = {
  colorscheme_name = "sunsetshiba",
  lang = {},
  color = {},
  ftplugin = {},
  plugin = {},
}

local Color, _, Group, _, _ = require("colorbuddy").setup()
local g = require('colorbuddy.group').groups
local s = require('colorbuddy.style').styles
local c = require('colorbuddy.color').colors
local b = s.bold
local i = s.NONE
if vim.fn.exists("g:one_allow_italics") == 1 then
  if vim.api.nvim_get_var("one_allow_italics") == 1 then
    i = s.italic
  end
end
-- local n = s.inverse
local uc = s.undercurl
local ul = s.underline
local r = s.reverse
-- local sto = s.standout
local no = s.NONE
local cno = c.none

function M.init_theme()
  vim.api.nvim_command([[ hi clear ]])
  if vim.fn.exists('syntax_on') == 1 then
    vim.api.nvim_command([[ syntax reset ]])
  end
  vim.o.background = "dark"

  local color_var_name = "color_name"
  if vim.fn.exists('g:'..color_var_name) == 1 then
    vim.api.nvim_del_var(color_var_name)
  end
  vim.api.nvim_set_var(color_var_name, M.colorscheme_name)
end

function M.init_color()
  M.color = {
    white           = '#abb2bf',
    mono_2          = '#828997',
    comment_grey    = '#777c84',
    hi_comment_grey = '#e6e6e6',
    mono_4          = '#4b5263',
    cyan            = '#56b6c2',
    light_blue      = '#6ba1f2',
    blue            = '#4c81f1',
    purple          = '#6972f3',
    bright_magenta  = '#dc85f7',
    green           = '#81ad61',
    red             = '#ca8288',
    dark_red        = '#be5046',
    dark_yellow     = '#d19a66',
    yellow          = '#dcc342',
    yellow_warm     = '#c1ae4d',
    orange          = '#d19a66',
    fake_black      = '#282c34',
    black           = '#24272e',
    cursor_grey     = '#2c323c',
    gutter_fg_grey  = '#636d83',
    special_grey    = '#3b4048',
    visual_grey     = '#3e4452',
    column_gray     = '#30353e',
    -- pmenu        = '#333841',
    pmenu           = '#3b4048',
    bg              = '#272b33',
  }

  -- Comments refer to 256 terminal colors
  Color.new('white',           M.color.white)          -- 145 (fake whie)
  Color.new('mono_2',          M.color.mono_2)
  Color.new('comment_grey',    M.color.comment_grey)   -- 59
  Color.new('hi_comment_grey', M.color.hi_comment_grey)
  Color.new('mono_4',          M.color.mono_4)

  Color.new('cyan',            M.color.cyan)           -- 38
  Color.new('light_blue',      M.color.light_blue)     -- 39
  Color.new('blue',            M.color.blue)           -- light_blueish
  Color.new('purple',          M.color.purple)         -- 170
  Color.new('bright_magenta',  M.color.bright_magenta)
  Color.new('green',           M.color.green)          -- 114

  Color.new('red',             M.color.red)            -- 204
  Color.new('dark_red',        M.color.dark_red)       -- 196
  Color.new('dark_yellow',     M.color.dark_yellow)    -- 173
  Color.new('yellow',          M.color.yellow)         -- 180
  Color.new('yellow_warm',     M.color.yellow_warm)    -- 180

  -- The original background and cursor colors are
  -- let s:black     = '282c34' " 235 (fake black)
  -- let s:cursor_grey = '2c323c' " 236
  -- We make the background a bit more dark
  Color.new('fake_black',     M.color.fake_black)      -- 235
  Color.new('black',          M.color.black)           -- 235 (fake black)
  Color.new('cursor_grey',    M.color.cursor_grey)     -- 236
  Color.new('column_gray',    M.color.column_gray)

  Color.new('gutter_fg_grey', M.color.gutter_fg_grey)  -- 238
  Color.new('special_grey',   M.color.special_grey)    -- 238
  Color.new('visual_grey',    M.color.visual_grey)     -- 237
  Color.new('pmenu',          M.color.pmenu)           -- 237

  Color.new('syntax_fg',      M.color.white)
  Color.new('syntax_fold_bg', M.color.comment_grey)
  Color.new('bg',             M.color.bg)
end

function M.hl_general()
  -- Don't set normal bg color: See: https://github.com/neovim/neovim/issues/9019
  Group.new('Normal',        c.syntax_fg,     cno,            no)
  Group.new('bold',          cno,             cno,            b )
  Group.new('ColorColumn',   cno,             c.column_gray,  no)
  Group.new('Conceal',       c.mono_4,        c.black,        no)
  Group.new('Cursor',        cno,             c.blue,         no)
  Group.new('CursorIM',      cno,             cno,            no)
  Group.new('CursorColumn',  cno,             c.cursor_grey,  no)
  Group.new('CursorLine',    cno,             c.cursor_grey,  no)
  Group.new('QuickFixLine',  g.Normal,        g.Normal,       g.Normal)
  Group.new('TermCursor',    c.blue,          cno,            no)
  Group.new('NormalFloat',   c.syntax_fg,     c.black,        no)
  Group.new('Directory',     c.light_blue,    cno,            no)
  Group.new('ErrorMsg',      c.red,           c.black,        no)
  Group.new('VertSplit',     c.cursor_grey,   cno,            no)
  Group.new('Folded',        c.comment_grey,  c.black,        no)
  Group.new('FoldColumn',    c.comment_grey,  c.black,        no)
  Group.new('IncSearch',     c.dark_yellow,   cno,            no)
  Group.new('LineNr',        c.mono_4,        c.bg,           no)
  Group.new('CursorLineNr',  c.syntax_fg,     c.black,        no)
  Group.new('MatchParen',    c.blue,          c.cursor_grey,  b )
  Group.new('Italic',        cno,             cno,            i )
  Group.new('ModeMsg',       c.dark_yellow,   cno,            no)
  Group.new('MoreMsg',       c.dark_yellow,   cno,            no)
  Group.new('NonText',       c.comment_grey,  cno,            no)
  Group.new('PMenu',         c.syntax_fg,     c.pmenu,        no)
  Group.new('PMenuSel',      c.black,         c.light_blue,   no)
  Group.new('PMenuSbar',     c.syntax_fg,     c.pmenu,        no)
  Group.new('PMenuThumb',    cno,             c.white,        no)
  Group.new('Question',      c.light_blue,    cno,            no)
  Group.new('Search',        c.black,         c.yellow,       no)
  Group.new('SpecialKey',    c.special_grey,  cno,            no)
  Group.new('Whitespace',    c.special_grey,  cno,            no)
  Group.new('StatusLine',    c.syntax_fg,     c.cursor_grey,  no)
  Group.new('StatusLineNC',  c.cursor_grey,   cno,            no)
  Group.new('TabLine',       c.white,         c.black,        no)
  Group.new('TabLineFill',   c.comment_grey,  c.visual_grey,  no)
  Group.new('TabLineSel',    c.black,         c.blue,         b )
  Group.new('Title',         c.syntax_fg,     cno,            b )
  Group.new('Visual',        cno,             c.visual_grey,  no)
  Group.new('VisualNOS',     cno,             c.visual_grey,  no)
  Group.new('WarningMsg',    c.dark_yellow,   cno,            no)
  Group.new('TooLong',       c.red,           cno,            no)
  Group.new('WildMenu',      c.black,         c.light_blue,   no)
  Group.new('SignColumn',    cno,             c.bg,           no)
  Group.new('Special',       c.light_blue,    cno,            no)
end

function M.hl_syntax()
  -- Syntax highlighting
  Group.new('Comment',           c.comment_grey,  cno,      no)
  Group.new('Constant',          c.green,         cno,      no)
  Group.new('String',            c.green,         cno,      no)
  Group.new('Character',         c.green,         cno,      no)
  Group.new('Number',            c.dark_yellow,   cno,      no)
  Group.new('Boolean',           c.dark_yellow,   cno,      no)
  Group.new('Float',             c.dark_yellow,   cno,      no)
  Group.new('Identifier',        c.red,           cno,      no)
  Group.new('Function',          c.light_blue,    cno,      no)
  Group.new('Statement',         c.purple,        cno,      no)
  Group.new('Conditional',       c.purple,        cno,      no)
  Group.new('Repeat',            c.purple,        cno,      no)
  Group.new('Label',             c.purple,        cno,      no)
  Group.new('Operator',          c.blue,          cno,      no)
  Group.new('Keyword',           c.red,           cno,      no)
  Group.new('Exception',         c.purple,        cno,      no)
  Group.new('PreProc',           c.yellow,        cno,      no)
  Group.new('Include',           c.light_blue,    cno,      no)
  Group.new('Define',            c.purple,        cno,      no)
  Group.new('Macro',             c.purple,        cno,      no)
  Group.new('PreCondit',         c.yellow,        cno,      no)
  Group.new('Type',              c.yellow,        cno,      no)
  Group.new('StorageClass',      c.yellow,        cno,      no)
  Group.new('Structure',         c.yellow,        cno,      no)
  Group.new('Typedef',           c.yellow,        cno,      no)
  Group.new('Special',           c.light_blue,    cno,      no)
  Group.new('SpecialChar',       cno,             cno,      no)
  Group.new('Tag',               cno,             cno,      no)
  Group.new('Delimiter',         c.blue,          cno,      no)
  Group.new('SpecialComment',    cno,             cno,      no)
  Group.new('Debug',             cno,             cno,      no)
  Group.new('Underlined',        cno,             cno,      no)
  Group.new('Ignore',            cno,             cno,      no)
  Group.new('Error',             c.red,           c.black,  b )
  Group.new('Todo',              c.red,           c.black,  no)

  -- Spelling
  Group.new('SpellBad',          cno,             cno,      uc)
  Group.new('SpellLocal',        cno,             cno,      uc)
  Group.new('SpellCap',          cno,             cno,      uc)
  Group.new('SpellRare',         cno,             cno,      uc)

  -- Vim help
  Group.new('helpCommand',       c.yellow,        cno,      no)
  Group.new('helpExample',       c.yellow,        cno,      no)
  Group.new('helpHeader',        c.white,         cno,      b )
  Group.new('helpSectionDelim',  c.comment_grey,  cno,      no)
end


function M.hl_neovim_terminal()
  vim.g.terminal_color_0          = M.color.black
  vim.g.terminal_color_1          = M.color.red
  vim.g.terminal_color_2          = M.color.green
  vim.g.terminal_color_3          = M.color.yellow
  vim.g.terminal_color_4          = M.color.light_blue
  vim.g.terminal_color_5          = M.color.purple
  vim.g.terminal_color_6          = M.color.cyan
  vim.g.terminal_color_7          = M.color.white
  vim.g.terminal_color_8          = M.color.visual_grey
  vim.g.terminal_color_9          = M.color.dark_red
  vim.g.terminal_color_10         = M.color.green
  vim.g.terminal_color_11         = M.color.dark_yellow
  vim.g.terminal_color_12         = M.color.light_blue
  vim.g.terminal_color_13         = M.color.purple
  vim.g.terminal_color_14         = M.color.cyan
  vim.g.terminal_color_15         = M.color.comment_grey
  vim.g.terminal_color_background = vim.g.terminal_color_0
  vim.g.terminal_color_foreground = vim.g.terminal_color_7
end

function M.hl_treesitter()
  Group.new('TSType',                c.yellow_warm,  cno,  no)
  Group.new('TSVariable',            c.syntax_fg,    cno,  no)
  Group.new('TSField'   ,            c.syntax_fg,    cno,  no)
  Group.new('TSProperty',            c.syntax_fg,    cno,  no)
  Group.new('TSParameter',           c.syntax_fg,    cno,  no)
  Group.new('TSVariableBuiltin',     c.dark_yellow,  cno,  no)
  Group.new('TSPunctDelimiter',      c.blue,         cno,  no)
  Group.new('TSConstBuiltin',        c.green,        cno,  no)
  Group.new('TSOperator',            c.blue,         cno,  no)
  Group.new('TSKeyword',             c.light_blue,   cno,  no)
  Group.new('TSKeywordReturn',       c.light_blue,   cno,  no)
  Group.new('TSKeywordFunction',     c.light_blue,   cno,  no)
  Group.new('TSConstructor',         c.syntax_fg,    cno,  no)
  Group.new('TSInclude',             c.light_blue,   cno,  no)
  Group.new('TSRepeat',              c.light_blue,   cno,  no)
  Group.new('TSConditional',         c.light_blue,   cno,  no)
  Group.new('TSFunction',            c.syntax_fg,    cno,  no)
  Group.new('TSMethod',              c.syntax_fg,    cno,  no)
  Group.new('TSFuncBuiltin',         c.blue,         cno,  no)
end

function M.hl_treesitter_onedarkishii()
  Group.new('TSAnnotation',          c.red,           cno,  no)
  Group.new('TSAttribute',           c.syntax_fg,     cno,  no)
  Group.new('TSBoolean',             c.dark_yellow,   cno,  no)
  Group.new('TSCharacter',           c.green,         cno,  no)
  Group.new('TSComment',             c.comment_grey,  cno,  no)
  Group.new('TSConditional',         c.purple,        cno,  no)
  Group.new('TSConstructor',         c.dark_yellow,   cno,  no)
  Group.new('TSConstant',            c.green,         cno,  no)
  Group.new('TSConstBuiltin',        c.green,         cno,  no)
  Group.new('TSConstMacro',          c.green,         cno,  no)
  Group.new('TSError',               c.red,           cno,  no)
  Group.new('TSException',           c.dark_yellow,   cno,  no)
  Group.new('TSField',               c.syntax_fg,     cno,  no)
  Group.new('TSFloat',               c.dark_yellow,   cno,  no)
  Group.new('TSFunction',            c.light_blue,    cno,  no)
  Group.new('TSFuncBuiltin',         c.dark_yellow,   cno,  no)
  Group.new('TSFuncMacro',           c.syntax_fg,     cno,  no)
  Group.new('TSInclude',             c.purple,        cno,  no)
  Group.new('TSKeyword',             c.purple,        cno,  no)
  Group.new('TSKeywordFunction',     c.purple,        cno,  no)
  Group.new('TSKeywordOperator',     c.light_blue,    cno,  no)
  Group.new('TSKeywordReturn',       c.purple,        cno,  no)
  Group.new('TSLabel',               c.blue,          cno,  no)
  Group.new('TSMethod',              c.light_blue,    cno,  no)
  -- Group.new('TSNamespace',           cno,             cno,  no)
  Group.new('TSNone',                c.green,         cno,  no)
  Group.new('TSNumber',              c.dark_yellow,   cno,  no)
  Group.new('TSOperator',            c.purple,        cno,  no)
  Group.new('TSParameter',           c.syntax_fg,     cno,  no)
  -- Group.new('TSParameterReference',  c.syntax_fg,     cno,  no)
  Group.new('TSProperty',            c.syntax_fg,     cno,  no)
  Group.new('TSPunctDelimiter',      c.syntax_fg,     cno,  no)
  Group.new('TSPunctBracket',        c.syntax_fg,     cno,  no)
  Group.new('TSPunctSpecial',        c.syntax_fg,     cno,  no)
  Group.new('TSRepeat',              c.purple,        cno,  no)
  Group.new('TSString',              c.green,         cno,  no)
  Group.new('TSStringRegex',         c.cyan,          cno,  no)
  Group.new('TSStringEscape',        c.cyan,          cno,  no)
  Group.new('TSTag',                 c.red,           cno,  no)
  Group.new('TSTagDelimiter',        c.mono_2,        cno,  no)
  -- Group.new('TSText',                cno,             cno,  no)
  -- Group.new('TSEmphasis',            cno,             cno,  no)
  -- Group.new('TSStrike',              cno,             cno,  no)
  -- Group.new('TSUnderline',           cno,             cno,  no)
  -- Group.new('TStrong',               cno,             cno,  no)
  Group.new('TSTitle',               c.green,         cno,  no)
  -- Group.new('TSLiteral',             cno,             cno,  no)
  -- Group.new('TSURI',                 cno,             cno,  no)
  -- Group.new('TSMath',                cno,             cno,  no)
  -- Group.new('TSTextReference',       cno,             cno,  no)
  -- Group.new('TSEnvironmentName',     cno,             cno,  no)
  -- Group.new('TSNote',                cno,             cno,  no)
  -- Group.new('TSDanger',              cno,             cno,  no)
  Group.new('TSType',                c.yellow,        cno,  no)
  Group.new('TSTypeBuiltin',         c.yellow,        cno,  no)
  Group.new('TSVariable',            c.syntax_fg,     cno,  no)
  Group.new('TSVariableBuiltin',     c.red,           cno,  i )
end

function M.hl_lsp()
  Group.new('DiagnosticError',             c.dark_red,     cno,  no)
  Group.new('DiagnosticHint',              c.mono_2,       cno,  no)
  Group.new('DiagnosticInfor',             c.mono_2,       cno,  no)
  Group.new('DiagnosticWarn',              c.dark_yellow,  cno,  no)
  Group.new('DiagnosticDefaultError',      c.dark_red,     cno,  no)
  Group.new('DiagnosticDefaultHint',       c.mono_2,       cno,  no)
  Group.new('DiagnosticDefaultInfo',       c.mono_2,       cno,  no)
  Group.new('DiagnosticDefaultWarn',       c.dark_yellow,  cno,  no)
  Group.new('DiagnosticUnderlineError',    c.dark_red,     cno,  ul)
  Group.new('DiagnosticUnderlineHint',     c.syntax_fg,    cno,  ul)
  Group.new('DiagnosticUnderlineInfo',     c.syntax_fg,    cno,  ul)
  Group.new('DiagnosticUnderlineWarn' ,    c.dark_yellow,  cno,  ul)
  Group.new('DiagnosticVirtualTextError',  c.dark_red,     cno,  no)
  Group.new('DiagnosticVirtualTextHint',   c.mono_2,       cno,  no)
  Group.new('DiagnosticVirtualTextInfo',   c.mono_2,       cno,  no)
  Group.new('DiagnosticVirtualTextWarn',   c.yellow,       cno,  no)
  Group.new('DiagnosticSignError',         c.dark_red,     cno,  no)
  Group.new('DiagnosticSignWarn',          c.dark_yellow,  cno,  no)
  Group.new('DiagnosticSignInfo',          c.mono_2,       cno,  no)
  Group.new('DiagnosticSignHint',          c.mono_2,       cno,  no)
  Group.new('DiagnosticFloatingError',     c.dark_red,     cno,  no)
  Group.new('DiagnosticFloatingWarn',      c.dark_yellow,  cno,  no)
  Group.new('DiagnosticFloatingInfo',      c.mono_2,       cno,  no)
  Group.new('DiagnosticFloatingHint',      c.mono_2,       cno,  no)
end

function M.plugin.hl_plugins()
  -- Denite
  Group.new('deniteSource_grepFile',      c.light_blue,    cno,            no)

  -- Defx
  Group.new('Defx_filename_3_marker',     c.light_blue,    cno,            no)
  Group.new('Defx_git_6_Modified',        c.red,           cno,            no)
  Group.new('Defx_git_6_Staged',          c.green,         cno,            no)
  Group.new('Defx_mark_0_readonly',       c.dark_red,      cno,            no)

  -- Fugitive
  Group.new('diffAdded',                  c.green,         cno,            no)
  Group.new('diffRemoved',                c.red,           cno,            no)
  Group.new('fugitiveUnstagedHeading',    c.red,           cno,            no)
  Group.new('fugitiveUnstagedModifier',   c.red,           cno,            no)
  Group.new('fugitiveStagedHeading',      c.green,         cno,            no)
  Group.new('fugitiveStagedModifier',     c.green,         cno,            no)

  -- Git gutter
  Group.new('GitGutterAdd',               c.green,         cno,            no)
  Group.new('GitGutterChange',            c.yellow,        cno,            no)
  Group.new('GitGutterDelete',            c.red,           cno,            no)

  -- GitMessenger
  Group.new('gitmessengerHeader',         c.purple,        cno,            no)
  Group.new('gitmessengerHash',           c.yellow,        cno,            no)
  Group.new('gitmessengerPopupNormal',    cno,             c.cursor_grey,  no)

  -- HighlightedYank
  Group.new('HighlightedyankRegion',      c.green,         cno,            no)

  -- Interesting words (from Steve Losh's vimrc)
  Group.new('InterestingWord1',           c.black,         c.yellow,       no)
  Group.new('InterestingWord2',           c.black,         c.green,        no)
  Group.new('InterestingWord3',           c.black,         c.purple,       no)
  Group.new('InterestingWord4',           c.black,         c.dark_yellow,  no)
  Group.new('InterestingWord5',           c.black,         c.light_blue,   no)
  Group.new('InterestingWord6',           c.black,         c.white,        no)

  -- Neomake
  Group.new('NeomakeVirtualtextError',    c.red,           c.cursor_grey,  no)
  Group.new('NeomakeVirtualtextWarning',  c.dark_yellow,   c.cursor_grey,  no)
  Group.new('NeomakeVirtualtextInfo',     c.red,           c.cursor_grey,  no)
  Group.new('NeomakeVirtualtextMessage',  c.red,           c.cursor_grey,  no)

  -- Sneak
  Group.new('Sneak',                      c.black,         c.purple,       no)

  -- Tagbar
  Group.new('TagbarKind',                 c.yellow,        cno,            no)
  Group.new('TagbarScope',                c.yellow,        cno,            no)
  Group.new('TagbarNestedKind',           c.light_blue,    cno,            no)
  Group.new('TagbarSignature',            c.comment_grey,  cno,            no)
  Group.new('TagbarType',                 c.light_blue,    cno,            no)
  Group.new('TagbarVisibilityPrivate',    c.dark_red,      cno,            no)
  Group.new('TagbarVisibilityProtected',  c.dark_red,      cno,            no)
  Group.new('TagbarVisibilityPublic',     c.green,         cno,            no)
  Group.new('TagbarFoldIcon',             c.light_blue,    cno,            no)

  --  Diff-git-sign
  Group.new('DiffGitAdd',      c.green,        cno,            no)
  Group.new('DiffGitChange',   c.dark_yellow,  cno,            no)
  Group.new('DiffGitDelete',   c.red,          cno,            no)
  Group.new('DiffGitText',     c.light_blue,   cno,            no)
  Group.new('DiffGitAdded',    c.green,        cno,            no)
  Group.new('DiffGitFile',     c.red,          cno,            no)
  Group.new('DiffGitNewFile',  c.green,        cno,            no)
  Group.new('DiffGitLine',     c.light_blue,   cno,            no)
  Group.new('DiffGitRemoved',  c.red,          cno,            no)

  -- IndentBlanklineChar
  Group.new('IndentBlanklineChar',  c.special_grey,          cno,            no)
end

function M.plugin.hl_lspsaga()
  Group.new('LspSagaCodeActionTitle',         c.comment_grey, cno,   no)
  Group.new('LspSagaCodeActionTruncateLine',  c.comment_grey, cno,   no)
  Group.new('LspSagaCodeActionContent',       c.syntax_fg,    cno,   no)
  Group.new('LspSagaRenamePromptPrefix',      c.comment_grey, cno,   no)
  Group.new('LspSagaRenameBorder',            c.comment_grey, cno,   no)
  Group.new('LspSagaCodeActionBorder',        c.comment_grey, cno,   no)
  Group.new('LspSagaDefPreviewBorder',        c.comment_grey, cno,   no)
  Group.new('LspSagaDiagnosticBorder',        c.comment_grey, cno,   no)
  Group.new('LspSagaDiagnosticHeader',        c.comment_grey, cno,   no)
  Group.new('LspSagaDiagnosticTruncateLine',  c.comment_grey, cno,   no)
  Group.new('LspDiagnosticsFloatingError',    c.dark_red,     cno,   no)
  Group.new('LspDiagnosticsFloatingWarn',     c.dark_yellow,  cno,   no)
  Group.new('LspDiagnosticsFloatingInfor',    c.syntax_fg,    cno,   no)
  Group.new('LspDiagnosticsFloatingHint',     c.syntax_fg,    cno,   no)
end


function M.plugin.hl_nvim_cmp()
  -- https://github.com/hrsh7th/nvim-cmp#highlights
	-- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/lsp.lua#L108
  -- https://github.com/olimorris/onedarkpro.nvim/blob/main/lua/onedarkpro/theme.lua
  Group.new('CmpDocumentation',         c.syntax_fg, cno, no)
  Group.new('CmpDocumentationBorder',   c.syntax_fg, cno, no)

  Group.new('CmpItemAbbr',              c.syntax_fg, cno, no)
  Group.new('CmpItemAbbrMatch',         c.syntax_fg, cno, no)
  Group.new('CmpItemAbbrMatchFuzzy',    c.syntax_fg, cno, no)
  Group.new('CmpItemMenu',              c.syntax_fg, cno, no)

  Group.new('CmpItemKindText',          c.mono_2, cno, no)
  Group.new('CmpItemKindMethod',        c.mono_2, cno, no)
  Group.new('CmpItemKindFunction',      c.mono_2, cno, no)
  Group.new('CmpItemKindConstructor',   c.mono_2, cno, no)
  Group.new('CmpItemKindField',         c.mono_2, cno, no)
  Group.new('CmpItemKindVariable',      c.mono_2, cno, no)
  Group.new('CmpItemKindClass',         c.mono_2, cno, no)
  Group.new('CmpItemKindInterface',     c.mono_2, cno, no)
  Group.new('CmpItemKindModule',        c.mono_2, cno, no)
  Group.new('CmpItemKindProperty',      c.mono_2, cno, no)
  Group.new('CmpItemKindUnit',          c.mono_2, cno, no)
  Group.new('CmpItemKindValue',         c.mono_2, cno, no)
  Group.new('CmpItemKindEnum',          c.mono_2, cno, no)
  Group.new('CmpItemKindKeyword',       c.mono_2, cno, no)
  Group.new('CmpItemKindSnippet',       c.mono_2, cno, no)
  Group.new('CmpItemKindColor',         c.mono_2, cno, no)
  Group.new('CmpItemKindFile',          c.mono_2, cno, no)
  Group.new('CmpItemKindReference',     c.mono_2, cno, no)
  Group.new('CmpItemKindFolder',        c.mono_2, cno, no)
  Group.new('CmpItemKindEnumMember',    c.mono_2, cno, no)
  Group.new('CmpItemKindConstant',      c.mono_2, cno, no)
  Group.new('CmpItemKindStruct',        c.mono_2, cno, no)
  Group.new('CmpItemKindEvent',         c.mono_2, cno, no)
  Group.new('CmpItemKindOperator',      c.mono_2, cno, no)
  Group.new('CmpItemKindTypeParameter', c.mono_2, cno, no)
end

function M.hl_nvim_cmp_colorful()
  -- https://github.com/hrsh7th/nvim-cmp#highlights
	-- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/lsp.lua#L108
  -- https://github.com/olimorris/onedarkpro.nvim/blob/main/lua/onedarkpro/theme.lua
  Group.new('CmpItemAbbrMatch',        c.light_blue,    cno,            no)
  Group.new('CmpItemAbbrMatchFuzzy',   c.blue,          cno,            no)
  Group.new('CmpItemMenu',             c.syntax_fg,     cno,            no)
  Group.new('CmpItemKind',             c.blue,          cno,            no)
  Group.new('CmpItemKindText',         c.syntax_fg,     cno,            no)
  Group.new('CmpItemKindMethod',       c.blue,          cno,            no)
  Group.new('CmpItemKindFunction',     c.blue,          cno,            no)
  Group.new('CmpItemKindConstructor',  c.cyan,          cno,            no)
  Group.new('CmpItemKindField',        c.syntax_fg,     cno,            no)
  Group.new('CmpItemKindVariable',     c.red,           cno,            no)
  Group.new('CmpItemKindClass',        c.yellow,        cno,            no)
  Group.new('CmpItemKindInterface',    c.yellow,        cno,            no)
  Group.new('CmpItemKindProperty',     c.red,           cno,            no)
  Group.new('CmpItemKindValue',        c.orange,        cno,            no)
  Group.new('CmpItemKindKeyword',      c.purple,        cno,            no)
  Group.new('CmpItemKindSnippet',      c.green,         cno,            no)
  Group.new('CmpItemKindConstant',     c.green,         cno,            no)
end

function M.plugin.hl_neo_tree_nvim()
  Group.new('NeoTreeDirectoryIcon',    c.blue,          cno,            no)
  Group.new('NeoTreeFileIcon',         c.green,         cno,            no)
  Group.new('NeoTreeGitModified',      c.yellow,        cno,            no)
  Group.new('NeoTreeGitUntracked',     c.dark_yellow,   cno,            no)
end

function M.lang.ansiidoc()
  Group.new('asciidocListingBlock',  c.mono_2,        cno,  no)
end

function M.lang.c_cpp()
  Group.new('cInclude',              c.purple,        cno,  no)
  Group.new('cType',                 c.yellow,        cno,  no)
  Group.new('cPreCondit',            c.purple,        cno,  no)
  Group.new('cPreConditMatch',       c.purple,        cno,  no)
  Group.new('cCppString',            c.green,         cno,  no)
  Group.new('cStorageClass',         c.purple,        cno,  no)
  Group.new('cStructure',            c.purple,        cno,  no)
  Group.new('cOperator',             c.purple,        cno,  no)
  Group.new('cStatement',            c.purple,        cno,  no)
  Group.new('cCommentL',             c.comment_grey,  cno,  no)
  Group.new('cComment',              c.comment_grey,  cno,  no)
  Group.new('cTODO',                 c.yellow,        cno,  no)
  Group.new('cConstant',             c.dark_yellow,   cno,  no)
  Group.new('cSpecial',              c.cyan,          cno,  no)
  Group.new('cSpecialCharacter',     c.cyan,          cno,  no)
  Group.new('cString',               c.green,         cno,  no)
  Group.new('cppType',               c.purple,        cno,  no)
  Group.new('cppStorageClass',       c.purple,        cno,  no)
  Group.new('cppStructure',          c.purple,        cno,  no)
  Group.new('cppModifier',           c.purple,        cno,  no)
  Group.new('cppOperator',           c.purple,        cno,  no)
  Group.new('cppAccess',             c.purple,        cno,  no)
  Group.new('cppStatement',          c.purple,        cno,  no)
  Group.new('cppConstant',           c.red,           cno,  no)
  Group.new('cCppString',            c.green,         cno,  no)
end

function M.lang.css()
  Group.new('cssAttrComma',          c.purple,       cno,  no)
  Group.new('cssAttributeSelector',  c.green,        cno,  no)
  Group.new('cssBraces',             c.mono_2,       cno,  no)
  Group.new('cssClassName',          c.dark_yellow,  cno,  no)
  Group.new('cssClassNameDot',       c.dark_yellow,  cno,  no)
  Group.new('cssDefinition',         c.purple,       cno,  no)
  Group.new('cssFontAttr',           c.dark_yellow,  cno,  no)
  Group.new('cssFontDescriptor',     c.purple,       cno,  no)
  Group.new('cssFunctionName',       c.light_blue,   cno,  no)
  Group.new('cssIdentifier',         c.light_blue,   cno,  no)
  Group.new('cssImportant',          c.purple,       cno,  no)
  Group.new('cssInclude',            c.white,        cno,  no)
  Group.new('cssIncludeKeyword',     c.purple,       cno,  no)
  Group.new('cssMediaType',          c.dark_yellow,  cno,  no)
  Group.new('cssProp',               c.cyan,         cno,  no)
  Group.new('cssPseudoClassId',      c.dark_yellow,  cno,  no)
  Group.new('cssSelectorOp',         c.purple,       cno,  no)
  Group.new('cssSelectorOp2',        c.purple,       cno,  no)
  Group.new('cssStringQ',            c.green,        cno,  no)
  Group.new('cssStringQQ',           c.green,        cno,  no)
  Group.new('cssTagName',            c.red,          cno,  no)
  Group.new('cssAttr',               c.dark_yellow,  cno,  no)
end

function M.lang.diff()
  Group.new('DiffAdd',         c.green,        c.visual_grey,  no)
  Group.new('DiffChange',      c.dark_yellow,  c.visual_grey,  no)
  Group.new('DiffDelete',      c.red,          c.visual_grey,  no)
  Group.new('DiffText',        c.light_blue,   c.visual_grey,  no)
  Group.new('DiffAdded',       c.green,        c.visual_grey,  no)
  Group.new('DiffFile',        c.red,          c.visual_grey,  no)
  Group.new('DiffNewFile',     c.green,        c.visual_grey,  no)
  Group.new('DiffLine',        c.light_blue,   c.visual_grey,  no)
  Group.new('DiffRemoved',     c.red,          c.visual_grey,  no)
end

function M.lang.doxygen()
  Group.new('doxygenBrief',               c.hi_comment_grey,  cno,  no)
  Group.new('doxygenSpecial',             c.hi_comment_grey,  cno,  no)
  Group.new('doxygenSpecialOnelineDesc',  c.hi_comment_grey,  cno,  no)
end

function M.lang.git()
  Group.new('gitcommitComment',        c.comment_grey,  cno,  no)
  Group.new('gitcommitUnmerged',       c.green,         cno,  no)
  Group.new('gitcommitOnBranch',       cno,             cno,  no)
  Group.new('gitcommitBranch',         c.purple,        cno,  no)
  Group.new('gitcommitDiscardedType',  c.red,           cno,  no)
  Group.new('gitcommitSelectedType',   c.green,         cno,  no)
  Group.new('gitcommitHeader',         cno,             cno,  no)
  Group.new('gitcommitUntrackedFile',  c.cyan,          cno,  no)
  Group.new('gitcommitDiscardedFile',  c.red,           cno,  no)
  Group.new('gitcommitSelectedFile',   c.green,         cno,  no)
  Group.new('gitcommitUnmergedFile',   c.yellow,        cno,  no)
  Group.new('gitcommitFile',           cno,             cno,  no)

  Group.new('gitcommitNoBranch',        g.gitcommitBranch,         g.gitcommitBranch,          g.gitcommitBranch)
  Group.new('gitcommitUntracked',       g.gitcommitComment,        g.gitcommitComment,         g.gitcommitComment)
  Group.new('gitcommitDiscarded',       g.gitcommitComment,        g.gitcommitComment,         g.gitcommitComment)
  Group.new('gitcommitSelected',        g.gitcommitComment,        g.gitcommitComment,         g.gitcommitComment)
  Group.new('gitcommitDiscardedArrow',  g.gitcommitDiscardedFile,  g.gitcommitDiscardedFile,   g.gitcommitDiscardedFile)
  Group.new('gitcommitSelectedArrow',   g.gitcommitSelectedFile,   g.gitcommitSelectedFile,    g.gitcommitSelectedFile)
  Group.new('gitcommitUnmergedArro ',   g.gitcommitUnmergedFile,   g.gitcommitUnmergedFile,    g.gitcommitUnmergedFile)
end

function M.lang.go()
  Group.new('goBuiltins',      c.cyan,    cno,  no)
  Group.new('goConst',         c.purple,  cno,  no)
  Group.new('goDeclaration',   c.purple,  cno,  no)
  Group.new('goDeclType',      c.cyan,    cno,  no)
  Group.new('goField',         c.red,     cno,  no)
  Group.new('goFunctionCall',  c.blue,    cno,  no)
  Group.new('goMethod',        c.cyan,    cno,  no)
  Group.new('goType',          c.yellow,  cno,  no)
  Group.new('goTypeDecl',      c.purple,  cno,  no)
  Group.new('goTypeName',      c.yellow,  cno,  no)
  Group.new('goUnsignedInts',  c.cyan,    cno,  no)
  Group.new('goVar',           c.purple,  cno,  no)
  Group.new('goVarAssign',     c.red,     cno,  no)
  Group.new('goVarDefs',       c.red,     cno,  no)
end

function M.lang.haskell()
  Group.new('haskellBottom',            c.yellow_warm,  cno,  no)
  Group.new('haskellDecl',              c.light_blue,   cno,  no)
  Group.new('haskellDeclKeyword',       c.light_blue,   cno,  no)
  Group.new('haskellDeriveKeyword',     c.blue,         cno,  no)
  Group.new('haskellIdentifier',        c.syntax_fg,    cno,  no)
  Group.new('haskellRecordIdentifier',  c.syntax_fg,    cno,  no)
  Group.new('haskellKeyword',           c.light_blue,   cno,  no)
  Group.new('haskellLet',               c.light_blue,   cno,  no)
  Group.new('haskellWhere',             c.light_blue,   cno,  no)
  Group.new('haskellOperators',         c.light_blue,   cno,  no)
  Group.new('haskellConditional',       c.light_blue,   cno,  no)
  Group.new('haskellDelimiter',         c.syntax_fg,    cno,  no)
  Group.new('haskellType',              c.yellow_warm,  cno,  no)
  Group.new('haskellAssocType',         c.syntax_fg,    cno,  no)
  Group.new('haskellQuotedtype',        c.syntax_fg,    cno,  no)
  Group.new('haskellPragma',            c.mono_2,       cno,  no)
  Group.new('haskellLiquid',            c.mono_2,       cno,  no)
  Group.new('haskellForall',            c.light_blue,   cno,  no)
end

function M.lang.purescript()
  Group.new('purescriptAssocType',        c.syntax_fg,    cno,  no)
  Group.new('purescriptConditional',      c.light_blue,   cno,  no)
  Group.new('purescriptDecl',             c.syntax_fg,    cno,  no)
  Group.new('purescriptDeclKeyword',      c.light_blue,   cno,  no)
  Group.new('purescriptDelimiter',        c.syntax_fg,    cno,  no)
  Group.new('purescriptDeriveKeyword',    c.blue,         cno,  no)
  Group.new('purescriptForall',           c.light_blue,   cno,  no)
  Group.new('purescriptForall',           c.syntax_fg,    cno,  no)
  Group.new('purescriptFunctionDecl',     c.syntax_fg,    cno,  no)
  Group.new('purescriptIdentifier',       c.syntax_fg,    cno,  no)
  Group.new('purescriptImport',           c.syntax_fg,    cno,  no)
  Group.new('purescriptKeyword',          c.light_blue,   cno,  no)
  Group.new('purescriptLet',              c.light_blue,   cno,  no)
  Group.new('purescriptLiquid',           c.mono_2,       cno,  no)
  Group.new('purescriptModule',           c.syntax_fg,    cno,  no)
  Group.new('purescriptOperators',        c.light_blue,   cno,  no)
  Group.new('purescriptPragma',           c.mono_2,       cno,  no)
  Group.new('purescriptQuotedtype',       c.syntax_fg,    cno,  no)
  Group.new('purescriptRecordIdentifier', c.syntax_fg,    cno,  no)
  Group.new('purescriptType',             c.yellow_warm,  cno,  no)
  Group.new('purescriptTypeAlias',        c.syntax_fg,    cno,  no)
  Group.new('purescriptTypeVar',          c.syntax_fg,    cno,  no)
  Group.new('purescriptWhere',            c.light_blue,   cno,  no)
end

function M.lang.html()
  Group.new('htmlArg',             c.dark_yellow,  cno,            no)
  Group.new('htmlTagName',         c.red,          cno,            no)
  Group.new('htmlTagN',            c.red,          cno,            no)
  Group.new('htmlSpecialTagName',  c.red,          cno,            no)
  Group.new('htmlTag',             c.mono_2,       cno,            no)
  Group.new('htmlEndTag',          c.mono_2,       cno,            no)
  Group.new('MatchTag',            c.red,          c.cursor_grey,  b )
end

function M.lang.javascript()
  Group.new('coffeeString',            c.green,         cno,  no)

  Group.new('javaScriptBraces',        c.mono_2,        cno,  no)
  Group.new('javaScriptFunction',      c.purple,        cno,  no)
  Group.new('javaScriptIdentifier',    c.purple,        cno,  no)
  Group.new('javaScriptNull',          c.dark_yellow,   cno,  no)
  Group.new('javaScriptNumber',        c.dark_yellow,   cno,  no)
  Group.new('javaScriptRequire',       c.cyan,          cno,  no)
  Group.new('javaScriptReserved',      c.purple,        cno,  no)
  --  https://github.com/pangloss/vim-javascript
  Group.new('jsArrowFunction',         c.purple,        cno,  no)
  Group.new('jsBraces',                c.mono_2,        cno,  no)
  Group.new('jsClassBraces',           c.mono_2,        cno,  no)
  Group.new('jsClassKeywords',         c.purple,        cno,  no)
  Group.new('jsDocParam',              c.light_blue,    cno,  no)
  Group.new('jsDocTags',               c.purple,        cno,  no)
  Group.new('jsFuncBraces',            c.mono_2,        cno,  no)
  Group.new('jsFuncCall',              c.light_blue,    cno,  no)
  Group.new('jsFuncParens',            c.mono_2,        cno,  no)
  Group.new('jsFunction',              c.purple,        cno,  no)
  Group.new('jsGenerator',             c.yellow,        cno,  no)
  Group.new('jsGlobalObjects',         c.yellow,        cno,  no)
  Group.new('jsModuleWords',           c.purple,        cno,  no)
  Group.new('jsModules',               c.purple,        cno,  no)
  Group.new('jsNoise',                 c.mono_2,        cno,  no)
  Group.new('jsNull',                  c.dark_yellow,   cno,  no)
  Group.new('jsOperator',              c.purple,        cno,  no)
  Group.new('jsParens',                c.mono_2,        cno,  no)
  Group.new('jsStorageClass',          c.purple,        cno,  no)
  Group.new('jsTemplateBraces',        c.dark_red,      cno,  no)
  Group.new('jsTemplateVar',           c.green,         cno,  no)
  Group.new('jsThis',                  c.red,           cno,  no)
  Group.new('jsUndefined',             c.dark_yellow,   cno,  no)
  Group.new('jsObjectValue',           c.light_blue,    cno,  no)
  Group.new('jsObjectKey',             c.cyan,          cno,  no)
  --  https://github.com/othree/yajs.vim
  Group.new('javascriptArrowFunc',     c.purple,        cno,  no)
  Group.new('javascriptClassExtends',  c.purple,        cno,  no)
  Group.new('javascriptClassKeyword',  c.purple,        cno,  no)
  Group.new('javascriptDocNotation',   c.purple,        cno,  no)
  Group.new('javascriptDocParamName',  c.light_blue,    cno,  no)
  Group.new('javascriptDocTags',       c.purple,        cno,  no)
  Group.new('javascriptEndColons',     c.comment_grey,  cno,  no)
  Group.new('javascriptExport',        c.purple,        cno,  no)
  Group.new('javascriptFuncArg',       c.white,         cno,  no)
  Group.new('javascriptFuncKeyword',   c.purple,        cno,  no)
  Group.new('javascriptIdentifier',    c.red,           cno,  no)
  Group.new('javascriptImport',        c.purple,        cno,  no)
  Group.new('javascriptObjectLabel',   c.white,         cno,  no)
  Group.new('javascriptOpSymbol',      c.cyan,          cno,  no)
  Group.new('javascriptOpSymbols',     c.cyan,          cno,  no)
  Group.new('javascriptPropertyName',  c.green,         cno,  no)
  Group.new('javascriptTemplateSB',    c.dark_red,      cno,  no)
  Group.new('javascriptVariable',      c.purple,        cno,  no)
end

function M.lang.json()
  Group.new('jsonCommentError',        c.white,        cno,  no)
  Group.new('jsonKeyword',             c.red,          cno,  no)
  Group.new('jsonQuote',               c.light_blue,   cno,  no)
  Group.new('jsonTrailingCommaError',  c.red,          cno,  r )
  Group.new('jsonMissingCommaError',   c.red,          cno,  r )
  Group.new('jsonNoQuotesError',       c.red,          cno,  r )
  Group.new('jsonNumError',            c.red,          cno,  r )
  Group.new('jsonString',              c.green,        cno,  no)
  Group.new('jsonBoolean',             c.purple,       cno,  no)
  Group.new('jsonNumber',              c.dark_yellow,  cno,  no)
  Group.new('jsonStringSQError',       c.red,          cno,  r )
  Group.new('jsonSemicolonError',      c.red,          cno,  r )
end

function M.lang.man()
  Group.new('manTitle',   g.String,        g.String,  g.String)
  Group.new('manFooter',  c.comment_grey,  cno,       no)
end

function M.lang.markdown()
  Group.new('markdownUrl',               c.purple,       cno,  no)
  Group.new('markdownBold',              c.dark_yellow,  cno,  b )
  Group.new('markdownItalic',            c.dark_yellow,  cno,  b )
  Group.new('markdownCode',              c.green,        cno,  no)
  Group.new('markdownCodeBlock',         c.red,          cno,  no)
  Group.new('markdownCodeDelimiter',     c.green,        cno,  no)
  Group.new('markdownHeadingDelimiter',  c.dark_red,     cno,  no)
  Group.new('markdownH1',                c.red,          cno,  no)
  Group.new('markdownH2',                c.red,          cno,  no)
  Group.new('markdownH3',                c.red,          cno,  no)
  Group.new('markdownH3',                c.red,          cno,  no)
  Group.new('markdownH4',                c.red,          cno,  no)
  Group.new('markdownH5',                c.red,          cno,  no)
  Group.new('markdownH6',                c.red,          cno,  no)
  Group.new('markdownListMarker',        c.red,          cno,  no)
  --  For mkd syntax (that mainly follows html)
  Group.new('htmlH1',                    c.dark_red,     cno,  b )
  Group.new('htmlH2',                    c.dark_red,     cno,  b )
  Group.new('htmlH3',                    c.dark_red,     cno,  b )
  Group.new('htmlH3',                    c.dark_red,     cno,  b )
  Group.new('htmlH4',                    c.dark_red,     cno,  b )
  Group.new('htmlH5',                    c.dark_red,     cno,  b )
  Group.new('htmlBold',                  c.dark_yellow,  cno,  b )
  Group.new('htmlItalic',                c.purple,       cno,  i )
  Group.new('mkdHeading',                c.dark_red,     cno,  b )
  Group.new('mkdURL',                    c.purple,       cno,  no)
  Group.new('mkdLink',                   c.blue,         cno,  no)
end

function M.lang.php()
  Group.new('phpClass',         c.yellow,        cno,  no)
  Group.new('phpFunction',      c.light_blue,    cno,  no)
  Group.new('phpFunctions',     c.light_blue,    cno,  no)
  Group.new('phpInclude',       c.purple,        cno,  no)
  Group.new('phpKeyword',       c.purple,        cno,  no)
  Group.new('phpParent',        c.comment_grey,  cno,  no)
  Group.new('phpType',          c.purple,        cno,  no)
  Group.new('phpSuperGlobals',  c.red,           cno,  no)
end

function M.lang.python()
  Group.new('pythonImport',           c.purple,       cno,  no)
  Group.new('pythonBuiltin',          c.cyan,         cno,  no)
  Group.new('pythonStatement',        c.purple,       cno,  no)
  Group.new('pythonParam',            c.dark_yellow,  cno,  no)
  Group.new('pythonEscape',           c.red,          cno,  no)
  Group.new('pythonSelf',             c.mono_2,       cno,  i )
  Group.new('pythonClass',            c.blue,         cno,  no)
  Group.new('pythonOperator',         c.purple,       cno,  no)
  Group.new('pythonEscape',           c.red,          cno,  no)
  Group.new('pythonFunction',         c.light_blue,   cno,  no)
  Group.new('pythonKeyword',          c.light_blue,   cno,  no)
  Group.new('pythonModule',           c.purple,       cno,  no)
  Group.new('pythonStringDelimiter',  c.green,        cno,  no)
  Group.new('pythonSymbol',           c.cyan,         cno,  no)
end

function M.lang.ruby()
  Group.new('rubyBlock',                      c.purple,      cno,  no)
  Group.new('rubyBlockParameter',             c.red,         cno,  no)
  Group.new('rubyBlockParameterList',         c.red,         cno,  no)
  Group.new('rubyCapitalizedMethod',          c.purple,      cno,  no)
  Group.new('rubyClass',                      c.purple,      cno,  no)
  Group.new('rubyConstant',                   c.yellow,      cno,  no)
  Group.new('rubyControl',                    c.purple,      cno,  no)
  Group.new('rubyDefine',                     c.purple,      cno,  no)
  Group.new('rubyEscape',                     c.red,         cno,  no)
  Group.new('rubyFunction',                   c.light_blue,  cno,  no)
  Group.new('rubyGlobalVariable',             c.red,         cno,  no)
  Group.new('rubyInclude',                    c.light_blue,  cno,  no)
  Group.new('rubyIncluderubyGlobalVariable',  c.red,         cno,  no)
  Group.new('rubyInstanceVariable',           c.red,         cno,  no)
  Group.new('rubyInterpolation',              c.cyan,        cno,  no)
  Group.new('rubyInterpolationDelimiter',     c.red,         cno,  no)
  Group.new('rubyKeyword',                    c.light_blue,  cno,  no)
  Group.new('rubyModule',                     c.purple,      cno,  no)
  Group.new('rubyPseudoVariable',             c.red,         cno,  no)
  Group.new('rubyRegexp',                     c.cyan,        cno,  no)
  Group.new('rubyRegexpDelimiter',            c.cyan,        cno,  no)
  Group.new('rubyStringDelimiter',            c.green,       cno,  no)
  Group.new('rubySymbol',                     c.cyan,        cno,  no)
end

function M.lang.rust()
  Group.new('rustExternCrate',           c.red,           cno,  b )
  Group.new('rustIdentifier',            c.light_blue,    cno,  no)
  Group.new('rustDeriveTrait',           c.green,         cno,  no)
  Group.new('SpecialComment',            c.comment_grey,  cno,  no)
  Group.new('rustCommentLine',           c.comment_grey,  cno,  no)
  Group.new('rustCommentLineDoc',        c.comment_grey,  cno,  no)
  Group.new('rustCommentLineDocError',   c.comment_grey,  cno,  no)
  Group.new('rustCommentBlock',          c.comment_grey,  cno,  no)
  Group.new('rustCommentBlockDoc',       c.comment_grey,  cno,  no)
  Group.new('rustCommentBlockDocError',  c.comment_grey,  cno,  no)
end

function M.lang.text()
  Group.new('txtURL',  c.blue,  cno,   no)
end

function M.lang.vim()
  Group.new('vimCommand',       c.purple,        cno,  no)
  Group.new('vimCommentTitle',  c.purple,        cno,  no)
  Group.new('vimFunction',      c.light_blue,    cno,  no)
  Group.new('vimFuncName',      c.blue,          cno,  no)
  Group.new('vimHighlight',     c.cyan,          cno,  no)
  Group.new('vimLineComment',   c.comment_grey,  cno,  i )
  Group.new('vimParenSep',      c.mono_2,        cno,  no)
  Group.new('vimSep',           c.mono_2,        cno,  no)
  Group.new('vimUserFunc',      c.light_blue,    cno,  no)
  Group.new('vimVar',           c.red,           cno,  no)
end

function M.lang.xml()
  Group.new('xmlAttrib',   c.yellow,  cno,  no)
  Group.new('xmlEndTag',   c.red,     cno,  no)
  Group.new('xmlTag',      c.red,     cno,  no)
  Group.new('xmlTagName',  c.red,     cno,  no)
end

function M.lang.zsh()
  Group.new('zshCommands',     c.syntax_fg,     cno,  no)
  Group.new('zshDeref',        c.red,           cno,  no)
  Group.new('zshShortDeref',   c.red,           cno,  no)
  Group.new('zshFunction',     c.cyan,          cno,  no)
  Group.new('zshKeyword',      c.purple,        cno,  no)
  Group.new('zshSubst',        c.red,           cno,  no)
  Group.new('zshSubstDelim',   c.comment_grey,  cno,  no)
  Group.new('zshTypes',        c.purple,        cno,  no)
  Group.new('zshVariableDef',  c.dark_yellow,   cno,  no)
end

function M.ftplugin.haskell()
  Group.new('TSInclude',             c.light_blue,    cno,  no)
  Group.new('TSKeyword',             c.blue,          cno,  no)
  Group.new('TSKeywordFunction',     c.light_blue,    cno,  no)
  Group.new('TSKeywordOperator',     c.light_blue,    cno,  no)
  Group.new('TSKeywordReturn',       c.purple,        cno,  no)
  Group.new('TSOperator',            c.blue,          cno,  no)
  Group.new('TSPunctDelimiter',      c.syntax_fg,     cno,  no)
  Group.new('TSTag',                 c.cyan,          cno,  no)
end

function M.hl_lang()
  M.lang.ansiidoc()
  -- M.lang.c_cpp()
  -- M.lang.css()
  M.lang.diff()
  -- M.lang.doxygen()
  M.lang.git()
  -- M.lang.go()
  M.lang.haskell()
  M.lang.purescript()
  -- M.lang.html()
  -- M.lang.javascript()
  M.lang.json()
  -- M.lang.man()
  M.lang.markdown()
  -- M.lang.php()
  -- M.lang.python()
  -- M.lang.ruby()
  M.lang.text()
  -- M.lang.vim()
  -- M.lang.xml()
  M.lang.zsh()
end

function M.hl_plugins()
  M.plugin.hl_plugins()
  M.plugin.hl_nvim_cmp()
  M.plugin.hl_lspsaga()
  M.plugin.hl_neo_tree_nvim()
end

function M.setup()
  M.init_theme()

  M.init_color()

  M.hl_general()
  M.hl_syntax()
  M.hl_neovim_terminal()
  M.hl_treesitter()
  -- M.hl_treesitter_onedarkishii()
  M.hl_lsp()
  M.hl_lang()
  M.hl_plugins()
end

return M
