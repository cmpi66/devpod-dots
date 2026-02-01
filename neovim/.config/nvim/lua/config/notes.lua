-- ~/.config/nvim/lua/config/notes.lua
-- Flexible ZK helpers for a whole tree (supports subdirs, wikilinks, md links)
local M = {}

-- ----- CONFIG -----
local ROOT = vim.fn.expand("~/.local/.src/zettlekasten")

-- normalize dir to have exactly one trailing slash
local function norm_dir(p)
  p = vim.fn.fnamemodify(p, ":p")
  return (p:gsub("/+$", "")) .. "/"
end

local ROOTP = norm_dir(ROOT)

-- random 4-char id
local function random_id()
  local charset = "abcdefghijklmnopqrstuvwxyz0123456789"
  local id = {}
  for _ = 1, 4 do
    local r = math.random(#charset)
    table.insert(id, charset:sub(r, r))
  end
  return table.concat(id)
end

local function path_join(a, b)
  if b:match("^/") then
    return b
  end
  if a:sub(-1) == "/" then
    return a .. b
  end
  return a .. "/" .. b
end

-- patched: correctly strips ROOT prefix without chopping first char
local function rel_to_root(abs)
  abs = vim.fn.fnamemodify(abs, ":p")
  abs = abs:gsub("/+$", "")
  -- compare against ROOTP without the trailing slash
  if abs:sub(1, #ROOTP - 1) == ROOTP:sub(1, -2) then
    local rel = abs:sub(#ROOTP + 1)
    return rel
  end
  return abs
end

local function top_level(relpath)
  local first = relpath:match("([^/]+)")
  return first or relpath
end

local function ensure_file(path)
  if vim.fn.filereadable(path) == 0 then
    local f = io.open(path, "w")
    if f then
      f:write("# " .. vim.fn.fnamemodify(path, ":t:r") .. "\n\n")
      f:close()
    end
  end
end

-- Append a link line under a "## <section_header>" in some landing file
local function append_link_to_section(filepath, section_header, link_line)
  local lines, found, inserted = {}, false, false
  local f = io.open(filepath, "r")
  if f then
    for line in f:lines() do
      table.insert(lines, line)
      if line:lower():match("^##%s+" .. section_header:lower() .. "%s*$") then
        found = true
      elseif found and not inserted and (line:match("^%s*$")) then
        table.insert(lines, link_line)
        inserted = true
      end
    end
    f:close()
  end
  if not found then
    table.insert(lines, "")
    table.insert(lines, "## " .. section_header)
  end
  if not inserted then
    table.insert(lines, link_line)
  end
  local out = io.open(filepath, "w")
  for _, l in ipairs(lines) do
    out:write(l .. "\n")
  end
  out:close()
end

-- Recursively find a note by basename stem (e.g., "ab12-my-note")
local function find_note_by_stem(stem)
  if vim.fn.executable("rg") == 1 then
    local cmd = ("rg -l -g '**/%s.md' -m1 '' %s"):format(vim.fn.shellescape(stem), vim.fn.shellescape(ROOT))
    local h = io.popen(cmd)
    if h then
      local path = h:read("*l")
      h:close()
      if path and vim.fn.filereadable(path) == 1 then
        return path
      end
    end
  end
  local cmd = ("find %s -type f -name %s.md 2>/dev/null"):format(vim.fn.shellescape(ROOT), vim.fn.shellescape(stem))
  local h = io.popen(cmd)
  if h then
    local path = h:read("*l")
    h:close()
    if path then
      return path
    end
  end
  return nil
end

-- ----- PUBLIC API -----

function M.new_note(dir)
  dir = dir or ROOT
  dir = vim.fn.expand(dir)
  if dir:sub(1, #ROOT) ~= ROOT then
    vim.notify("new_note dir must be under " .. ROOT, vim.log.levels.ERROR)
    return
  end

  local title = vim.fn.input("Title: ")
  if title == "" then
    return
  end

  local id = random_id()
  local safe = title:gsub("[^%w%s%-]", ""):gsub("%s+", "-"):lower()
  local filename = ("%s-%s.md"):format(id, safe)
  local path = path_join(dir, filename)

  vim.cmd("e " .. path)

  local rel_dir = rel_to_root(dir)
  local toplev = top_level(rel_dir)

  local tags = { toplev }
  if rel_dir and rel_dir ~= "" and rel_dir ~= toplev then
    table.insert(tags, rel_dir)
  end

  local header = {
    "---",
    "tags: [" .. table.concat(tags, ", ") .. "]",
    "---",
    "",
    "# " .. title,
    "",
  }
  vim.api.nvim_buf_set_lines(0, 0, 0, false, header)

  local landing = path_join(ROOT, toplev .. ".md")
  ensure_file(landing)

  local section = (rel_dir == toplev) and "links" or rel_dir
  local stem = filename:gsub("%.md$", "")
  local link_line = string.format("[[%s]]", stem)
  append_link_to_section(landing, section, link_line)

  vim.notify("Created: " .. rel_to_root(path), vim.log.levels.INFO)
end

function M.search_backlinks()
  local stem = vim.fn.expand("%:t:r")
  local query = "%[%[" .. stem:gsub("(%W)", "%%%1") .. "%]%]"
  require("snacks").picker("grep", {
    default_text = query,
    cwd = ROOT,
  })
end

function M.search_visual()
  local selected = vim.fn.getreg("v")
  require("snacks").picker("grep", { default_text = selected, cwd = ROOT })
end

function M.insert_link()
  require("snacks").picker("files", {
    cwd = ROOT,
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        local entry = require("snacks").get_selected_entry(prompt_bufnr)
        local name = vim.fn.fnamemodify(entry.value, ":t:r")
        vim.api.nvim_put({ string.format("[[%s]]", name) }, "", true, true)
        require("snacks.actions").close(prompt_bufnr)
      end)
      return true
    end,
  })
end

function M.open_link_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  -- Wikilink [[...]]
  local wi_s, wi_e = line:find("%[%[[^%]]+%]%]")
  if wi_s and col >= wi_s and col <= wi_e then
    local stem = line:sub(wi_s + 2, wi_e - 2)
    local f = find_note_by_stem(stem)
    if f then
      vim.cmd("edit " .. f)
      return
    end
    vim.notify("Not found: " .. stem .. ".md", vim.log.levels.WARN)
    return
  end

  -- Markdown link [text](url)
  local idx, s, e = 1, nil, nil
  while true do
    local ps, pe = line:find("%b()", idx)
    if not ps then
      break
    end
    if col >= ps and col <= pe then
      s, e = ps, pe
      break
    end
    idx = pe + 1
  end
  if s and e then
    local url = line:sub(s + 1, e - 1):gsub("^%s*<", ""):gsub(">%s*$", "")
    url = url:gsub("#.+$", "")
    if url == "" then
      return
    end

    -- Delegate non-.md targets (e.g., images) to zimg viewer; else open file
    if not url:match("%.md$") then
      local ok, zimg = pcall(require, "config.zimg")
      if ok then
        local abs = url:match("^/") and url or path_join(vim.fn.expand("%:p:h"), url)
        zimg.open_file(abs)
      else
        local abs = path_join(vim.fn.expand("%:p:h"), url)
        if vim.fn.filereadable(abs) == 1 then
          vim.cmd("edit " .. abs)
        else
          vim.notify("File not found: " .. rel_to_root(abs), vim.log.levels.WARN)
        end
      end
      return
    end

    -- .md targets: try relative, then search by stem under ROOT
    local base = vim.fn.expand("%:p:h")
    local abs = url:match("^/") and url or path_join(base, url)
    if vim.fn.filereadable(abs) == 0 then
      local stem = vim.fn.fnamemodify(url, ":t:r")
      local f = find_note_by_stem(stem)
      abs = f or abs
    end
    if abs and vim.fn.filereadable(abs) == 1 then
      vim.cmd("edit " .. abs)
      return
    else
      vim.notify("File not found: " .. url, vim.log.levels.WARN)
      return
    end
  end

  -- Fallback to gf
  vim.cmd("normal! gf")
end

function M.launch_top7()
  local tmp = {}
  local cmd = "bash -lc "
    .. vim.fn.shellescape(([[find %s -type f -name '*.md' -exec stat -c '%%Y %%n' {} \; 2>/dev/null]]):format(ROOT))
  local h = io.popen(cmd)
  if h then
    for line in h:lines() do
      table.insert(tmp, line)
    end
    h:close()
  end
  table.sort(tmp, function(a, b)
    local a_ts = tonumber(a:match("^(%d+)")) or 0
    local b_ts = tonumber(b:match("^(%d+)")) or 0
    return a_ts > b_ts
  end)
  local entries = {}
  for i = 1, math.min(7, #tmp) do
    local _, path = tmp[i]:match("^(%d+)%s+(.+)$")
    table.insert(entries, rel_to_root(path))
  end
  vim.ui.select(entries, { prompt = "Top 7 Recent Notes:" }, function(choice)
    if not choice then
      return
    end
    vim.cmd("edit " .. path_join(ROOT, choice))
  end)
end

return M
