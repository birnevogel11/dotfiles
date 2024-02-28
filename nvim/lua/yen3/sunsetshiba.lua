-- Name:         SunsetShiba
-- Description:  Dark Theme from onedarkish
--               The theme is original desgined by Pedro Ferrai
--               Please refer http://github.com/petobens/colorish to get more
--               details. The file convert it to lua format.
--               The color is adopted from onedarkish by sunsetshiba.
-- Author:       Pedro Ferrari (http://github.com/petobens/colorish)
--               sunsetshiba
--               yen3 <yen3rc@gmail.com>
-- Maintainer:   yen3 <yen3rc@gmail.com>
-- Website:      https://gitlab.com/yen3/dotfiles/-/blob/master/nvim/lua/yen3/sunsetshiba.lua
-- License:      Vim License (see `:help license`)

local nvim_set_hl = vim.api.nvim_set_hl
local tbl_deep_extend = vim.tbl_deep_extend

local M = {
  colorscheme_name = "sunsetshiba",
}

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

local cno = "none"
local no = {}
local b = { bold = true }
local i = { italic = true }
local uc = { undercurl = true }
local ul = { underline = true }

local group = function(group, fg, bg, extra_style)
  local val = { fg = fg or "none", bg = bg or "none", sp = "none" }
  if extra_style then
    val = tbl_deep_extend("force", val, extra_style)
  end

  nvim_set_hl(0, group, val)
end

local hl_general = function()
  -- Don't set normal bg color: See: https://github.com/neovim/neovim/issues/9019
  group("Normal", c.syntax_fg, cno, no)
  group("bold", cno, cno, b)
  group("ColorColumn", cno, c.column_gray, no)
  group("Conceal", c.mono_4, c.blck, no)
  group("Cursor", cno, c.blue, no)
  group("CursorIM", cno, cno, no)
  group("CursorColumn", cno, c.cursor_grey, no)
  group("CursorLine", cno, c.cursor_grey, no)
  group("QuickFixLine", c.syntax_fg, cno, no)
  group("TermCursor", c.blue, cno, no)
  group("NormalFloat", c.syntax_fg, c.black, no)
  group("Directory", c.light_blue, cno, no)
  group("ErrorMsg", c.red, c.black, no)
  group("VertSplit", c.gutter_fg_grey, cno, no)
  group("Folded", c.comment_grey, c.black, no)
  group("FoldColumn", c.comment_grey, cno, no)
  group("IncSearch", c.dark_yellow, cno, no)
  group("LineNr", c.mono_4, cno, no)
  group("CursorLineNr", c.syntax_fg, cno, no)
  group("MatchParen", c.blue, c.cursor_grey, b)
  group("Italic", cno, cno, i)
  group("ModeMsg", c.dark_yellow, cno, no)
  group("MoreMsg", c.dark_yellow, cno, no)
  group("NonText", c.comment_grey, cno, no)

  group("PMenu", c.syntax_fg, c.pmenu, no)
  group("PMenuSel", c.black, c.light_blue, no)
  group("PMenuSbar", c.syntax_fg, c.special_grey, no)
  group("PMenuThumb", cno, c.white, no)

  group("Question", c.light_blue, cno, no)
  group("Search", c.black, c.orange, no)
  group("SpecialKey", c.special_grey, cno, no)
  group("Whitespace", c.special_grey, cno, no)
  group("StatusLine", c.syntax_fg, c.cursor_grey, no)
  group("StatusLineNC", c.cursor_grey, cno, no)

  group("TabLine", c.white, c.black, no)
  group("TabLineFill", c.comment_grey, c.black, no)
  group("TabLineSel", c.white, c.visual_grey, no)

  group("Title", c.syntax_fg, cno, b)
  group("Visual", cno, c.visual_grey, no)
  group("VisualNOS", cno, c.visual_grey, no)
  group("WarningMsg", c.dark_yellow, cno, no)
  group("TooLong", c.red, cno, no)
  group("WildMenu", c.black, c.light_blue, no)
  group("SignColumn", cno, cno, no)
  group("Special", c.light_blue, cno, no)
end

local hl_syntax = function()
  -- Syntax highlighting
  -- group('Comment',           c.comment_grey,  cno,      no)
  group("Comment", c.mono_2, cno, no)
  group("Constant", c.green, cno, no)
  group("String", c.green, cno, no)
  group("Character", c.green, cno, no)
  group("Number", c.dark_yellow, cno, no)
  group("Boolean", c.dark_yellow, cno, no)
  group("Float", c.dark_yellow, cno, no)
  group("Identifier", c.red, cno, no)
  group("Function", c.light_blue, cno, no)
  group("Statement", c.purple, cno, no)
  group("Conditional", c.purple, cno, no)
  group("Repeat", c.purple, cno, no)
  group("Label", c.purple, cno, no)
  group("Operator", c.blue, cno, no)
  group("Keyword", c.red, cno, no)
  group("Exception", c.purple, cno, no)
  group("PreProc", c.yellow, cno, no)
  group("Include", c.light_blue, cno, no)
  group("Define", c.purple, cno, no)
  group("Macro", c.purple, cno, no)
  group("PreCondit", c.yellow, cno, no)
  group("Type", c.yellow, cno, no)
  group("StorageClass", c.yellow, cno, no)
  group("Structure", c.yellow, cno, no)
  group("Typedef", c.yellow, cno, no)
  group("Special", c.light_blue, cno, no)
  group("SpecialChar", cno, cno, no)
  group("Tag", cno, cno, no)
  group("Delimiter", c.blue, cno, no)
  group("SpecialComment", cno, cno, no)
  group("Debug", cno, cno, no)
  group("Underlined", cno, cno, ul)
  group("Ignore", cno, cno, no)
  group("Error", c.red, c.black, b)
  group("Todo", c.red, c.black, no)

  -- Spelling
  group("SpellBad", cno, cno, uc)
  group("SpellLocal", cno, cno, uc)
  group("SpellCap", cno, cno, uc)
  group("SpellRare", cno, cno, uc)

  -- Vim help
  group("helpCommand", c.yellow, cno, no)
  group("helpExample", c.yellow, cno, no)
  group("helpHeader", c.white, cno, b)
  group("helpSectionDelim", c.comment_grey, cno, no)
end

local hl_treesitter = function()
  group("@type", c.yellow_warm, cno, no)
  group("@variable", c.syntax_fg, cno, no)
  group("@variable.member", c.syntax_fg, cno, no)
  group("@variable.builtin", c.dark_yellow, cno, no)
  group("@variable.parameter", c.syntax_fg, cno, no)
  group("@field", c.syntax_fg, cno, no)
  group("@property", c.syntax_fg, cno, no)
  group("@parameter", c.syntax_fg, cno, no)
  group("@punctuation.delimiter", c.blue, cno, no)
  group("@constant.builtin", c.green, cno, no)
  group("@operator", c.blue, cno, no)
  group("@keyword", c.light_blue, cno, no)
  group("@keyword.return", c.light_blue, cno, no)
  group("@keyword.function", c.light_blue, cno, no)
  group("@constructor", c.syntax_fg, cno, no)
  group("@include", c.light_blue, cno, no)
  group("@repeat", c.light_blue, cno, no)
  group("@conditional", c.light_blue, cno, no)
  group("@function", c.syntax_fg, cno, no)
  group("@method", c.syntax_fg, cno, no)
  group("@function.builtin", c.blue, cno, no)
  group("@preproc", c.orange, cno, no)

  -- Haskell
  group("@keyword.operator.haskell", c.light_blue, cno, no)
  group("@keyword.return.haskell", c.light_blue, cno, no)
  group("@punctuation.delimiter.haskell", c.syntax_fg, cno, no)
  group("@tag.haskell", c.cyan, cno, no)
  group("@namespace.haskell", c.syntax_fg, cno, no)
  group("@type.haskell", c.syntax_fg, cno, no)

  -- Markdown
  group("@text.literal.markdown", c.syntax_fg, cno, no)

  -- Rust
  group("@namespace.rust", c.syntax_fg, cno, no)

  -- Python
  group("@string.documentation.python", c.mono_2, cno, no)
  group("@attribute.python", c.syntax_fg, cno, no)
  group("@attribute.builtin.python", c.blue, cno, no)
  group("@type.builtin.python", c.yellow_warm, cno, no)
end

-- local hl_treesitter_onedarkishii = function()
--   group('TSAnnotation',          c.red,           cno,  no)
--   group('TSAttribute',           c.syntax_fg,     cno,  no)
--   group('TSBoolean',             c.dark_yellow,   cno,  no)
--   group('TSCharacter',           c.green,         cno,  no)
--   group('TSComment',             c.comment_grey,  cno,  no)
--   group('TSConditional',         c.purple,        cno,  no)
--   group('TSConstructor',         c.dark_yellow,   cno,  no)
--   group('TSConstant',            c.green,         cno,  no)
--   group('TSConstBuiltin',        c.green,         cno,  no)
--   group('TSConstMacro',          c.green,         cno,  no)
--   group('TSError',               c.red,           cno,  no)
--   group('TSException',           c.dark_yellow,   cno,  no)
--   group('TSField',               c.syntax_fg,     cno,  no)
--   group('TSFloat',               c.dark_yellow,   cno,  no)
--   group('TSFunction',            c.light_blue,    cno,  no)
--   group('TSFuncBuiltin',         c.dark_yellow,   cno,  no)
--   group('TSFuncMacro',           c.syntax_fg,     cno,  no)
--   group('TSInclude',             c.purple,        cno,  no)
--   group('TSKeyword',             c.purple,        cno,  no)
--   group('TSKeywordFunction',     c.purple,        cno,  no)
--   group('TSKeywordOperator',     c.light_blue,    cno,  no)
--   group('TSKeywordReturn',       c.purple,        cno,  no)
--   group('TSLabel',               c.blue,          cno,  no)
--   group('TSMethod',              c.light_blue,    cno,  no)
--   -- group('TSNamespace',           cno,             cno,  no)
--   group('TSNone',                c.green,         cno,  no)
--   group('TSNumber',              c.dark_yellow,   cno,  no)
--   group('TSOperator',            c.purple,        cno,  no)
--   group('TSParameter',           c.syntax_fg,     cno,  no)
--   -- group('TSParameterReference',  c.syntax_fg,     cno,  no)
--   group('TSProperty',            c.syntax_fg,     cno,  no)
--   group('TSPunctDelimiter',      c.syntax_fg,     cno,  no)
--   group('TSPunctBracket',        c.syntax_fg,     cno,  no)
--   group('TSPunctSpecial',        c.syntax_fg,     cno,  no)
--   group('TSRepeat',              c.purple,        cno,  no)
--   group('TSString',              c.green,         cno,  no)
--   group('TSStringRegex',         c.cyan,          cno,  no)
--   group('TSStringEscape',        c.cyan,          cno,  no)
--   group('TSTag',                 c.red,           cno,  no)
--   group('TSTagDelimiter',        c.mono_2,        cno,  no)
--   -- group('TSText',                cno,             cno,  no)
--   -- group('TSEmphasis',            cno,             cno,  no)
--   -- group('TSStrike',              cno,             cno,  no)
--   -- group('TSUnderline',           cno,             cno,  no)
--   -- group('TStrong',               cno,             cno,  no)
--   group('TSTitle',               c.green,         cno,  no)
--   -- group('TSLiteral',             cno,             cno,  no)
--   -- group('TSURI',                 cno,             cno,  no)
--   -- group('TSMath',                cno,             cno,  no)
--   -- group('TSTextReference',       cno,             cno,  no)
--   -- group('TSEnvironmentName',     cno,             cno,  no)
--   -- group('TSNote',                cno,             cno,  no)
--   -- group('TSDanger',              cno,             cno,  no)
--   group('TSType',                c.yellow,        cno,  no)
--   group('TSTypeBuiltin',         c.yellow,        cno,  no)
--   group('TSVariable',            c.syntax_fg,     cno,  no)
--   group('TSVariableBuiltin',     c.red,           cno,  i )
-- end

local hl_lsp = function()
  group("LspCodeLens", c.mono_2, cno, no)
  group("LspInlayHint", c.comment_grey, cno, no)
  group("DiagnosticError", c.dark_red, cno, no)
  group("DiagnosticHint", c.mono_2, cno, no)
  group("DiagnosticInfo", c.mono_2, cno, no)
  group("DiagnosticWarn", c.dark_yellow, cno, no)
  group("DiagnosticDefaultError", c.dark_red, cno, no)
  group("DiagnosticDefaultHint", c.mono_2, cno, no)
  group("DiagnosticDefaultInfo", c.mono_2, cno, no)
  group("DiagnosticDefaultWarn", c.dark_yellow, cno, no)
  group("DiagnosticUnderlineError", c.dark_red, cno, ul)
  group("DiagnosticUnderlineHint", c.syntax_fg, cno, ul)
  group("DiagnosticUnderlineInfo", c.syntax_fg, cno, ul)
  group("DiagnosticUnderlineWarn", c.dark_yellow, cno, ul)
  group("DiagnosticVirtualTextError", c.dark_red, cno, no)
  group("DiagnosticVirtualTextHint", c.mono_2, cno, no)
  group("DiagnosticVirtualTextInfo", c.mono_2, cno, no)
  group("DiagnosticVirtualTextWarn", c.yellow, cno, no)
  group("DiagnosticSignError", c.dark_red, cno, no)
  group("DiagnosticSignWarn", c.dark_yellow, cno, no)
  group("DiagnosticSignInfo", c.mono_2, cno, no)
  group("DiagnosticSignHint", c.mono_2, cno, no)
  group("DiagnosticFloatingError", c.dark_red, cno, no)
  group("DiagnosticFloatingWarn", c.dark_yellow, cno, no)
  group("DiagnosticFloatingInfo", c.mono_2, cno, no)
  group("DiagnosticFloatingHint", c.mono_2, cno, no)
end

local hl_plugin_general = function()
  -- Denite
  group("deniteSource_grepFile", c.light_blue, cno, no)

  -- Defx
  group("Defx_filename_3_marker", c.light_blue, cno, no)
  group("Defx_git_6_Modified", c.red, cno, no)
  group("Defx_git_6_Staged", c.green, cno, no)
  group("Defx_mark_0_readonly", c.dark_red, cno, no)

  -- Fugitive
  group("diffAdded", c.green, cno, no)
  group("diffRemoved", c.red, cno, no)
  group("fugitiveUnstagedHeading", c.red, cno, no)
  group("fugitiveUnstagedModifier", c.red, cno, no)
  group("fugitiveStagedHeading", c.green, cno, no)
  group("fugitiveStagedModifier", c.green, cno, no)

  -- Git gutter
  group("GitGutterAdd", c.green, cno, no)
  group("GitGutterChange", c.yellow, cno, no)
  group("GitGutterDelete", c.red, cno, no)

  -- GitMessenger
  group("gitmessengerHeader", c.purple, cno, no)
  group("gitmessengerHash", c.yellow, cno, no)
  group("gitmessengerPopupNormal", cno, c.cursor_grey, no)

  -- HighlightedYank
  group("HighlightedyankRegion", c.black, c.dark_yellow, no)

  -- Interesting words (from Steve Losh's vimrc)
  group("InterestingWord1", c.black, c.yellow, no)
  group("InterestingWord2", c.black, c.green, no)
  group("InterestingWord3", c.black, c.purple, no)
  group("InterestingWord4", c.black, c.dark_yellow, no)
  group("InterestingWord5", c.black, c.light_blue, no)
  group("InterestingWord6", c.black, c.white, no)

  -- Neomake
  group("NeomakeVirtualtextError", c.red, c.cursor_grey, no)
  group("NeomakeVirtualtextWarning", c.dark_yellow, c.cursor_grey, no)
  group("NeomakeVirtualtextInfo", c.red, c.cursor_grey, no)
  group("NeomakeVirtualtextMessage", c.red, c.cursor_grey, no)

  -- Sneak
  group("Sneak", c.black, c.purple, no)

  -- Tagbar
  group("TagbarKind", c.yellow, cno, no)
  group("TagbarScope", c.yellow, cno, no)
  group("TagbarNestedKind", c.light_blue, cno, no)
  group("TagbarSignature", c.comment_grey, cno, no)
  group("TagbarType", c.light_blue, cno, no)
  group("TagbarVisibilityPrivate", c.dark_red, cno, no)
  group("TagbarVisibilityProtected", c.dark_red, cno, no)
  group("TagbarVisibilityPublic", c.green, cno, no)
  group("TagbarFoldIcon", c.light_blue, cno, no)

  --  Diff-git-sign
  group("DiffGitAdd", c.green, cno, no)
  group("DiffGitChange", c.dark_yellow, cno, no)
  group("DiffGitDelete", c.red, cno, no)
  group("DiffGitText", c.light_blue, cno, no)
  group("DiffGitAdded", c.green, cno, no)
  group("DiffGitFile", c.red, cno, no)
  group("DiffGitNewFile", c.green, cno, no)
  group("DiffGitLine", c.light_blue, cno, no)
  group("DiffGitRemoved", c.red, cno, no)

  -- IndentBlanklineChar
  group("IndentBlanklineChar", c.special_grey, cno, no)
end

-- local hl_plugin_lspsaga = function()
--   group('LspSagaCodeActionTitle',         c.comment_grey, cno,   no)
--   group('LspSagaCodeActionTruncateLine',  c.comment_grey, cno,   no)
--   group('LspSagaCodeActionContent',       c.syntax_fg,    cno,   no)
--   group('LspSagaRenamePromptPrefix',      c.comment_grey, cno,   no)
--   group('LspSagaRenameBorder',            c.comment_grey, cno,   no)
--   group('LspSagaCodeActionBorder',        c.comment_grey, cno,   no)
--   group('LspSagaDefPreviewBorder',        c.comment_grey, cno,   no)
--   group('LspSagaDiagnosticBorder',        c.comment_grey, cno,   no)
--   group('LspSagaDiagnosticHeader',        c.comment_grey, cno,   no)
--   group('LspSagaDiagnosticTruncateLine',  c.comment_grey, cno,   no)
--   group('LspDiagnosticsFloatingError',    c.dark_red,     cno,   no)
--   group('LspDiagnosticsFloatingWarn',     c.dark_yellow,  cno,   no)
--   group('LspDiagnosticsFloatingInfor',    c.syntax_fg,    cno,   no)
--   group('LspDiagnosticsFloatingHint',     c.syntax_fg,    cno,   no)
-- end

local hl_plugin_nvim_cmp = function()
  -- https://github.com/hrsh7th/nvim-cmp#highlights
  -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/lsp.lua#L108
  -- https://github.com/olimorris/onedarkpro.nvim/blob/main/lua/onedarkpro/theme.lua
  group("CmpDocumentation", c.syntax_fg, cno, no)
  group("CmpDocumentationBorder", c.syntax_fg, cno, no)

  group("CmpItemAbbr", c.syntax_fg, cno, no)
  group("CmpItemAbbrMatch", c.syntax_fg, cno, no)
  group("CmpItemAbbrMatchFuzzy", c.syntax_fg, cno, no)
  group("CmpItemMenu", c.syntax_fg, cno, no)

  group("CmpItemKindText", c.mono_2, cno, no)
  group("CmpItemKindMethod", c.mono_2, cno, no)
  group("CmpItemKindFunction", c.mono_2, cno, no)
  group("CmpItemKindConstructor", c.mono_2, cno, no)
  group("CmpItemKindField", c.mono_2, cno, no)
  group("CmpItemKindVariable", c.mono_2, cno, no)
  group("CmpItemKindClass", c.mono_2, cno, no)
  group("CmpItemKindInterface", c.mono_2, cno, no)
  group("CmpItemKindModule", c.mono_2, cno, no)
  group("CmpItemKindProperty", c.mono_2, cno, no)
  group("CmpItemKindUnit", c.mono_2, cno, no)
  group("CmpItemKindValue", c.mono_2, cno, no)
  group("CmpItemKindEnum", c.mono_2, cno, no)
  group("CmpItemKindKeyword", c.mono_2, cno, no)
  group("CmpItemKindSnippet", c.mono_2, cno, no)
  group("CmpItemKindColor", c.mono_2, cno, no)
  group("CmpItemKindFile", c.mono_2, cno, no)
  group("CmpItemKindReference", c.mono_2, cno, no)
  group("CmpItemKindFolder", c.mono_2, cno, no)
  group("CmpItemKindEnumMember", c.mono_2, cno, no)
  group("CmpItemKindConstant", c.mono_2, cno, no)
  group("CmpItemKindStruct", c.mono_2, cno, no)
  group("CmpItemKindEvent", c.mono_2, cno, no)
  group("CmpItemKindOperator", c.mono_2, cno, no)
  group("CmpItemKindTypeParameter", c.mono_2, cno, no)
end

-- local hl_nvim_cmp_colorful = function()
--   -- https://github.com/hrsh7th/nvim-cmp#highlights
-- 	-- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/lsp.lua#L108
--   -- https://github.com/olimorris/onedarkpro.nvim/blob/main/lua/onedarkpro/theme.lua
--   group('CmpItemAbbrMatch',        c.light_blue,    cno,            no)
--   group('CmpItemAbbrMatchFuzzy',   c.blue,          cno,            no)
--   group('CmpItemMenu',             c.syntax_fg,     cno,            no)
--   group('CmpItemKind',             c.blue,          cno,            no)
--   group('CmpItemKindText',         c.syntax_fg,     cno,            no)
--   group('CmpItemKindMethod',       c.blue,          cno,            no)
--   group('CmpItemKindFunction',     c.blue,          cno,            no)
--   group('CmpItemKindConstructor',  c.cyan,          cno,            no)
--   group('CmpItemKindField',        c.syntax_fg,     cno,            no)
--   group('CmpItemKindVariable',     c.red,           cno,            no)
--   group('CmpItemKindClass',        c.yellow,        cno,            no)
--   group('CmpItemKindInterface',    c.yellow,        cno,            no)
--   group('CmpItemKindProperty',     c.red,           cno,            no)
--   group('CmpItemKindValue',        c.orange,        cno,            no)
--   group('CmpItemKindKeyword',      c.purple,        cno,            no)
--   group('CmpItemKindSnippet',      c.green,         cno,            no)
--   group('CmpItemKindConstant',     c.green,         cno,            no)
-- end

local hl_plugin_neo_tree_nvim = function()
  group("NeoTreeDirectoryIcon", c.blue, cno, no)
  group("NeoTreeFileIcon", c.green, cno, no)
  group("NeoTreeGitModified", c.yellow, cno, no)
  group("NeoTreeGitUntracked", c.dark_yellow, cno, no)
end

local hl_lang_ansiidoc = function()
  group("asciidocListingBlock", c.mono_2, cno, no)
end

local hl_lang_diff = function()
  group("DiffAdd", c.green, c.visual_grey, no)
  group("DiffChange", c.dark_yellow, c.visual_grey, no)
  group("DiffDelete", c.red, c.visual_grey, no)
  group("DiffText", c.light_blue, c.visual_grey, no)
  group("DiffAdded", c.green, c.visual_grey, no)
  group("DiffFile", c.red, c.visual_grey, no)
  group("DiffNewFile", c.green, c.visual_grey, no)
  group("DiffLine", c.light_blue, c.visual_grey, no)
  group("DiffRemoved", c.red, c.visual_grey, no)
end

local hl_lang_json = function()
  group("jsonCommentError", c.white, cno, no)
  group("jsonKeyword", c.red, cno, no)
  group("jsonQuote", c.light_blue, cno, no)
  -- group('jsonTrailingCommaError',  c.red,          cno,  r )
  -- group('jsonMissingCommaError',   c.red,          cno,  r )
  -- group('jsonNoQuotesError',       c.red,          cno,  r )
  -- group('jsonNumError',            c.red,          cno,  r )
  group("jsonString", c.green, cno, no)
  group("jsonBoolean", c.purple, cno, no)
  group("jsonNumber", c.dark_yellow, cno, no)
  -- group('jsonStringSQError',       c.red,          cno,  r )
  -- group('jsonSemicolonError',      c.red,          cno,  r )
end

local hl_lang_purescript = function()
  group("purescriptAssocType", c.syntax_fg, cno, no)
  group("purescriptConditional", c.light_blue, cno, no)
  group("purescriptDecl", c.syntax_fg, cno, no)
  group("purescriptDeclKeyword", c.light_blue, cno, no)
  group("purescriptDelimiter", c.syntax_fg, cno, no)
  group("purescriptDeriveKeyword", c.blue, cno, no)
  group("purescriptForall", c.light_blue, cno, no)
  group("purescriptForall", c.syntax_fg, cno, no)
  group("purescriptFunctionDecl", c.syntax_fg, cno, no)
  group("purescriptIdentifier", c.syntax_fg, cno, no)
  group("purescriptImport", c.syntax_fg, cno, no)
  group("purescriptKeyword", c.light_blue, cno, no)
  group("purescriptLet", c.light_blue, cno, no)
  group("purescriptLiquid", c.mono_2, cno, no)
  group("purescriptModule", c.syntax_fg, cno, no)
  group("purescriptOperators", c.light_blue, cno, no)
  group("purescriptPragma", c.mono_2, cno, no)
  group("purescriptQuotedtype", c.syntax_fg, cno, no)
  group("purescriptRecordIdentifier", c.syntax_fg, cno, no)
  group("purescriptType", c.yellow_warm, cno, no)
  group("purescriptTypeAlias", c.syntax_fg, cno, no)
  group("purescriptTypeVar", c.syntax_fg, cno, no)
  group("purescriptWhere", c.light_blue, cno, no)
end

local hl_lang_zsh = function()
  group("zshCommands", c.syntax_fg, cno, no)
  group("zshDeref", c.red, cno, no)
  group("zshShortDeref", c.red, cno, no)
  group("zshFunction", c.cyan, cno, no)
  group("zshKeyword", c.purple, cno, no)
  group("zshSubst", c.red, cno, no)
  group("zshSubstDelim", c.comment_grey, cno, no)
  group("zshTypes", c.purple, cno, no)
  group("zshVariableDef", c.dark_yellow, cno, no)
end

local hl_lang = function()
  hl_lang_ansiidoc()
  hl_lang_diff()
  hl_lang_json()
  hl_lang_purescript()
  hl_lang_zsh()
end

local hl_plugin_dressing = function()
  group("FloatTitle", c.comment_grey, cno, no)
  group("FloatBorder", c.comment_grey, cno, no)
end

local hl_plugin_fidget = function()
  group("FidgetTitle", c.purple, cno, no)
  group("FidgetTask", c.syntax_fg, cno, no)
end

local hl_plugin_virt_column = function()
  group("VirtColumn", c.column_gray, c.no, no)
end

local hl_plugins = function()
  hl_plugin_general()
  hl_plugin_nvim_cmp()
  -- hl_plugin_lspsaga()
  hl_plugin_neo_tree_nvim()
  hl_plugin_dressing()
  hl_plugin_fidget()
  hl_plugin_virt_column()
end

local init_theme = function()
  vim.cmd([[ hi clear ]])
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd([[ syntax reset ]])
  end
  vim.o.background = "dark"

  local color_var_name = "color_name"
  if vim.fn.exists("g:" .. color_var_name) == 1 then
    vim.api.nvim_del_var(color_var_name)
  end
  vim.api.nvim_set_var(color_var_name, M.colorscheme_name)
end

M.setup = function()
  init_theme()

  hl_general()
  hl_syntax()
  hl_treesitter()
  -- hl_treesitter_onedarkishii()
  hl_lsp()
  hl_lang()
  hl_plugins()
end

return M
