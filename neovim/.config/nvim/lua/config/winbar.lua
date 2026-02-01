-- lua/config/winbar.lua

local function buffer_count()
  return #vim.fn.getbufinfo({ buflisted = 1 })
end

local function should_hide_winbar()
  -- Hide for special buffers and a few noisy filetypes
  if vim.bo.buftype ~= "" then
    return true
  end
  local ft = vim.bo.filetype
  if ft == "help" or ft == "alpha" or ft == "dashboard" or ft == "neo-tree" then
    return true
  end
  return false
end

local function set_winbar()
  if should_hide_winbar() then
    vim.opt_local.winbar = ""
    return
  end

  local fname = vim.fn.expand("%:t")
  if fname == "" then
    fname = "[No Name]"
  end

  vim.opt_local.winbar = "%#WinBar1#%m " .. "%#WinBar2#(" .. buffer_count() .. ") " .. "%#WinBar3#" .. fname .. "%*"
end

-- Update in all the situations splits/windows change
vim.api.nvim_create_autocmd(
  { "WinEnter", "BufEnter", "BufWinEnter", "TabEnter", "VimResized" },
  { callback = set_winbar }
)
