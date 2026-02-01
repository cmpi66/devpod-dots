-- ~/.config/nvim/lua/config/zimg.lua
-- Wayland image helpers for Vim/Neovim + foot (no inline images)

local M = {}

-- choose your viewer (imv or swayimg); imv is default
local VIEWER = os.getenv("ZIMG_VIEWER") or "imv"

-- open an image file in the external viewer (detached job)
local function spawn_viewer(path)
  if vim.fn.executable(VIEWER) ~= 1 then
    vim.notify(("Viewer '%s' not found (set ZIMG_VIEWER or install imv)"):format(VIEWER), vim.log.levels.ERROR)
    return
  end
  vim.fn.jobstart({ VIEWER, path }, { detach = true })
end

-- get markdown image path under cursor: ![alt](path)
local function md_image_at_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  -- find the (...) segment that contains the cursor
  local i, s, e = 1, nil, nil
  while true do
    local ps, pe = line:find("%b()", i)
    if not ps then
      break
    end
    if col >= ps and col <= pe then
      s, e = ps, pe
      break
    end
    i = pe + 1
  end
  if not (s and e) then
    return nil
  end

  local url = line:sub(s + 1, e - 1):gsub("^%s*<", ""):gsub(">%s*$", "")
  if url == "" then
    return nil
  end
  return url
end

-- turn possibly-relative path into absolute (relative to current file)
local function to_abs(path)
  if path:match("^/") then
    return path
  end
  return vim.fn.expand("%:p:h") .. "/" .. path
end

-- basic image extension check
local function is_image(path)
  return path:lower():match("%.png$")
    or path:lower():match("%.jpe?g$")
    or path:lower():match("%.webp$")
    or path:lower():match("%.gif$")
    or path:lower():match("%.bmp$")
    or path:lower():match("%.tiff?$")
end

-- Public: open the markdown image under cursor in the viewer
function M.open_image_under_cursor()
  local p = md_image_at_cursor()
  if not p then
    vim.notify("No Markdown image link under cursor", vim.log.levels.WARN)
    return
  end
  local abs = to_abs(p)
  if vim.fn.filereadable(abs) == 0 then
    vim.notify("Image not found: " .. abs, vim.log.levels.ERROR)
    return
  end
  if not is_image(abs) then
    vim.notify("Not an image: " .. abs, vim.log.levels.WARN)
    return
  end
  spawn_viewer(abs)
end

-- Public: capture a region screenshot, optional annotate, save into ./screenshots, insert markdown link
-- Requires: grim, slurp; optional: satty, wl-clipboard
function M.insert_screenshot(opts)
  opts = opts or {}
  local annotate = opts.annotate ~= false -- default true
  local dir = vim.fn.expand("%:p:h") .. "/screenshots"
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local fname = os.date("%Y-%m-%d-%H%M%S") .. ".png"
  local abs = dir .. "/" .. fname
  local rel = "./screenshots/" .. fname

  local cmd
  if annotate and vim.fn.executable("satty") == 1 then
    -- grim -> satty (annotate) -> save; also copy to clipboard if wl-clipboard present
    cmd = ([[bash -lc 'grim -g "$(slurp)" - | satty -f - -o %q %s']]):format(
      abs,
      (vim.fn.executable("wl-copy") == 1) and ([[--copy-command "wl-copy < %q"]]):format(abs) or ""
    )
  else
    -- plain capture
    cmd = ([[bash -lc 'grim -g "$(slurp)" %q']]):format(abs)
  end

  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code == 0 and vim.fn.filereadable(abs) == 1 then
        local row = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, row, row, false, { ("![screenshot](%s)"):format(rel) })
        vim.notify("Saved screenshot: " .. rel, vim.log.levels.INFO)
      else
        vim.notify("Screenshot failed", vim.log.levels.ERROR)
      end
    end,
  })
end

-- Public: open any file path with viewer if image, else edit in nvim
function M.open_file(path)
  local abs = to_abs(path)
  if is_image(abs) then
    if vim.fn.filereadable(abs) == 1 then
      spawn_viewer(abs)
    else
      vim.notify("Image not found: " .. abs, vim.log.levels.ERROR)
    end
  else
    if vim.fn.filereadable(abs) == 1 then
      vim.cmd("edit " .. abs)
    else
      vim.notify("File not found: " .. abs, vim.log.levels.ERROR)
    end
  end
end

return M
