local M = {}

local diagnostic_setup_buffer_enter = function()
  vim.diagnostic.config({
    underline = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = '󰮦 ',
            [vim.diagnostic.severity.HINT] = ' ',
            -- ["DapBreakpoint"] = " ",
            -- ["DapBreakpointRejected"] = " ",
            -- ["DapStopped"] = " ",
        },
    },
    update_in_insert = false,
    virtual_text = {
      prefix = "",
      format = function(diagnostic)
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
      end,
    },
  })
end

M.diagnostic_setup = function()
  local group = vim.api.nvim_create_augroup("bv11_padding_diagnostic_virtual_text", { clear = true })
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      diagnostic_setup_buffer_enter()
    end,
    group = group,
  })
end

return M
