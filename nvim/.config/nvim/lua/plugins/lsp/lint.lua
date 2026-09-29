return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      -- python = { "ruff" },
      -- markdown = { "markdownlint" },
      -- cpp = { "cpplint" },
      -- python = { "pyright" },
      -- hs = { "hlint" },
    }
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function(args)
        -- Skip linting for floating windows or scratch buffers
        local win_cfg = vim.api.nvim_win_get_config(0)
        if win_cfg.relative ~= "" or vim.bo[args.buf].buftype ~= "" then
          return
        end
        require("lint").try_lint()
      end,
    })
  end,
}

