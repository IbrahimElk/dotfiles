return {
	{
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
      highlight = {
        keyword = "bg",
        pattern = [[.*<(KEYWORDS)\s*\(.*\)]],
      },
      -- search = {
      --   pattern = [[\b(KEYWORDS)\s*\(.*\)]],
      -- },
    },
  },
}
