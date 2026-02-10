return {

  { "akinsho/bufferline.nvim", enabled = false },
  { "linux-cultist/venv-selector.nvim", enabled = false }, -- not needed right now, maybe future
  { "folke/persistence.nvim", enabled = false }, -- dashboard gone, not useful, and wasnt using it anyway
  { "windwp/nvim-ts-autotag", enabled = false }, -- I dont work with html
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      scroll = { enabled = false },
      dashboard = { enabled = false },
    },
  },
}
