return {
  {
    "3rd/image.nvim",
    config = function()
      local image = require("image")

      ---@diagnostic disable-next-line: missing-fields
      image.setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            -- markdown extensions (ie. quarto) can go here
            filetypes = { "markdown", "quarto" },
          },
        },
        max_width = 100,
        max_height = 12,

        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        -- toggles images when windows are overlapped
        window_overlap_clear_enabled = true,
        -- auto show/hide images when the editor gains/looses focus
        editor_only_render_when_focused = true,
        -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        tmux_show_only_in_active_window = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "fidget", "" },
      })
    end,
  },
  { "3rd/diagram.nvim", dependencies = { "image.nvim" }, enabled = true, opts = {} },
}
