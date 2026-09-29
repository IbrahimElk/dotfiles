-- next feature:
-- change directory within oil, without leaving nvim
-- https://github.com/stevearc/oil.nvim/issues/160

return {
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- Send deleted files to the trash instead of permanently deleting them
      -- (:help oil-trash)
      delete_to_trash = false,
      -- Skip the confirmation popup for simple operations 
      -- (:help oil.skip_confirm_for_simple_edits)
      skip_confirm_for_simple_edits = true,
      -- See :help oil-actions for a list of all available actions
      keymaps = {
        ["<CR>"]  = "actions.select",
        ["q"]     = "actions.close",
        ["g."] 	  = "actions.toggle_hidden",
        ["gp"]    = "actions.preview",
        ["gl"]    = "actions.refresh",
        ["gs"]    = { "actions.change_sort", mode = "n" },
        ["g?"] 	  = { "actions.show_help",   mode = "n" },
        ["-"]     = { "actions.parent",      mode = "n" },
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = false,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
      win_options = {
        signcolumn = "number",
      },
    },
    config = function(_, opts)
			require("oil").setup(opts)
    	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end
  },
}
