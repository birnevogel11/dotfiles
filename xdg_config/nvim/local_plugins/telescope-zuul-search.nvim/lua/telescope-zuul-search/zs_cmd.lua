local utils = require("telescope.utils")
local Path = require("plenary.path")
local strings = require("plenary.strings")
local os_home = vim.loop.os_homedir()

local zs = {
  program = "~/Trek/zuul-search/target/debug/zuul-search",
}

local shorten_path = function(path)
  if vim.startswith(path, os_home) then
    path = Path:new("~/") .. Path:new(path):make_relative(os_home)
  end

  return path
end

local split_by_tab = function(input)
  local result = {}
  for word in string.gmatch(input, "[^\t]+") do
    table.insert(result, word)
  end
  return result
end

zs.cmd = function(subcommand, parse_line_func, widths)
  local cmd = { vim.o.shell, "-c", zs.program .. " " .. subcommand }
  local raw_lines = utils.get_os_command_output(cmd)

  local results = {}
  for _, line in pairs(raw_lines) do
    table.insert(results, parse_line_func(line))
  end

  for _, entry in pairs(results) do
    for key, value in pairs(widths) do
      widths[key] = math.max(value, strings.strdisplaywidth(entry[key] or ""))
    end
  end

  return { results = results, widths = widths }
end

zs.jobs = function(subcommand)
  local parse_line = function(line)
    local args = split_by_tab(line)

    return {
      value = args[1],
      path = shorten_path(args[2]),
      lnum = tonumber(args[3]),
      col = tonumber(args[4]),
      ordinal = args[1],
    }
  end

  return zs.cmd(subcommand or "jobs", parse_line, { value = 0, path = 0 })
end

zs.roles = function(cmd)
  local parse_line = function(line)
    local args = split_by_tab(line)

    return {
      value = args[1],
      path = shorten_path(args[2]),
      ordinal = args[1],
    }
  end

  return zs.cmd("roles", parse_line, { value = 0, path = 0 })
end

zs.project_templates = function()
  local parse_line = function(line)
    local args = split_by_tab(line)

    return {
      value = args[1],
      path = shorten_path(args[2]),
      lnum = tonumber(args[3]),
      col = tonumber(args[4]),
      ordinal = args[1],
    }
  end

  return zs.cmd("project-templates", parse_line, { value = 0, path = 0 })
end

zs.job_vars = function(job_name)
  local parse_line = function(line)
    local args = split_by_tab(line)

    return {
      value = args[1],
      ordinal = args[1],
      zuul_job_name = args[2],
      assigned_value = args[3],
      path = shorten_path(args[4]),
      lnum = tonumber(args[5]),
      col = tonumber(args[6]),
    }
  end
  local widths = { value = 0, assigned_value = 0, zuul_job_name = 0 }

  return zs.cmd("list-job-vars " .. job_name, parse_line, widths)
end

zs.job_playbooks = function(job_name)
  local parse_line = function(line)
    local args = split_by_tab(line)
    local path = shorten_path(args[1])

    return {
      value = path,
      ordinal = path,
      path = path,
      playbook_type = args[2],
      zuul_job_name = args[3],
    }
  end
  local widths = { value = 0, playbook_type = 0, zuul_job_name = 0 }

  return zs.cmd("list-job-playbooks " .. job_name, parse_line, widths)
end

return zs
