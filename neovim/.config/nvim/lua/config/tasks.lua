-- ~/.config/nvim/lua/config/tasks.lua
-- Markdown task helpers (filetype-driven, not directory-driven)

local M = {}

-- Internal: run ripgrep and load results into Quickfix
local function rg_markdown(pattern, title)
  local out = vim.fn.systemlist({
    "rg",
    "--vimgrep",
    "--fixed-strings",
    "-n",
    "--glob",
    "*.md",
    pattern,
  })

  vim.fn.setqflist({}, " ", {
    title = title or pattern,
    lines = out,
  })
  vim.cmd("copen")
end

function M.search_unchecked()
  rg_markdown("[ ]", "Unchecked tasks [ ] (Markdown)")
end

function M.search_checked()
  rg_markdown("[x]", "Checked tasks [x] (Markdown)")
end

function M.toggle_checkbox()
  local line = vim.api.nvim_get_current_line()

  if line:match("%[ %]") then
    line = line:gsub("%[ %]", "[x]", 1)
  elseif line:match("%[x%]") then
    line = line:gsub("%[x%]", "[ ]", 1)
  else
    if line:match("^%s*[-*]%s+") then
      line = line:gsub("^(%s*[-*]%s+)", "%1[ ] ", 1)
    else
      line = "- [ ] " .. line
    end
  end

  vim.api.nvim_set_current_line(line)
end

return M
