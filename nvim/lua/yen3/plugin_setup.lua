local keymap_n = require("yen3.lib.keymap").keyamp_n

local M = {}

local set_variables = function(variables)
  for k, v in pairs(variables) do
    vim.api.nvim_set_var(k, v)
  end
end

M.luatab_nvim = function()
  local luatab = require("luatab")
  local helpers = luatab.helpers

  local title = function(bufnr)
    local name = helpers.title(bufnr)
    if name ~= "[No Name]" then
      name = "[" .. name .. "]"
    end
    return name
  end

  local cell = function(index)
    local isSelected = vim.fn.tabpagenr() == index
    local buflist = vim.fn.tabpagebuflist(index)
    local winnr = vim.fn.tabpagewinnr(index)
    local bufnr = buflist[winnr]
    local hl = (isSelected and "%#TabLineSel#" or "%#TabLine#")

    return hl .. "%" .. index .. "T" .. " " .. index .. ":" .. title(bufnr) .. " " .. helpers.modified(bufnr)
  end

  luatab.setup({ cell = cell })
end

M.vim_better_whitespace = function()
  set_variables({
    better_whitespace_enabled = 1,
    strip_whitespace_on_save = 1,
    strip_whitelines_at_eof = 1,
    show_spaces_that_precede_tabs = 1,
    strip_whitespace_confirm = 0,
    strip_max_file_size = 1000,
  })
end

M.tagbar = function()
  set_variables({
    tagbar_map_openfold = { "zo", "l" },
    tagbar_map_closeallfolds = "zm",
    tagbar_map_openallfolds = "zr",

    tagbar_width = 40,
    tagbar_autofocus = 1, -- Keep focus on tagbar window
    tagbar_sort = 1, -- Sort tags alphabetically
    tagbar_compact = 1,
    tagbar_indent = 1,
    tagbar_autopreview = 0, -- Don't autopreview, enable it with P
    tagbar_previewwin_pos = "belowright",

    tagbar_type_python = {
      kinds = {
        "i:modules:1:0",
        "c:classes",
        "f:functions",
        "m:members",
        "v:variables:0:0",
        "x:unknowns",
      },
    },
  })

  keymap_n("<leader>tb", ":TagbarOpen jc<cr>")
end

return M
