return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = nil,
      formatters_by_ft = {
        -- markdown = { "markdownlint" },
        -- lua = { "stylua" },
        -- python = { "ruff" },
        -- json = { "prettier" },
        -- javascript = { "prettier" },
        -- cpp = {}, -- "clang-format"
        -- rust = {}, -- "clang-format"
      },
    },
  },
}
