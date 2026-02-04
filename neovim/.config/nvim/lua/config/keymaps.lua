local opts = { noremap = true, silent = false }

local notes = require("config.notes")
local tasks = require("config.tasks")

-- ── Create notes ────────────────────────────────────────────────────────────────
-- New note in the *current* directory (recommended default)
vim.keymap.set("n", "<leader>zn", function()
  notes.new_note(vim.fn.expand("%:p:h"))
end, { desc = "Notes: New note (here)" })

-- Convenience creators (keep if you still want quick drops in these dirs)
vim.keymap.set("n", "<leader>zf", function()
  notes.new_note("~/.local/.src/zettlekasten/fleeting")
end, { desc = "Notes: New Fleeting note" })

vim.keymap.set("n", "<leader>zp", function()
  notes.new_note("~/.local/.src/zettlekasten/permanent")
end, { desc = "Notes: New Permanent note" })

vim.keymap.set("n", "<leader>zl", function()
  notes.new_note("~/.local/.src/zettlekasten/literature")
end, { desc = "Notes: New Literature note" })

-- ── Linking / search (Snacks) ──────────────────────────────────────────────────
vim.keymap.set("n", "<leader>zb", notes.search_backlinks, { desc = "Notes: Backlinks to current" })
vim.keymap.set("v", "<leader>zg", notes.search_visual, { desc = "Notes: Grep visual selection" })
vim.keymap.set("n", "<leader>zi", notes.insert_link, { desc = "Notes: Insert [[wikilink]]" })

-- Browse all notes (files picker rooted at ZK root)
vim.keymap.set("n", "<leader>zo", function()
  require("snacks").picker("files", { cwd = "~/.local/.src/zettlekasten" })
end, { desc = "Notes: Open note by file" })

-- Grep across entire ZK
vim.keymap.set("n", "<leader>zs", function()
  require("snacks").picker("grep", { cwd = "~/.local/.src/zettlekasten" })
end, { desc = "Notes: Search contents" })

-- Recent notes:
-- Option A: curated Top 7 (uses mtime across all subdirs)
vim.keymap.set("n", "<leader>z7", notes.launch_top7, { desc = "Notes: Top 7 recent (all dirs)" })

vim.keymap.set("n", "<leader>tt", tasks.toggle_checkbox, { desc = "Tasks: Toggle checkbox" })
vim.keymap.set("n", "<leader>tu", tasks.search_unchecked, { desc = "Tasks: Unchecked → Quickfix" })
vim.keymap.set("n", "<leader>tc", tasks.search_checked, { desc = "Tasks: Checked → Quickfix" })
vim.keymap.set("i", ";;", "[]<Left><Space>", { desc = "Insert [ ] checkbox" })

vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Better Yanking to system clipboard
vim.keymap.set({ "n", "v" }, "y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "Y", [["+Y]], { desc = "Yank line to system clipboard" })

vim.keymap.set("n", "<leader>Y", 'gg"+yG', { desc = "Yank Entire File" })
vim.keymap.set("n", "<leader>P", "o<ESC>Pk", { desc = "Paste Line Above" })

vim.keymap.set("n", "<leader>D", "''_d", { desc = "Delete (No Yank)" })
vim.keymap.set("v", "<leader>D", "''_d", { desc = "Delete (No Yank)" })

vim.keymap.set("n", "<leader>X", ":!chmod +x %<CR>", { desc = "Make script executable" })
vim.keymap.set("n", "<leader>C", ":w<CR>:!compiler %:p<CR><CR>", { desc = "Doc Compiler", silent = true })
vim.keymap.set("n", "<leader>o", ":!opout <c-r>%<CR><CR>", { desc = "opout", silent = true })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "open up oil parent dir" })
vim.keymap.set("n", "<leader>-", require("oil").toggle_float)

-- overriding snacks picker
vim.keymap.set("n", "<leader>fb", function()
  require("snacks").picker.buffers({
    preview = false,
    layout = {
      layout = {
        relative = "editor",
        position = "float",
        width = 60,
        height = 11, -- +1 row for input
        border = "rounded",
        box = "vertical",

        {
          win = "input",
          height = 1,
          border = "none",
        },

        {
          win = "list",
          border = "none",
        },
      },
    },
  })
end, { desc = "Buffers (ui.select + search)" })
