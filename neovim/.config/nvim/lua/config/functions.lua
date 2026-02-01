-- ~/.config/nvim/lua/util/functions.lua
local M = {}

-- Remove an autocmd group if it exists
function M.remove_augroup(name)
  if vim.fn.exists("#" .. name) == 1 then
    vim.cmd("au! " .. name)
  end
end

-- Get length of the word under the cursor
function M.get_word_length()
  return #(vim.fn.expand("<cword>") or "")
end

-- Toggle a boolean vim option (like 'cursorline', 'relativenumber', etc)
function M.toggle_option(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify(option .. " set to " .. tostring(value))
end

-- Toggle the visibility of the tabline
function M.toggle_tabline()
  local value = vim.api.nvim_get_option_value("showtabline", {})
  vim.opt.showtabline = (value == 2) and 0 or 2
  vim.notify("showtabline set to " .. vim.opt.showtabline:get())
end

-- Toggle LSP diagnostics on/off
local diagnostics_active = true
function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

-- Check if a string is nil or empty
function M.isempty(s)
  return s == nil or s == ""
end

-- Safely get a buffer option
function M.get_buf_option(opt)
  local ok, val = pcall(vim.api.nvim_buf_get_option, 0, opt)
  return ok and val or nil
end

-- Return current buffer's word count
function M.get_words()
  return tostring(vim.fn.wordcount().words)
end

return M
