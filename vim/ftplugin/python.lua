require('yen3.lib.ftplugin').indention_setup(4, 119)

vim.opt.colorcolumn = '79,119'

local remote_debug_lines = function(linenr)
  local height = vim.o.lines
  local width = vim.o.columns

  linenr = linenr or vim.api.nvim_win_get_cursor(0)[1]
  local indent_space = string.rep(" ", vim.fn.indent(linenr))

  return {
    "",
    indent_space .. "logger.info(\"yen3-debug: start remote pudb 6899\")",
    indent_space .. "from pudb.remote import set_trace; set_trace(term_size=(" ..
        width .. ", " ..  height .. "), host='0.0.0.0')",
    "",
  }
end

local insert_remote_debug_lines = function ()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, linenr, linenr, true, remote_debug_lines(linenr))
end

vim.api.nvim_create_user_command("InsertPudbRemoteDebugLines",
  insert_remote_debug_lines,
  { desc = "Insert pudb remote debug lines"}
)
