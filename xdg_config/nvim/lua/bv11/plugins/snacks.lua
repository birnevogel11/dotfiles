local layout_simple = {
  fullscreen = true,
  preview = false,
  layout = {
    backdrop = false,
    box = "vertical",
    border = "none",
    title = nil,
    { win = "input", height = 1, border = "none" },
    { win = "list", border = "none" },
  },
}

local layout_search = {
  preset = "ivy_split",
}

local layout_fullscreen = {
  fullscreen = true,
}

local split_by_tab = function(input)
  local result = {}
  for word in string.gmatch(input, "[^\t]+") do
    table.insert(result, word)
  end
  return result
end

local function get_command_output(cmd)
  local lines = {}

  local handle = io.popen(cmd)
  if handle then
    for line in handle:lines() do
      table.insert(lines, line)
    end
    handle:close()
  else
    print("Failed to execute fd command")
  end

  return lines
end

local function get_command_output_spilt_by_tab(cmd)
  local lines = get_command_output(cmd)
  if not lines then
    return nil
  end

  local token_lines = {}
  for _, job in ipairs(lines) do
    local tokens = split_by_tab(job)
    token_lines[#token_lines+1] = tokens
  end

  return token_lines
end

Zuul = {
  exec = "/home/birnevogel11/Trek/zuul-ls/target/debug/zuul-search",
}

---@param sub_command string
---@param job_name string?
Zuul._make_command = function(sub_command, job_name)
  local cmd = Zuul.exec .. " " .. sub_command
  if job_name ~= nil then
    cmd = cmd .. " " .. job_name
  end
  return cmd
end


---@param sub_command string
---@param transfer fun(tokens:table<string>):snacks.picker.Item
Zuul._transfer_items = function(sub_command, transfer)
  local token_lines = get_command_output_spilt_by_tab(Zuul._make_command(sub_command))
  if not token_lines then
    return
  end

  local items = {}
  for _, tokens in ipairs(token_lines) do
    table.insert(items, transfer(tokens))
  end

  return items
end

---@param opts snacks.picker.Config
Zuul.job = function(opts)
  local items = Zuul._transfer_items("jobs", function(tokens)
    return {
      text = tokens[1],
      file = tokens[2],
      pos = {tonumber(tokens[3]) + 1, tonumber(tokens[4])},
    }
  end)

  local base_opts = {
    items = items,
    format = function(item)
      return {{item.text, "SnacksPickerItem"}}
    end,
  }

  return Snacks.picker(vim.tbl_deep_extend("force", base_opts, opts))
end

---@param opts snacks.picker.Config
Zuul.workspace_var = function(opts)
  local items = Zuul._transfer_items("workdir-vars", function(tokens)
    return {
      text = tokens[1],
      file = tokens[4],
      pos = {(tonumber(tokens[5]) or 0) + 1, tonumber(tokens[6])},
      zuul_job = tokens[2],
      zuul_value = tokens[3],
    }
  end)

  local a = Snacks.picker.util.align

  local base_opts = {
    items = items,
    format = function(item)
      return {
        {a(item.text, 40), "SnacksPickerItem"},
        {" ", "SnacksComment"},
        {a(item.zuul_job, 40), "SnacksComment"},
        {" ", "SnacksComment"},
        {a(item.zuul_value, 50), "SnacksComment"},
      }
    end,
  }

  return Snacks.picker(vim.tbl_deep_extend("force", base_opts, opts))
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        formatters = {
          file = {
            truncate = 120,
          }
        }
      },
      bigfile = {},
      gitbrowse = {},
    },
    keys = {
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume", },

      { "<leader>ff", function() Snacks.picker.smart({ layout = layout_simple }) end, desc = "Smart Find files", },
      { "<leader>fm", function() Snacks.picker.recent({ layout = layout_simple }) end, desc = "Recent", },
      { "<leader>fg", function() Snacks.picker.grep({ layout = layout_search }) end, desc = "Grep", },
      { "<leader>fg", function() Snacks.picker.grep_word({ layout = layout_search }) end, desc = "Visual selection or word", mode = { "v", "x" } },
      { "<leader>fb", function() Snacks.picker.buffers({ layout = layout_search }) end, desc = "Buffers", },
      { "<leader>fw", function() Snacks.picker.lines({ layout = layout_search }) end, desc = "Buffer Lines" },
      { "<leader>fw", function() Snacks.picker.lines({ search=Snacks.picker:word(), layout = layout_search }) end, mode = { "v", "x" }, desc = "Buffer Lines" },

      { "<C-]", function() Snacks.picker.lsp_definitions({layout = layout_search}) end, desc = "Goto Definition" },
      { "<leader>fj", function() Snacks.picker.lsp_symbols({ layout = layout_search}) end, desc = "LSP Symbols", },
      { "<leader>fk", function() Snacks.picker.lsp_workspace_symbols({ layout = layout_search}) end, desc = "LSP Workspace Symbols", },
      { "<leader>fl", function() Snacks.picker.lsp_references({ layout = layout_search}) end, desc = "LSP References", },

      { "<leader>fx", function() Snacks.picker.help({ layout = layout_search }) end, desc = "Help Pages", },
      { "<leader>fz", function() Snacks.picker.keymaps({ layout = layout_fullscreen }) end, desc = "Keymaps", },
      { "<leader>fe", function() Snacks.picker.commands({ layout = layout_fullscreen }) end, desc = "Commands", },

      { "<leader>fn", function() Snacks.picker.git_status({layout = layout_search}) end, desc = "Git Status", },
      { "<leader>gc", function() Snacks.picker.git_branches({layout = layout_search}) end, desc = "Git Branches", },

      { "<leader>zj", function() Zuul.job({layout = layout_search}) end, desc = "Zuul jobs", },
      { "<leader>zv", function() Zuul.workspace_var({layout = layout_search}) end, desc = "Zuul jobs", },
    },
  },
}
