-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- set window-local winbar to relative file path
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
  callback = function(args)
    -- Check if the window is a floating window
    -- https://github.com/neovim/neovim/issues/19464
    if vim.api.nvim_win_get_config(0).relative ~= "" then
      return
    end

    -- Skip setting winbar if the buffer is a terminal
    if vim.api.nvim_buf_get_option(args.buf, 'buftype') == 'terminal' then
      return
    end

    local buf_path = vim.api.nvim_buf_get_name(args.buf)
    buf_path = buf_path:gsub("oil://", "")
    local winbar = "  " .. vim.fn.fnamemodify(buf_path, ":~:.")
    vim.wo.winbar = winbar
  end
})
