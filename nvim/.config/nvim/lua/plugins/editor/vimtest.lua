vim.g["test#neovim#start_normal"] = 1 -- If using the "neovim" strategy

return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux"
  },
  config = function()
    vim.keymap.set("n", "<leader>ct", ":TestNearest<CR>",
      { desc = "[C]ode [T]est nearest" })

    vim.keymap.set("n", "<leader>cT", ":TestFile<CR>",
      { desc = "[C]ode [T]est file" })

    vim.keymap.set("n", "<leader>cs", ":TestSuite<CR>",
      { desc = "[C]urrent [S]uite" })

    vim.keymap.set("n", "<leader>cl", ":TestLast<CR>",
      { desc = "[C]urrent [L]ast test" })

    vim.keymap.set("n", "<leader>cv", ":TestVisit<CR>",
      { desc = "[C]urrent [V]isit test file" })

    -- alternatives: vimux | neovim | neovim_sticky
    vim.cmd("let test#strategy = 'neovim'")
  end,
}
