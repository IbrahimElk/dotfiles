vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.conceallevel = 2

-- Set the comment string for C++ files to // instead of /* */
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.opt_local.commentstring = "// %s"
  end,
})

