return {
    "barreiroleo/ltex_extra.nvim",
    ft = { "markdown", "tex", "text" },
    dependencies = {"williamboman/mason-lspconfig.nvim"},
    config = function()
      require("ltex_extra").setup({
        load_langs = {"en-US"},
        path = vim.fn.stdpath("config") .. "/spell",
        server_opts = {
          settings = {
            ltex = { language = "en-US" },
          },
          on_attach = function(_, _)
          end,
          capabilities = vim.lsp.protocol.make_client_capabilities(),
        },
      })
    end,
}
