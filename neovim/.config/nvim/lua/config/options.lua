-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--

local opt = vim.opt

-- UI + Display
opt.termguicolors = true
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = true
opt.laststatus = 3 -- global statusline
opt.showcmd = false
opt.ruler = true
opt.title = true
opt.titlestring = "%<%F%=%l/%L - nvim"
opt.colorcolumn = "99999" -- for indent guides

-- Tabs + Indents
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Behavior
opt.hidden = true
opt.mouse = "a"
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undodir = vim.fn.stdpath("cache") .. "/undo"
opt.undofile = true
opt.timeoutlen = 500
opt.updatetime = 100
opt.fileencoding = "utf-8"

-- Search
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Completion
opt.completeopt = { "menuone", "noselect" }
opt.pumheight = 10

-- Markdown + Visuals
opt.conceallevel = 0 -- adjust in ftplugin/markdown.lua
opt.cmdheight = 1 -- fine with LazyVim, no need to change
opt.spell = false
opt.spelllang = { "en" }

-- GUI font (ignored unless using a GUI like Neovide)
-- opt.guifont = "monospace:h17"

-- need to overide lazyvim winbar
vim.g.lazyvim_winbar = false

-- Example colors (adjust to your palette)
vim.api.nvim_set_hl(0, "WinBar1", { fg = "#7dc4e4", bg = "NONE" }) -- counters / misc
vim.api.nvim_set_hl(0, "WinBar2", { fg = "#c6a0f6", bg = "NONE" }) -- buffer count
vim.api.nvim_set_hl(0, "WinBar3", { fg = "#a6da95", bg = "NONE" }) -- filename

-- Use OSC52 clipboard only when running over SSH / in containers
local function is_remote()
  return vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil or vim.env.DEVPOD ~= nil
end

if is_remote() then
  vim.g.clipboard = {
    name = "OSC52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
else
  -- Local machine: use native clipboard
  vim.opt.clipboard = "unnamedplus"
end
