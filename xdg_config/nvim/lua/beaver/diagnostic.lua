local og_virt_text
local og_virt_line

local virtual_text_format = function(diagnostic)
  -- Show diagnostic messages after coloum 80
  -- Ref: https://gist.github.com/tjdevries/ccbe3b79bd918208f2fa8dfe15b95793
  local line_space = 75 -- 80 - 5 (original space (6) - 1)

  local bufnr = diagnostic.bufnr
  local line = diagnostic.lnum
  local line_length = #(vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or "")
  local msg = "■ " .. diagnostic.message
  if line_length < line_space then
    msg = string.rep(" ", line_space - line_length) .. msg
  end
  return msg
end

local diagnostic_setup_buffer_enter = function()
  local seve = vim.diagnostic.severity
  vim.diagnostic.config({
    underline = true,
    signs = {
        text = {
            [seve.ERROR] = ' ',
            [seve.WARN] = ' ',
            [seve.INFO] = '󰮦 ',
            [seve.HINT] = ' ',
        },
    },
    update_in_insert = false,
    virtual_text = {
      prefix = "",
      format = virtual_text_format,
    },
    virtual_lines = { current_line = true },
  })

  vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    group = vim.api.nvim_create_augroup('diagnostic_only_normal_mode', {}),
    callback = function()
      vim.diagnostic.config({ virtual_text = false })
    end
  })

  vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('diagnostic_only_normal_mode_leave', {}),
    callback = function()
      vim.diagnostic.config({ virtual_text = { current_line = true }})
    end
  })

  -- Source: https://www.reddit.com/r/neovim/comments/1jpbc7s/disable_virtual_text_if_there_is_diagnostic_in/
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'DiagnosticChanged' }, {
    group = vim.api.nvim_create_augroup('diagnostic_only_virtlines', {}),
    callback = function()
      if og_virt_line == nil then
        og_virt_line = vim.diagnostic.config().virtual_lines
      end

      -- ignore if virtual_lines.current_line is disabled
      if not (og_virt_line and og_virt_line.current_line) then
        if og_virt_text then
          vim.diagnostic.config({ virtual_text = og_virt_text })
          og_virt_text = nil
        end
        return
      end

      if og_virt_text == nil then
        og_virt_text = vim.diagnostic.config().virtual_text
      end

      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

      if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
        vim.diagnostic.config({ virtual_text = og_virt_text })
      else
        vim.diagnostic.config({ virtual_text = false })
      end
    end
  })
end

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    diagnostic_setup_buffer_enter()
  end,
  group = vim.api.nvim_create_augroup("Padding_diagnostic_virtual_text", { clear = true }),
})
