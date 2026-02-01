-- ~/.config/nvim/lua/config/tasks.lua
-- Minimal Markdown task helpers: toggle, quickfix search, and insert snippet.

local M = {}

-- Where to search for tasks (your ZK root). Override via M.setup({root=...}).
M.ROOT = vim.fn.expand("~/.local/.src/zettlekasten")

-- Internal: run ripgrep and load results into the Quickfix list
local function rg_quickfix(pattern, title, cwd)
  cwd = cwd or M.ROOT
  local out = vim.fn.systemlist({
    "rg",
    "--vimgrep",
    "--fixed-strings",
    "-n",
    pattern,
    cwd,
  })
  vim.fn.setqflist({}, " ", { title = title or pattern, lines = out })
  vim.cmd("copen")
end

-- Public: search unchecked tasks ([ ]) into Quickfix
function M.search_unchecked()
  rg_quickfix("[ ]", "Unchecked tasks [ ]")
end

-- Public: search checked tasks ([x]) into Quickfix
function M.search_checked()
  rg_quickfix("[x]", "Checked tasks [x]")
end

-- Public: toggle [ ] <-> [x] on the current line.
-- If no checkbox exists, add one (respecting a leading bullet if present).
function M.toggle_checkbox()
  local line = vim.api.nvim_get_current_line()

  if line:match("%[ %]") then
    line = line:gsub("%[ %]", "[x]", 1)
  elseif line:match("%[x%]") then
    line = line:gsub("%[x%]", "[ ]", 1)
  else
    -- No checkbox yet: insert one
    if line:match("^%s*[-*]%s+") then
      -- Line starts with a bullet -> insert after the bullet
      line = line:gsub("^(%s*[-*]%s+)", "%1[ ] ", 1)
    else
      -- No bullet -> prepend a dash and the box
      line = "- [ ] " .. line
    end
  end

  vim.api.nvim_set_current_line(line)
end

-- Optional: configure the search root
function M.setup(opts)
  opts = opts or {}
  if opts.root then
    M.ROOT = vim.fn.expand(opts.root)
  end

  -- Keymaps (safe to call multiple times)
  -- Toggle checkbox on the current line
  vim.keymap.set("n", "<leader>tt", M.toggle_checkbox, { desc = "Tasks: Toggle checkbox" })

  -- Quickfix searches
  vim.keymap.set("n", "<leader>tu", M.search_unchecked, { desc = "Tasks: Unchecked → Quickfix" })
  vim.keymap.set("n", "<leader>tc", M.search_checked, { desc = "Tasks: Checked → Quickfix" })

  -- Insert-mode snippet: ';;' -> '[ ]' (cursor stays inside the brackets)
  vim.keymap.set("i", ";;", "[]<Left><Space>", { noremap = true, desc = "Insert [ ]" })
end

-- Auto-setup with defaults if required directly
if ... == "config.tasks" then
  M.setup()
end

return M
