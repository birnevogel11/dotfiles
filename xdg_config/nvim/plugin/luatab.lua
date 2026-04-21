require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/alvarosevilla95/luatab.nvim" },
    { src = "https://github.com/kyazdani42/nvim-web-devicons" },
  })

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
end)
