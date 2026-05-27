-- ~/.config/nvim/lua/template_picker.lua
-- Telescope-powered template picker that inserts selected template into current buffer
-- Templates are discovered from:
--   - ~/.config/nvim/templates
--   - ~/.config/nvim/CP
-- Supports both full buffer replacement and snippet-style insertion

local M = {}

local function list_files_in(dir)
  local results = {}
  if vim.fn.isdirectory(dir) ~= 1 then
    return results
  end
  local fs = vim.loop.fs_scandir(dir)
  if not fs then
    return results
  end
  while true do
    local name, t = vim.loop.fs_scandir_next(fs)
    if not name then break end
    if t == 'file' then
      table.insert(results, dir .. '/' .. name)
    end
  end
  return results
end

local function create_picker(insert_mode)
  local ok, telescope = pcall(require, 'telescope')
  if not ok then
    vim.notify('telescope.nvim is not installed', vim.log.levels.ERROR)
    return
  end

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local cfg = vim.fn.stdpath('config')
  local search_dirs
  if insert_mode then
    search_dirs = { cfg .. '/snippets', cfg .. '/templates', cfg .. '/CP' }
  else
    search_dirs = { cfg .. '/templates', cfg .. '/CP' }
  end

  local files = {}
  for _, d in ipairs(search_dirs) do
    local items = list_files_in(d)
    for _, f in ipairs(items) do table.insert(files, f) end
  end

  if #files == 0 then
    vim.notify('No templates found in templates/ or CP/', vim.log.levels.WARN)
    return
  end

  local title = insert_mode and 'Snippets (insert at cursor)' or 'Templates (replace buffer)'

  pickers.new({}, {
    prompt_title = title,
    finder = finders.new_table({ results = files }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local function apply_selection()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local path = entry[1] or entry.value
        local content = vim.fn.readfile(path)
        if not content or #content == 0 then
          vim.notify('Template is empty: ' .. tostring(path), vim.log.levels.WARN)
          return
        end

        if insert_mode then
          -- Insert at cursor position
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, content)
          -- Move cursor to end of inserted content
          vim.api.nvim_win_set_cursor(0, { row + #content - 1, #content[#content] })
        else
          -- Replace entire buffer with template content
          vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
          vim.cmd('normal! gg')
        end
      end
      map('i', '<CR>', apply_selection)
      map('n', '<CR>', apply_selection)
      return true
    end,
  }):find()
end

function M.open()
  create_picker(false) -- Replace buffer mode
end

function M.open_snippets()
  create_picker(true) -- Insert at cursor mode
end

return M
