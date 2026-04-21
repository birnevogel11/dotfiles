-- Name:         SunsetShiba
-- Description:  Dark Theme from onedarkish
--               The theme is original desgined by Pedro Ferrai
--               Please refer http://github.com/petobens/colorish to get more
--               details. The file convert it to lua format.
--               The color is adopted from onedarkish by sunsetshiba.
-- Author:       Pedro Ferrari (http://github.com/petobens/colorish)
--               sunsetshiba
--               bv11 <birnevogel11@gmail.com>
-- Maintainer:   bv11 <birnevogel11@gmail.com>
-- Website:      https://gitlab.com/birnevogel11/dotfiles/-/blob/master/nvim/lua/bv11/sunsetshiba.lua
-- License:      Vim License (see `:help license`)

local colorscheme_name = "sunsetshiba"

local nvim_set_hl = vim.api.nvim_set_hl
local tbl_deep_extend = vim.tbl_deep_extend

local c = {
  -- Comments refer to 256 terminal colors
  white = "#abb2bf",
  mono_2 = "#828997",
  comment_grey = "#777c84",
  hi_comment_grey = "#e6e6e6",
  mono_4 = "#4b5263",
  cyan = "#56b6c2",
  light_blue = "#6ba1f2",
  blue = "#4c81f1",
  -- light_blue      = '#68bbfe',
  -- blue            = '#528bff',
  purple = "#6972f3",
  bright_magenta = "#dc85f7",
  green = "#81ad61",
  red = "#ca8288",
  dark_red = "#be5046",

  dark_yellow = "#d19a66",
  yellow = "#dcc342",
  yellow_warm = "#c1ae4d",

  orange = "#d19a66",

  -- The original background and cursor colors are
  -- let s:black     = '282c34' " 235 (fake black)
  -- let s:cursor_grey = '2c323c' " 236
  -- We make the background a bit more dark
  fake_black = "#282c34",
  black = "#24272e",
  cursor_grey = "#2c323c",
  gutter_fg_grey = "#636d83",
  special_grey = "#3b4048",
  visual_grey = "#3e4452",
  column_gray = "#30353e",
  -- pmenu = '#333841',
  -- pmenu = "#3b4048",
  pmenu = "#30353e",
  bg = "#272b33",
}

local no = nil
local b = { bold = true }
local i = { italic = true }
local uc = { undercurl = true }
local ul = { underline = true }

--- Set the highlights
---@param group string
---@param fg string | nil
---@param bg string | nil
---@param extra_style table<string> | nil
local group = function(group, fg, bg, extra_style)
  local val = { fg = fg, bg = bg }
  if extra_style then
    val = tbl_deep_extend("force", val, extra_style)
  end

  nvim_set_hl(0, group, val)
end

local hl_general = function()
  -- Don't set normal bg color: See: https://github.com/neovim/neovim/issues/9019
  group("Normal",       c.syntax_fg,      no,             no)
  group("bold",         no,               no,             b)
  group("ColorColumn",  no,               c.column_gray,  no)
  group("Conceal",      c.mono_4,         c.blck,         no)
  group("Cursor",       no,               c.blue,         no)
  group("CursorIM",     no,               no,             no)
  group("CursorColumn", no,               c.cursor_grey,  no)
  group("CursorLine",   no,               c.cursor_grey,  no)
  group("QuickFixLine", c.syntax_fg,      no,             no)
  group("TermCursor",   c.blue,           no,             no)
  group("NormalFloat",  c.syntax_fg,      c.black,        no)
  group("Directory",    c.light_blue,     no,             no)
  group("ErrorMsg",     c.red,            c.black,        no)
  group("VertSplit",    c.gutter_fg_grey, no,             no)
  group("Folded",       c.comment_grey,   c.black,        no)
  group("FoldColumn",   c.comment_grey,   no,             no)
  group("IncSearch",    c.dark_yellow,    no,             no)
  group("LineNr",       c.mono_4,         no,             no)
  group("CursorLineNr", c.syntax_fg,      no,             no)
  group("MatchParen",   c.blue,           c.cursor_grey,  b)
  group("Italic",       no,               no,             i)
  group("ModeMsg",      c.dark_yellow,    no,             no)
  group("MoreMsg",      c.dark_yellow,    no,             no)
  group("NonText",      c.comment_grey,   no,             no)

  group("PMenu",        c.syntax_fg,      c.pmenu,        no)
  group("PMenuSel",     c.black,          c.light_blue,   no)
  group("PMenuSbar",    c.syntax_fg,      c.special_grey, no)
  group("PMenuThumb",   no,               c.white,        no)

  group("Question",     c.light_blue,     no,             no)
  group("Search",       c.black,          c.orange,       no)
  group("SpecialKey",   c.special_grey,   no,             no)
  group("Whitespace",   c.special_grey,   no,             no)
  group("StatusLine",   c.syntax_fg,      c.cursor_grey,  no)
  group("StatusLineNC", c.cursor_grey,    no,             no)

  group("TabLine",      c.white,          c.black,        no)
  group("TabLineFill",  c.comment_grey,   c.black,        no)
  group("TabLineSel",   c.white,          c.visual_grey,  no)

  group("Title",        c.syntax_fg,      no,             b)
  group("Visual",       no,               c.visual_grey,  no)
  group("VisualNOS",    no,               c.visual_grey,  no)
  group("WarningMsg",   c.dark_yellow,    no,             no)
  group("TooLong",      c.red,            no,             no)
  group("WildMenu",     c.black,          c.light_blue,   no)
  group("SignColumn",   no,               no,             no)
  group("Special",      c.light_blue,     no,             no)
end

local hl_syntax = function()
  -- Syntax highlighting
  -- group('Comment',           c.comment_grey,  no,      no)
  group("Comment",          c.mono_2,      no,      no)
  group("Constant",         c.green,       no,      no)
  group("String",           c.green,       no,      no)
  group("Character",        c.green,       no,      no)
  group("Number",           c.dark_yellow, no,      no)
  group("Boolean",          c.dark_yellow, no,      no)
  group("Float",            c.dark_yellow, no,      no)
  group("Identifier",       c.red,         no,      no)
  group("Function",         c.light_blue,  no,      no)
  group("Statement",        c.purple,      no,      no)
  group("Conditional",      c.purple,      no,      no)
  group("Repeat",           c.purple,      no,      no)
  group("Label",            c.purple,      no,      no)
  group("Operator",         c.blue,        no,      no)
  group("Keyword",          c.red,         no,      no)
  group("Exception",        c.purple,      no,      no)
  group("PreProc",          c.yellow,      no,      no)
  group("Include",          c.light_blue,  no,      no)
  group("Define",           c.purple,      no,      no)
  group("Macro",            c.purple,      no,      no)
  group("PreCondit",        c.yellow,      no,      no)
  group("Type",             c.yellow,      no,      no)
  group("StorageClass",     c.yellow,      no,      no)
  group("Structure",        c.yellow,      no,      no)
  group("Typedef",          c.yellow,      no,      no)
  group("Special",          c.light_blue,  no,      no)
  group("SpecialChar",      no,            no,      no)
  group("Tag",              no,            no,      no)
  group("Delimiter",        c.blue,        no,      no)
  group("SpecialComment",   no,            no,      no)
  group("Debug",            no,            no,      no)
  group("Underlined",       no,            no,      ul)
  group("Ignore",           no,            no,      no)
  group("Error",            c.red,         c.black, b)
  group("Todo",             c.red,         c.black, no)

  -- Spelling
  group("SpellBad",         no,            no,     uc)
  group("SpellLocal",       no,            no,     uc)
  group("SpellCap",         no,            no,     uc)
  group("SpellRare",        no,            no,     uc)

  -- Vim help
  group("helpCommand",      c.yellow,       no,     no)
  group("helpExample",      c.yellow,       no,     no)
  group("helpHeader",       c.white,        no,     b)
  group("helpSectionDelim", c.comment_grey, no,     no)
end

local hl_treesitter = function()
  group("@type",                          c.yellow_warm,  no,            no)
  group("@variable",                      c.syntax_fg,    no,            no)
  group("@variable.member",               c.syntax_fg,    no,            no)
  group("@variable.builtin",              c.dark_yellow,  no,            no)
  group("@variable.parameter",            c.syntax_fg,    no,            no)
  group("@field",                         c.syntax_fg,    no,            no)
  group("@property",                      c.syntax_fg,    no,            no)
  group("@parameter",                     c.syntax_fg,    no,            no)
  group("@punctuation.delimiter",         c.blue,         no,            no)
  group("@constant.builtin",              c.green,        no,            no)
  group("@operator",                      c.blue,         no,            no)
  group("@keyword",                       c.light_blue,   no,            no)
  group("@keyword.return",                c.light_blue,   no,            no)
  group("@keyword.function",              c.light_blue,   no,            no)
  group("@constructor",                   c.syntax_fg,    no,            no)
  group("@include",                       c.light_blue,   no,            no)
  group("@repeat",                        c.light_blue,   no,            no)
  group("@conditional",                   c.light_blue,   no,            no)
  group("@function",                      c.syntax_fg,    no,            no)
  group("@method",                        c.syntax_fg,    no,            no)
  group("@function.builtin",              c.blue,         no,            no)
  group("@preproc",                       c.orange,       no,            no)

  -- Haskell
  group("@keyword.operator.haskell",      c.light_blue,   no,            no)
  group("@keyword.return.haskell",        c.light_blue,   no,            no)
  group("@punctuation.delimiter.haskell", c.syntax_fg,    no,            no)
  group("@tag.haskell",                   c.cyan,         no,            no)
  group("@namespace.haskell",             c.syntax_fg,    no,            no)
  group("@type.haskell",                  c.syntax_fg,    no,            no)

  -- Markdown
  group("@text.literal.markdown",         c.syntax_fg,    no,            no)
  group("@markup.raw.block.markdown",     c.syntax_fg,    no,            no)

  -- Rust
  group("@namespace.rust",                c.syntax_fg,    no,            no)

  -- Python
  group("@string.documentation.python",   c.mono_2,       no,            no)
  group("@attribute.python",              c.syntax_fg,    no,            no)
  group("@attribute.builtin.python",      c.blue,         no,            no)
  group("@type.builtin.python",           c.yellow_warm,  no,            no)
  group("@module.python",                 c.syntax_fg,    no,            no)
  group("@keyword.directive.python",      c.comment_grey, no,            no)
  group("@lsp.type.namespace.python",     c.syntax_fg,    no,            no)

  -- Bitbake
  group("@constant.bitbake",              c.syntax_fg,    no,            no)


  -- HTML
  group("@tag.html",                      c.red,          no,            no)

  -- Vue
  group("@tag.delimiter.vue",             c.purple,       no,            no)
  group("@tag.vue",                       c.red,          no,            no)

  -- Yaml
  group("@property.yaml",                 c.red,          no,            no)
  group("@string.yaml",                   c.syntax_fg,    no,            no)

end

local hl_lsp = function()
  group("LspCodeLens",                    c.mono_2,       no,            no)
  group("LspInlayHint",                   c.comment_grey, no,            no)
  group("DiagnosticError",                c.dark_red,     no,            no)
  group("DiagnosticHint",                 c.mono_2,       no,            no)
  group("DiagnosticInfo",                 c.mono_2,       no,            no)
  group("DiagnosticWarn",                 c.dark_yellow,  no,            no)
  group("DiagnosticDefaultError",         c.dark_red,     no,            no)
  group("DiagnosticDefaultHint",          c.mono_2,       no,            no)
  group("DiagnosticDefaultInfo",          c.mono_2,       no,            no)
  group("DiagnosticDefaultWarn",          c.dark_yellow,  no,            no)
  group("DiagnosticUnderlineError",       c.dark_red,     no,            ul)
  group("DiagnosticUnderlineHint",        c.syntax_fg,    no,            ul)
  group("DiagnosticUnderlineInfo",        c.syntax_fg,    no,            ul)
  group("DiagnosticUnderlineWarn",        c.dark_yellow,  no,            ul)
  group("DiagnosticVirtualTextError",     c.dark_red,     no,            no)
  group("DiagnosticVirtualTextHint",      c.mono_2,       no,            no)
  group("DiagnosticVirtualTextInfo",      c.mono_2,       no,            no)
  group("DiagnosticVirtualTextWarn",      c.yellow,       no,            no)
  group("DiagnosticSignError",            c.dark_red,     no,            no)
  group("DiagnosticSignWarn",             c.dark_yellow,  no,            no)
  group("DiagnosticSignInfo",             c.mono_2,       no,            no)
  group("DiagnosticSignHint",             c.mono_2,       no,            no)
  group("DiagnosticFloatingError",        c.dark_red,     no,            no)
  group("DiagnosticFloatingWarn",         c.dark_yellow,  no,            no)
  group("DiagnosticFloatingInfo",         c.mono_2,       no,            no)
  group("DiagnosticFloatingHint",         c.mono_2,       no,            no)
end

local hl_plugin_general = function()
  -- Denite
  group("deniteSource_grepFile",          c.light_blue,   no,            no)

  -- Defx
  group("Defx_filename_3_marker",         c.light_blue,   no,            no)
  group("Defx_git_6_Modified",            c.red,          no,            no)
  group("Defx_git_6_Staged",              c.green,        no,            no)
  group("Defx_mark_0_readonly",           c.dark_red,     no,            no)

  -- Fugitive
  group("diffAdded",                      c.green,        no,            no)
  group("diffRemoved",                    c.red,          no,            no)
  group("fugitiveUnstagedHeading",        c.red,          no,            no)
  group("fugitiveUnstagedModifier",       c.red,          no,            no)
  group("fugitiveStagedHeading",          c.green,        no,            no)
  group("fugitiveStagedModifier",         c.green,        no,            no)

  -- Git gutter
  group("GitGutterAdd",                   c.green,        no,            no)
  group("GitGutterChange",                c.yellow,       no,            no)
  group("GitGutterDelete",                c.red,          no,            no)

  -- GitMessenger
  group("gitmessengerHeader",             c.purple,       no,            no)
  group("gitmessengerHash",               c.yellow,       no,            no)
  group("gitmessengerPopupNormal",        no,             c.cursor_grey, no)

  -- HighlightedYank
  group("HighlightedyankRegion",          c.black,        c.dark_yellow, no)

  -- Interesting words (from Steve Losh's vimrc)
  group("InterestingWord1",               c.black,        c.yellow,      no)
  group("InterestingWord2",               c.black,        c.green,       no)
  group("InterestingWord3",               c.black,        c.purple,      no)
  group("InterestingWord4",               c.black,        c.dark_yellow, no)
  group("InterestingWord5",               c.black,        c.light_blue,  no)
  group("InterestingWord6",               c.black,        c.white,       no)

  -- Neomake
  group("NeomakeVirtualtextError",        c.red,          c.cursor_grey, no)
  group("NeomakeVirtualtextWarning",      c.dark_yellow,  c.cursor_grey, no)
  group("NeomakeVirtualtextInfo",         c.red,          c.cursor_grey, no)
  group("NeomakeVirtualtextMessage",      c.red,          c.cursor_grey, no)

  -- Sneak
  group("Sneak",                          c.black,        c.purple,      no)

  -- Tagbar
  group("TagbarKind",                     c.yellow,       no,            no)
  group("TagbarScope",                    c.yellow,       no,            no)
  group("TagbarNestedKind",               c.light_blue,   no,            no)
  group("TagbarSignature",                c.comment_grey, no,            no)
  group("TagbarType",                     c.light_blue,   no,            no)
  group("TagbarVisibilityPrivate",        c.dark_red,     no,            no)
  group("TagbarVisibilityProtected",      c.dark_red,     no,            no)
  group("TagbarVisibilityPublic",         c.green,        no,            no)
  group("TagbarFoldIcon",                 c.light_blue,   no,            no)

  --  Diff-git-sign
  group("DiffGitAdd",                     c.green,        no,            no)
  group("DiffGitChange",                  c.dark_yellow,  no,            no)
  group("DiffGitDelete",                  c.red,          no,            no)
  group("DiffGitText",                    c.light_blue,   no,            no)
  group("DiffGitAdded",                   c.green,        no,            no)
  group("DiffGitFile",                    c.red,          no,            no)
  group("DiffGitNewFile",                 c.green,        no,            no)
  group("DiffGitLine",                    c.light_blue,   no,            no)
  group("DiffGitRemoved",                 c.red,          no,            no)

  -- IndentBlanklineChar
  group("IndentBlanklineChar",            c.special_grey, no,            no)

  -- SnacksIndent
  group("SnacksIndent",                   c.special_grey, no,            no)
end

local hl_plugin_neo_tree_nvim = function()
  group("NeoTreeDirectoryIcon", c.blue,        no,           no)
  group("NeoTreeFileIcon",      c.green,       no,           no)
  group("NeoTreeGitModified",   c.yellow,      no,           no)
  group("NeoTreeGitUntracked",  c.dark_yellow, no,           no)
end

local hl_lang_ansiidoc = function()
  group("asciidocListingBlock", c.mono_2,      no,           no)
end

local hl_lang_diff = function()
  group("DiffAdd",              c.green,       c.visual_grey, no)
  group("DiffChange",           c.dark_yellow, c.visual_grey, no)
  group("DiffDelete",           c.red,         c.visual_grey, no)
  group("DiffText",             c.light_blue,  c.visual_grey, no)
  group("DiffAdded",            c.green,       c.visual_grey, no)
  group("DiffFile",             c.red,         c.visual_grey, no)
  group("DiffNewFile",          c.green,       c.visual_grey, no)
  group("DiffLine",             c.light_blue,  c.visual_grey, no)
  group("DiffRemoved",          c.red,         c.visual_grey, no)
end

local hl_lang_json = function()
  group("jsonCommentError", c.white,       no, no)
  group("jsonKeyword",      c.red,         no, no)
  group("jsonQuote",        c.light_blue,  no, no)
  -- group('jsonTrailingCommaError',  c.red,          no,  r )
  -- group('jsonMissingCommaError',   c.red,          no,  r )
  -- group('jsonNoQuotesError',       c.red,          no,  r )
  -- group('jsonNumError',            c.red,          no,  r )
  group("jsonString",       c.green,       no, no)
  group("jsonBoolean",      c.purple,      no, no)
  group("jsonNumber",       c.dark_yellow, no, no)
  -- group('jsonStringSQError',       c.red,          no,  r )
  -- group('jsonSemicolonError',      c.red,          no,  r )
end

local hl_lang_purescript = function()
  group("purescriptAssocType",        c.syntax_fg,   no, no)
  group("purescriptConditional",      c.light_blue,  no, no)
  group("purescriptDecl",             c.syntax_fg,   no, no)
  group("purescriptDeclKeyword",      c.light_blue,  no, no)
  group("purescriptDelimiter",        c.syntax_fg,   no, no)
  group("purescriptDeriveKeyword",    c.blue,        no, no)
  group("purescriptForall",           c.light_blue,  no, no)
  group("purescriptForall",           c.syntax_fg,   no, no)
  group("purescriptFunctionDecl",     c.syntax_fg,   no, no)
  group("purescriptIdentifier",       c.syntax_fg,   no, no)
  group("purescriptImport",           c.syntax_fg,   no, no)
  group("purescriptKeyword",          c.light_blue,  no, no)
  group("purescriptLet",              c.light_blue,  no, no)
  group("purescriptLiquid",           c.mono_2,      no, no)
  group("purescriptModule",           c.syntax_fg,   no, no)
  group("purescriptOperators",        c.light_blue,  no, no)
  group("purescriptPragma",           c.mono_2,      no, no)
  group("purescriptQuotedtype",       c.syntax_fg,   no, no)
  group("purescriptRecordIdentifier", c.syntax_fg,   no, no)
  group("purescriptType",             c.yellow_warm, no, no)
  group("purescriptTypeAlias",        c.syntax_fg,   no, no)
  group("purescriptTypeVar",          c.syntax_fg,   no, no)
  group("purescriptWhere",            c.light_blue,  no, no)
end

local hl_lang_zsh = function()
  group("zshCommands",    c.syntax_fg,    no, no)
  group("zshDeref",       c.red,          no, no)
  group("zshShortDeref",  c.red,          no, no)
  group("zshFunction",    c.cyan,         no, no)
  group("zshKeyword",     c.purple,       no, no)
  group("zshSubst",       c.red,          no, no)
  group("zshSubstDelim",  c.comment_grey, no, no)
  group("zshTypes",       c.purple,       no, no)
  group("zshVariableDef", c.dark_yellow,  no, no)
end

local hl_lang = function()
  hl_lang_ansiidoc()
  hl_lang_diff()
  hl_lang_json()
  hl_lang_purescript()
  hl_lang_zsh()
end

local hl_plugin_dressing = function()
  group("FloatTitle",         c.comment_grey, no, no)
  group("FloatBorder",        c.comment_grey, no, no)
end

local hl_plugin_fidget = function()
  group("FidgetTitle",        c.purple,       no, no)
  group("FidgetTask",         c.syntax_fg,    no, no)
end

local hl_plugin_virt_column = function()
  group("VirtColumn",         c.column_gray,  c.no, no)
end

local hl_plugin_render_markdown = function()
  group("RenderMarkdownCode", no,            c.column_gray, no)
end

local hl_plugins = function()
  hl_plugin_general()
  hl_plugin_neo_tree_nvim()
  hl_plugin_dressing()
  hl_plugin_fidget()
  hl_plugin_virt_column()
  hl_plugin_render_markdown()
end

vim.opt.background = "dark"
vim.api.nvim_set_var("color_name",colorscheme_name)

hl_general()
hl_syntax()
hl_treesitter()
hl_lsp()
hl_lang()
hl_plugins()
