local util = require 'vim.lsp.util'

local M = {}

-- Show the type information for the cursor word when the value is true
M.echo_hls_hover = false

-- The timer used for displaying a diagnostic in the commandline.
M.echo_timer = nil

-- The timer after which to display a diagnostic in the commandline.
M.echo_timeout = 250

-- Location information about the last message printed. The format is
-- `(did print, buffer number, line number)`.
M.last_echo = { false, -1, -1 }

function M.toggle_echo_hover_hls()
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  if buf_ft == 'haskell' then
    M.echo_hls_hover = not M.echo_hls_hover
  end
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

function M.echo_hover_msg()
  if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'haskell' then
    return
  end

  if M.echo_timer then
    M.echo_timer:stop()
  end

  local echo_func = function()
    local line = vim.fn.line('.') - 1
    local column = vim.fn.col('.') - 1
    local bufnr = vim.api.nvim_win_get_buf(0)

    if M.last_echo[1] and bufnr == M.last_echo[2] and line == M.last_echo[3] then
      return
    end

    local msg = M.echo_hover_hls()
    if msg == nil then
      return
    end

    M.last_echo = {true, bufnr, line}
    vim.api.nvim_command('echo ""')
  end

  M.echo_timer = vim.defer_fn(echo_func, M.echo_timeout)
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
