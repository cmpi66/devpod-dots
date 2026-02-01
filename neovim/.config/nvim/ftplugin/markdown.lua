vim.keymap.set("n", "<CR>", function()
  local line = vim.fn.getline(".")
  local col = vim.fn.col(".")
  local path

  -- Try to match [[wikilink]]
  local link = line:match("%[%[(.-)%]%]")
  if link then
    path = link
  else
    -- Try to match [text](path)
    local _, _, md_link = line:find("%[.-%]%((.-)%)")
    if md_link then
      path = md_link
    end
  end

  if not path then
    vim.notify("No valid link found on line", vim.log.levels.WARN)
    return
  end

  local fullpath = vim.fn.expand("~/.local/.src/zettlekasten/" .. path)
  if vim.fn.filereadable(fullpath) == 1 then
    vim.cmd("edit " .. fullpath)
  else
    -- Try to match filename without .md
    local stem = path:gsub("%.md$", "")
    local handle = io.popen("fd --type f --extension md . ~/.local/.src/zettlekasten")
    if not handle then
      return
    end

    for file in handle:lines() do
      if vim.fn.fnamemodify(file, ":t:r") == stem then
        vim.cmd("edit " .. file)
        handle:close()
        return
      end
    end

    handle:close()
    vim.notify("Note not found: " .. path, vim.log.levels.WARN)
  end
end, { buffer = true, desc = "Follow Markdown or Wikilink" })
