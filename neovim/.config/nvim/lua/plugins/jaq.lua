return {
  "is0n/jaq-nvim",
  config = function()
    require("jaq-nvim").setup({
      cmds = {
        default = "term",
        external = {
          typescript = "deno run %",
          javascript = "node %",
          python = "python %",
          java = "java %",
          rust = "cargo run",
          cpp = "g++ % -o $fileBase && ./$fileBase",
          go = "go run %",
          sh = "sh %",
        },
        internal = {
          -- Uncomment if desired
          -- lua = "luafile %",
          -- vim = "source %",
        },
      },
      behavior = {
        default = "terminal",
        startinsert = false,
        wincmd = false,
        autosave = false,
      },
      ui = {
        float = {
          border = "none",
          height = 0.8,
          width = 0.8,
          x = 0.5,
          y = 0.5,
          border_hl = "FloatBorder",
          float_hl = "Normal",
          blend = 0,
        },
        terminal = {
          position = "vert",
          line_no = false,
          size = 60,
        },
      },
    })

    -- Keymap: Alt+e to run Jaq in focused buffer
    vim.keymap.set("n", "<M-e>", ":silent only | Jaq<CR>", { noremap = true, silent = true })
  end,
}
