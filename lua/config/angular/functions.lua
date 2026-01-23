-- Angular keymap functions
local M = {}

local function angular_navigate()
  local dir = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t:r") -- filename without extension
  local extension = vim.fn.expand("%:e") -- file extension

  -- Remove any .component suffix (backward compatibility)
  local base_name = filename:gsub("%.component$", "")

  -- Define all possible related files
  local related_files = {
    -- Component files
    component = dir .. "/" .. base_name .. ".ts",
    template = dir .. "/" .. base_name .. ".html",
    -- Style files
    scss = dir .. "/" .. base_name .. ".scss",
    css = dir .. "/" .. base_name .. ".css",
    sass = dir .. "/" .. base_name .. ".sass",
    less = dir .. "/" .. base_name .. ".less",
    -- Test file
    spec = dir .. "/" .. base_name .. ".spec.ts",
  }

  -- Current file type
  local current_type = nil
  if extension == "ts" and not string.match(filename, "%.spec$") then
    current_type = "component"
  elseif extension == "html" then
    current_type = "template"
  elseif extension == "scss" then
    current_type = "scss"
  elseif extension == "css" then
    current_type = "css"
  elseif extension == "sass" then
    current_type = "sass"
  elseif extension == "less" then
    current_type = "less"
  elseif string.match(filename, "%.spec$") then
    current_type = "spec"
  end

  -- Priority order for navigation
  local navigation_priority = {
    "component",
    "template",
    "scss",
    "css",
    "sass",
    "less",
    "spec",
  }

  -- Find the next file in priority order (cyclical)
  local current_index = nil
  for i, file_type in ipairs(navigation_priority) do
    if file_type == current_type then
      current_index = i
      break
    end
  end

  if current_index then
    -- Try next files in priority order
    for i = 1, #navigation_priority do
      local next_index = (current_index + i - 1) % #navigation_priority + 1
      local next_type = navigation_priority[next_index]
      local next_file = related_files[next_type]

      -- Skip current file and non-existent files
      if next_type ~= current_type and next_file and vim.fn.filereadable(next_file) == 1 then
        vim.cmd("edit " .. next_file)
        return
      end
    end
  end

  -- Fallback: show available files
  local available_files = {}
  for file_type, file_path in pairs(related_files) do
    if vim.fn.filereadable(file_path) == 1 then
      table.insert(available_files, file_type .. ": " .. vim.fn.fnamemodify(file_path, ":t"))
    end
  end

  if #available_files > 0 then
    print("Available related files: " .. table.concat(available_files, ", "))
  else
    print("No related Angular files found")
  end
end

-- Quick navigation to component
local function angular_goto_component()
  local dir = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t:r")
  local base_name = filename:gsub("%.component$", "")

  local component_file = dir .. "/" .. base_name .. ".ts"
  if vim.fn.filereadable(component_file) == 1 then
    vim.cmd("edit " .. component_file)
  else
    print("Component file not found: " .. component_file)
  end
end

-- Quick navigation to template
local function angular_goto_template()
  local dir = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t:r")
  local base_name = filename:gsub("%.component$", "")

  local template_file = dir .. "/" .. base_name .. ".html"
  if vim.fn.filereadable(template_file) == 1 then
    vim.cmd("edit " .. template_file)
  else
    print("Template file not found: " .. template_file)
  end
end

-- Quick navigation to style
local function angular_goto_style()
  local dir = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t:r")
  local base_name = filename:gsub("%.component$", "")

  local style_files = {
    dir .. "/" .. base_name .. ".scss",
    dir .. "/" .. base_name .. ".css",
    dir .. "/" .. base_name .. ".sass",
    dir .. "/" .. base_name .. ".less",
  }

  for _, style_file in ipairs(style_files) do
    if vim.fn.filereadable(style_file) == 1 then
      vim.cmd("edit " .. style_file)
      return
    end
  end
  print("No style file found")
end

-- Quick navigation to test
local function angular_goto_test()
  local dir = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t:r")
  local base_name = filename:gsub("%.component$", "")

  local spec_file = dir .. "/" .. base_name .. ".spec.ts"
  if vim.fn.filereadable(spec_file) == 1 then
    vim.cmd("edit " .. spec_file)
  else
    print("Test file not found: " .. spec_file)
  end
end

M.angular_navigate = angular_navigate
M.angular_goto_component = angular_goto_component
M.angular_goto_template = angular_goto_template
M.angular_goto_style = angular_goto_style
M.angular_goto_test = angular_goto_test

return M
