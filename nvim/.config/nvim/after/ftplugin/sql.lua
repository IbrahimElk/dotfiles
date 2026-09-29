-- Set the comment string for sql files to --
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    vim.opt_local.commentstring = "-- %s"
  end,
})
