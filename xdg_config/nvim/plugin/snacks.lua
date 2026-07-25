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

local layout_keymaps = {
  preset = "vscode",
  layout = {
    width = 0.85
  }
}

local switch_defaults_tasks = function()
    local Path = require("plenary.path")
    local raw_path = vim.fn.expand("%:p")
    if string.find(raw_path, "roles") and string.find(raw_path, "tasks") then
      local default_path = Path:new(raw_path):parent():parent():joinpath("defaults"):joinpath("main.yaml")
      if default_path:is_file() then
        vim.api.nvim_command("edit " .. tostring(default_path))
      end
    end
    if string.find(raw_path, "roles") and string.find(raw_path, "defaults") then
      local task_path = Path:new(raw_path):parent():parent():joinpath("tasks"):joinpath("main.yaml")
      if task_path:is_file() then
        vim.api.nvim_command("edit " .. tostring(task_path))
      end
    end
end

local Zuul = {
  exec = os.getenv("ZUUL_SEARCH_BIN_PATH") or "/home/birnevogel11/Trek/zuul-ls/target/release/zuul-search",
}

Zuul.get_visual_selection = function()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  ---@diagnostic disable-next-line: param-type-mismatch
  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

---@param input string
---@return table<string>
local split_by_tab = function(input)
  local result = {}
  for word in string.gmatch(input, "[^\t]+") do
    table.insert(result, word)
  end
  return result
end

---@param cmd string
---@return table<string>
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

---@param cmd string
---@return table<table<string>>?
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

---@param base_opts snacks.picker.Config
---@param opts snacks.picker.Config
---@return snacks.Picker
Zuul._picker = function(base_opts, opts)
  return Snacks.picker(vim.tbl_deep_extend("force", base_opts, opts))
end

---@param tokens table<string>
---@return snacks.picker.Item
local function transfer_file_loc(tokens)
    return {
      text = tokens[1],
      file = tokens[2],
      pos = {tonumber(tokens[3]) + 1, tonumber(tokens[4])},
    }
end

---@param tokens table<string>
---@return snacks.picker.Item
local function transfer_file(tokens)
    return {
      text = tokens[1],
      file = tokens[2],
    }
end

---@param tokens table<string>
---@return snacks.picker.Item
local function transfer_var(tokens)
    return {
      text = tokens[1],
      file = tokens[4],
      pos = {(tonumber(tokens[5]) or 0) + 1, tonumber(tokens[6])},
      zuul_job = tokens[2],
      zuul_value = tokens[3],
    }
end

---@param item snacks.picker.Item
---@return snacks.picker.Highlight
local function format_text_only(item)
  return {{item.text, "SnacksPickerItem"}}
end

---@param opts snacks.picker.Config
---@return snacks.Picker
Zuul.job = function(opts)
  local base_opts = {
    title = "Zuul Jobs",
    items = Zuul._transfer_items("jobs", transfer_file),
    format = format_text_only,
  }

  return Zuul._picker(base_opts, opts)
end

---@param opts snacks.picker.Config
---@return snacks.Picker
Zuul.project_template = function(opts)
  local base_opts = {
    title = "Zuul Project Templates",
    items = Zuul._transfer_items("project-templates", transfer_file_loc),
    format = format_text_only,
  }

  return Zuul._picker(base_opts, opts)
end

