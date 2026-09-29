-- Useful plugin to show you pending keybinds.

return {
  "folke/which-key.nvim",
  event = "VimEnter",
  opts = {
    icons = {
      mappings = vim.g.have_nerd_font,
      keys = {}
    },
    ---@type false | "classic" | "modern" | "helix"
    preset = "classic",
    spec = {
      { "<leader>c", group = "[C]ode",       mode = { "n", "x" } },
      { "<leader>d", group = "[D]iagnostics" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>w", group = "[W]orkspace" },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>h", group = "Git [H]unk",   mode = { "n", "v" } },
      { "<leader>g", group = "[G]it" },
    },
  },
}
