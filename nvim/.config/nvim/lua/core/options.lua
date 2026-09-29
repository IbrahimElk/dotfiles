-- [[ Setting options ]]
-- See `:help vim.opt` or `:help option-list`

-- Enable mouse
vim.opt.mouse = "a"

-- Hide the statusline
vim.opt.laststatus = 0
vim.opt.ruler = true

-- https://github.com/neovim/neovim/issues/28488
vim.api.nvim_set_hl(0 , 'Statusline', {link = 'Normal'})
vim.api.nvim_set_hl(0 , 'StatuslineNC', {link = 'Normal'})
vim.opt.statusline = "%{repeat('─',winwidth('.'))}"

-- Make line numbers default
vim.opt.number = true

-- Add relative line numbers.
vim.opt.relativenumber = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Number of spaces that a <Tab> in the file counts for
vim.opt.tabstop = 2

-- Number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 2

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Break wrapped lines at word edge
vim.opt.linebreak = true

-- Save undo history
vim.opt.undofile = true

-- Ignore case when searching a pattern
vim.opt.ignorecase = true

-- Ignore case when the pattern contains lowercase letters only.
vim.opt.smartcase = true

-- Preview substitutions as you type.
vim.opt.inccommand = "split"

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Open a new buffer without creating a swap file for it
vim.opt.swapfile = false

-- Decrease keymap sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'` and `:help 'listchars'`
vim.opt.list = true
-- vim.opt.listchars = { trail = '·', nbsp = '␣' }
vim.opt.listchars = { space = '·', tab = '→ ', trail = '•' }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- the listing continues until finished.
-- i.e. no "press any key or ENTER to continue"
-- vim.opt.more = false 