---@param opts snacks.picker.Config
---@return snacks.Picker
Zuul.workspace_var = function(opts)
  local a = Snacks.picker.util.align

  local base_opts = {
    title = "Zuul Workspace Vars",
    items = Zuul._transfer_items("workdir-vars", transfer_var),
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

  return Zuul._picker(base_opts, opts)
end

---@param opts snacks.picker.Config
---@return snacks.Picker
Zuul.role = function(opts)
  local a = Snacks.picker.util.align

  local base_opts = {
    title = "Zuul Roles",
    items = Zuul._transfer_items("roles", transfer_file),
    format = function(item)
      return {
        {a(item.text, 50), "SnacksPickerItem"},
        {" ", "SnacksComment"},
        {item.file, "SnacksPickerFile"},
      }
    end,
  }

  return Zuul._picker(base_opts, opts)
end


---@param opts snacks.picker.Config
---@param job_name string?
---@return snacks.Picker
Zuul.job_hierarchy = function(opts, job_name)
  job_name = job_name or Zuul.get_visual_selection()

  local base_opts = {
    title = "Zuul Job Hierarchy",
    items = Zuul._transfer_items("job-hierarchy " .. job_name, transfer_file_loc),
    format = format_text_only,
  }

  return Zuul._picker(base_opts, opts)
end


---@param opts snacks.picker.Config
---@param job_name string?
---@return snacks.Picker
Zuul.job_playbooks =  function(opts, job_name)
  job_name = job_name or Zuul.get_visual_selection()

  local base_opts = {
    title = "Zuul Job Playbooks",
    items = Zuul._transfer_items("job-playbooks " .. job_name, transfer_file),
    format = format_text_only,
  }

  return Zuul._picker(base_opts, opts)
end

-- require("beaver.lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim" },
  }, { confirm = false })

  require("snacks").setup({
    words = { enabled = false },
    picker = {
      formatters = {
        file = {
          truncate = 120,
        }
      }
    },
    -- bigfile = {},
    -- gitbrowse = {},
    notifier = {
      border = true,
    },
    -- image = {},
  })

  -- Resume
  vim.keymap.set("n", "<leader>fr", function() Snacks.picker.resume() end, { desc = "Resume" } )

  -- -- Resume
  --
  -- -- File and search
  vim.keymap.set("n", "<leader>ff", function() Snacks.picker.smart({ layout = layout_simple }) end, { desc = "Smart Find files"} )
  vim.keymap.set("n", "<leader>fm", function() Snacks.picker.recent({ layout = layout_simple }) end, { desc = "Recent"} )
  vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep({ layout = layout_search }) end, { desc = "Grep"})
  vim.keymap.set({ "v", "x" }, "<leader>fg", function() Snacks.picker.grep_word({ layout = layout_search }) end, { desc = "Visual selection or word" })
  vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers({ layout = layout_search }) end, { desc = "Buffers"} )
  vim.keymap.set("n", "<leader>fw", function() Snacks.picker.lines({ layout = layout_search }) end, { desc = "Buffer Lines"} )
  ---@diagnostic disable-next-line: undefined-field
  vim.keymap.set({"v", "x"}, "<leader>fw", function() Snacks.picker.lines({ search=Snacks.picker:word(), layout = layout_search }) end,  { desc = "Buffer Lines" })
  ---@diagnostic disable-next-line: undefined-field
  vim.keymap.set("n", "<leader>ft", function() Snacks.picker.todo_comments({ layout = layout_fullscreen}) end, { desc = "Todo comments"})
  vim.keymap.set("n", "<leader>fz", function() Snacks.picker.zoxide({ layout = layout_simple }) end, { desc = "Zoxide"} )

  -- LSP
  vim.keymap.set("n", "<C-]", function() Snacks.picker.lsp_definitions({layout = layout_search}) end, { desc = "Goto Definition" })
  vim.keymap.set("n", "<leader>fj", function() Snacks.picker.lsp_symbols({ layout = layout_search}) end, { desc = "LSP Symbols" })
  vim.keymap.set("n", "<leader>fk", function() Snacks.picker.lsp_workspace_symbols({ layout = layout_search}) end, { desc = "LSP Workspace Symbols" })
  vim.keymap.set("n", "<leader>fl", function() Snacks.picker.lsp_references({ layout = layout_search}) end, { desc = "LSP References" })

  -- Neovim
  vim.keymap.set("n", "<leader>fx", function() Snacks.picker.help({ layout = layout_search }) end, { desc = "Help Pages" })
  vim.keymap.set("n", "<leader>fe", function() Snacks.picker.keymaps({ layout = layout_keymaps }) end, { desc = "Keymaps" })
  vim.keymap.set("n", "<leader>fc", function() Snacks.picker.commands({ layout = layout_fullscreen }) end, { desc = "Commands" })
  vim.keymap.set("n", "<leader>fn", function() Snacks.picker.notifications({ layout = layout_fullscreen }) end, { desc = "Notifications" })
  vim.keymap.set("n", "<leader>fJ", function() Snacks.picker.jumps({ layout = layout_search }) end, { desc = "Jumps" })
  vim.keymap.set("n", "<leader>fp", function() Snacks.picker.pickers({ layout = layout_fullscreen }) end, { desc = "Snack Pickers" })

  -- Git
  vim.keymap.set("n", "<leader>fs", function() Snacks.picker.git_status({layout = layout_search}) end, { desc = "Git Status" })
  vim.keymap.set("n", "<leader>gc", function() Snacks.picker.git_branches({layout = layout_search}) end, { desc = "Git Branches" })

  -- Zuul
  vim.keymap.set("n", "<leader>zj", function() Zuul.job({layout = layout_search}) end, { desc = "Zuul jobs" })
  vim.keymap.set("n", "<leader>zr", function() Zuul.role({layout = layout_search}) end, { desc = "Zuul Roles" })
  vim.keymap.set("n", "<leader>zt", function() Zuul.project_template({layout = layout_search}) end, { desc = "Zuul Project Templates" })
  vim.keymap.set("n", "<leader>zv", function() Zuul.workspace_var({layout = layout_search}) end, { desc = "Zuul workspace vars" })
  vim.keymap.set({"v", "x"}, "<leader>zh", function() Zuul.job_hierarchy({layout = layout_search}) end, { desc = "Zuul Job Hierarchy" } )
  vim.keymap.set({ "v", "x"  }, "<leader>zp", function() Zuul.job_playbooks({layout = layout_search}) end, { desc = "Zuul Job Playbooks" } )
  vim.keymap.set("n", "<leader>zs", switch_defaults_tasks, { desc = "Zuul - Switch defaults/tasks main.yaml" })
-- end)
