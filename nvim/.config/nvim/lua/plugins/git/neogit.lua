return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration
    "nvim-telescope/telescope.nvim", -- optional
  },
  opts = {
    kind = "replace",
    graph_style = "kitty",
  },
  config = function(_, opts)
    require("neogit").setup(opts)
    vim.keymap.set('n', '<leader>gg', ':Neogit<CR>',
      { desc = "[G]it: Neo[G]it" })
  end
}
