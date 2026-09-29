-- [[ Setting global variables ]]
-- See `:help vim.g`

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
-- vim.g.clipboard = "osc52"

function _G.format_path()
  local path = vim.fn.expand "%"
  path = path:gsub("oil://", "")
  return "  " .. vim.fn.fnamemodify(path, ":~:.")
end
