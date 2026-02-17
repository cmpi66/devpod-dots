local function wordcount()
  local word_count = 0
  if vim.fn.mode():find("[vV]") then
    word_count = vim.fn.wordcount().visual_words
  else
    word_count = vim.fn.wordcount().words
  end
  return word_count .. " words"
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {
          {
            wordcount,
            cond = function()
              return vim.bo.filetype == "markdown" or vim.bo.filetype == "text"
            end,
          },
        },
      },
    },
  },
}
