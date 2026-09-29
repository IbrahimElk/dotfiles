-- [[ Configure Telescope ]]
--
-- future feature to do:
-- https://www.reddit.com/r/neovim/comments/yqxcxs/how_to_fuzzy_search_contents_then_filter_by/
-- https://github.com/nvim-telescope/telescope.nvim/issues/1080

return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "nvim-tree/nvim-web-devicons",
      enabled = vim.g.have_nerd_font
    },
    { 
      "nvim-telescope/telescope-live-grep-args.nvim" ,
      version = "^1.0.0",
    },
  },
  opts = {
    defaults = {
      -- hidden = true,
      -- no_ignore = true,
      vimgrep_arguments = {
        "rg",
        "--color", "never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--hidden",
        "--no-ignore",
        "--smart-case",
      },
      path_display = { "smart" },
    },
    pickers = {
      find_files = {
        -- prefer fd if you've got it, otherwise fall back to rg
        find_command = vim.fn.executable("fd") == 1 and
          { "fd", "--type", "f", "--hidden", "--no-ignore", "--follow" } or
          { "rg", "--files", "--hidden", "--no-ignore" },
      },
    },
    extensions = {},
  },
  config = function(_, opts)
    -- See `:help telescope` and `:help telescope.setup()`
    local ts = require("telescope")
    opts.extensions["ui-select"] = require("telescope.themes").get_dropdown()
    ts.setup(opts)

    -- Enable Telescope extensions if they are installed
    pcall(ts.load_extension, "fzf")
    pcall(ts.load_extension, "ui-select")

    -- See `:help telescope.builtin`
    local set = vim.keymap.set
    local tsb = require("telescope.builtin")
    set("n", "<leader>sf", tsb.find_files, { desc = "[S]earch [F]iles" })
    set("n", "<leader>sg", tsb.live_grep, { desc = "[S]earch by [G]rep" })
    set("n", "<leader>sr", tsb.resume, { desc = "[S]earch [R]esume" })
    set("n", "<leader><leader>", tsb.buffers, { desc = "[ ] Existing buffers" })

    -- Shortcut for searching through Neovim configuration files
    set("n", "<leader>sn", function()
      tsb.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[S]earch [N]eovim files" })

    -- in order to filter through certain paths when live grepping,
    -- makes searches faster in large repositories
    ts.load_extension("live_grep_args")
    local command = ":lua require('telescope').extensions.live_grep_args"
    local api = ".live_grep_args()<CR>"
    set("n", "<leader>sd", command .. api, { desc = "[S]earch [D]ocs" })
  end,
}
