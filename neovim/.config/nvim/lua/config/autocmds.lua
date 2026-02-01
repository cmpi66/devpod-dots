-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Highlight yanked text

-- vim.api.nvim_create_autocmd("TextYankPost", {
--   callback = function()
--     vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
--   end,
-- })

-- Start new file in insert mode
vim.cmd("autocmd BufNewFile * startinsert")

-- Delete LaTeX build files on exit
vim.cmd("autocmd VimLeave *.tex !texclear %")

-- Recompile suckless programs after header edit
vim.cmd("autocmd BufWritePost *.h silent !compiler %:p")

-- Compile .tex files to PDF on save
vim.cmd("autocmd BufWritePost *.tex silent !compiler %:p")

-- Highlight zsh files using bash treesitter grammar
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    vim.treesitter.start(0, "bash")
  end,
})

-- Prevent auto-commenting on newline
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
  end,
})

-- Terminal buffers start in insert mode
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "term://*" },
  callback = function()
    vim.cmd("startinsert!")
    vim.cmd("set cmdheight=1")
  end,
})

-- Set keybinds for quick-close buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "Jaq",
    "qf",
    "help",
    "man",
    "lspinfo",
    "spectre_panel",
    "lir",
    "DressingSelect",
    "Markdown",
  },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      nnoremap <silent> <buffer> <esc> :close<CR>
      set nobuflisted
    ]])
  end,
})

-- Disable snacks.nvim temporarily during paste to avoid Treesitter crashes
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if vim.o.paste then
      require("snacks").disable()
    end
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if vim.o.paste then
      vim.defer_fn(function()
        require("snacks").enable()
      end, 100)
    end
  end,
})

-- In your Neovim config:
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.keymap.set("n", "<CR>", function()
      require("config.notes").open_link_under_cursor()
    end, { buffer = true, silent = true, desc = "Open link under cursor" })
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.winbar")
  end,
})
