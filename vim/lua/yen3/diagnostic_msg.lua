-- Credit: https://gitlab.com/yorickpeterse/dotfiles/-/blob/a1fd1cbc17bd33990f0ccacd9d7cc8feb26d8436/dotfiles/.config/nvim/lua/dotfiles/diagnostics.lua
local util = require 'vim.lsp.util'

-- Echoing of LSP diagnostics in the commandline.
local M = {}

-- Show the type information for the cursor word when the value is true
M.echo_hls_hover = false

-- Location information about the last message printed. The format is
-- `(did print, buffer number, line number)`.
local last_echo = { false, -1, -1 }

-- The timer used for displaying a diagnostic in the commandline.
local echo_timer = nil

-- The timer after which to display a diagnostic in the commandline.
local echo_timeout = 250

-- The highlight group to use for warning messages.
local warning_hlgroup = 'WarningMsg'

-- The highlight group to use for error messages.
local error_hlgroup = 'ErrorMsg'


-- If the first diagnostic line has fewer than this many characters, also add
-- the second line to it.
local short_line_limit = 20

function M.toggle_echo_hover_hls()
  M.echo_hls_hover = not M.echo_hls_hover
end

function M.get_buf_activated_lsp()
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return nil
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client.name
    end
  end
  return nil
end

function M.echo_hover_hls()
  if M.get_buf_activated_lsp() ~= 'hls' then
    return nil
  end

  local params = util.make_position_params()
  local bufnr = vim.api.nvim_win_get_buf(0)
  local req = vim.lsp.buf_request_sync(bufnr, 'textDocument/hover', params)
  if req == nil or #req == 0 or req[1].result == nil then
    return nil
  end

  local result = req[1].result
  local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then
    return nil
  end

  if #markdown_lines >= 2 then
    return markdown_lines[2]
  end

  return nil
end

-- Shows the current line's diagnostics in a floating window.
function M.show_line_diagnostics()
  vim
    .lsp
    .diagnostic
    .show_line_diagnostics({ severity_limit = 'Warning' }, vim.fn.bufnr(''))
end

-- Prints the first diagnostic for the current line.
function M.echo_diagnostic()
  if echo_timer then
    echo_timer:stop()
  end

  echo_timer = vim.defer_fn(
    function()

      local line = vim.fn.line('.') - 1
      local bufnr = vim.api.nvim_win_get_buf(0)

      if last_echo[1] and last_echo[2] == bufnr and last_echo[3] == line then
        return
      end

      local diags = vim
        .lsp
        .diagnostic
        .get_line_diagnostics(bufnr, line, { severity_limit = 'Warning' })

      if #diags == 0 then
        -- If we previously echo'd a message, clear it out by echoing an empty
        -- message.
        if last_echo[1] then
          last_echo = { false, -1, -1 }

          vim.api.nvim_command('echo ""')
        end

        return
      end

      last_echo = { true, bufnr, line }

      local diag = diags[1]
      local width = vim.api.nvim_get_option('columns') - 15
      local lines = vim.split(diag.message, "\n")
      local message = lines[1]

      if #lines > 1 and #message <= short_line_limit then
        message = message .. ' ' .. lines[2]
      end

      if width > 0 and #message >= width then
        message = message:sub(1, width) .. '...'
      end

      local kind = 'warning'
      local hlgroup = warning_hlgroup

      if diag.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
        kind = 'error'
        hlgroup = error_hlgroup
      end

      local chunks = {
        { kind .. ': ', hlgroup },
        { message }
      }

      vim.api.nvim_echo(chunks, false, {})
    end,
    echo_timeout
  )
end

-- Show function type information for haskell filetype
-- or show line diagnostics for another filetypes
function M.echo_diagnostic_or_hover()
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')

  if buf_ft == "haskell" then
      if not M.echo_hls_hover then
        return
      end

      -- (2021/12/10) HLS could not show line diagnostics messages with
      -- `M.echo_diagnostic()` instantly. If `M.echo_diagnostic()` is called
      -- continually, hls could not response correctly. Show the type
      -- information of the cursor word instaed.
      -- If it's too verbose, it will be removed in future.
      local msg = M.echo_hover_hls()
      if msg then
        vim.api.nvim_command('echo "' .. msg .. '"')
        return
      else
        vim.api.nvim_command('echo ""')
        return
      end
  else
    M.echo_diagnostic()
  end
end

return M
