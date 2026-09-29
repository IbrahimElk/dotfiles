-- [[ Initialize lazy.nvim ]]
-- See `:help lazy.nvim.txt`

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded
require "core.globals"
require "core.options"
require "core.keymaps"
require "core.autocmds"
require "core.diagnostics"

-- bootstrap `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- add lazy to the runtime path. The rtp is searched when executing `require`.
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Add plugin by file instead of importing folder
    -- makes it easier to comment out certain plugins if needed

    { import = "plugins.editor.image" },
    { import = "plugins.editor.oil" },
    { import = "plugins.editor.startify" },
    -- { import = "plugins.editor.vimtest" },
    -- { import = "plugins.editor.dev_container" },

    { import = "plugins.git.gitsigns" },
    { import = "plugins.git.neogit" },

    -- { import = "plugins.lang.jupyter" },
    { import = "plugins.lang.rust" },
    { import = "plugins.lang.scala" },
    { import = "plugins.lang.vimtex" },
    { import = "plugins.lang.sql" },
    { import = "plugins.lang.python" },

    { import = "plugins.lsp.cmp" },
    { import = "plugins.lsp.format" },
    { import = "plugins.lsp.gitcmp" },
    { import = "plugins.lsp.lazydev" },
    { import = "plugins.lsp.lint" },
    { import = "plugins.lsp.lspconfig" },
    -- { import = "plugins.lsp.ltex_extra" },

    { import = "plugins.text.autopairs" },
    { import = "plugins.text.indent_line" },
    { import = "plugins.text.mini" },
    { import = "plugins.text.todo" },
    -- { import = "plugins.text.treesitter" },
    { import = "plugins.text.ledger" },

    { import = "plugins.ui.colorscheme" },
    { import = "plugins.ui.telescope" },
    { import = "plugins.ui.trouble" },
    { import = "plugins.ui.which_key" },
  },
})
