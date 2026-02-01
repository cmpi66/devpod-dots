-- ~/.config/nvim/lua/plugins/image.lua
return {
  "3rd/image.nvim",
  lazy = false,
  opts = {
    backend = "kitty",
    processor = "magick_cli", -- use magick_cli unless you prefer luarocks
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = false, -- usually off for local notes
        only_render_image_at_cursor = false,
        only_render_image_at_cursor_mode = "inline",
        floating_windows = false,
        filetypes = { "markdown", "vimwiki", "quarto" },
      },
      neorg = { enabled = false },
      typst = { enabled = false },
      html = { enabled = false },
      css = { enabled = false },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = 60,
    max_height_window_percentage = 50,
    scale_factor = 1.0,
    window_overlap_clear_enabled = false,
    window_overlap_clear_ft_ignore = {
      "cmp_menu",
      "cmp_docs",
      "snacks_notif",
      "scrollview",
      "scrollview_sign",
    },
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = true,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  },
}
