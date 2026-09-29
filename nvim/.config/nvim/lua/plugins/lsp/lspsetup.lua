function register_keymaps(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- Find references for the word under your cursor.
    map("gr", require("telescope.builtin").lsp_references,
      "[G]oto [R]eferences")

    -- Jump to the definition of the word under your cursor.
    --  To jump back, press <C-t>.
    map("gd", require("telescope.builtin").lsp_definitions,
      "[G]oto [D]efinition")

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an
    --  actual implementation.
    map("gI", require("telescope.builtin").lsp_implementations,
      "[G]oto [I]mplementation")

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
end

function highlight_words_on_rest(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local tdh = vim.lsp.protocol.Methods.textDocument_documentHighlight
    if client and client.supports_method(tdh) then
      local hag = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = hag,
        callback = vim.lsp.buf.document_highlight,
      })

      -- When you move your cursor, the highlights will be cleared.
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = hag,
        callback = vim.lsp.buf.clear_references,
      })

      -- remove leftover highlights or symbols after the LSP client detaches
      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(evt)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = evt.buf })
        end,
      })
    end
end 


function enable_inlayhints(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    local tdi = vim.lsp.protocol.Methods.textDocument_inlayHint
    if client and client.supports_method(tdi) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
    end
end

-- This function gets run when an LSP attaches to a particular buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    -- configure lsp events to keymaps
    register_keymaps(event)
    -- highlight word under cursor
    highlight_words_on_rest(event)
    -- toggle inlay hints
    enable_inlayhints(event)
  end,
})

-- LSP servers and clients are able to communicate to each other what features
-- they support. By default, Neovim doesn't support everything that is in the LSP
-- specification. When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
-- So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local dc = require('cmp_nvim_lsp').default_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, dc)

--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason

require("mason").setup()

-- See `:help lspconfig-all` for a list of all the pre-configured LSPs
local servers = {
  -- clangd = {
  --   cmd = {
  --     "clangd",
  --     "--background-index",
  --     "--clang-tidy",
  --   },
  -- },
  -- denols = {
  --   on_attach = function(client, _)
  --     -- Disable the built-in formatting capabilities of deno
  --     client.server_capabilities.documentFormattingProvider = false
  --     client.server_capabilities.documentRangeFormattingProvider = false
  --   end,
  -- },
  -- hls = {
  --   on_attach = function(client, _)
  --     -- Disable the built-in formatting capabilities of deno
  --     client.server_capabilities.documentFormattingProvider = false
  --     client.server_capabilities.documentRangeFormattingProvider = false
  --   end,
  -- },
  -- pyright = {
  --   settings = {
  --     python = {
  --       analysis = {
  --         autoImportCompletions = true,
  --         typeCheckingMode = "on",
  --         autoSearchPaths = true,
  --         useLibraryCodeForTypes = true,
  --         diagnosticMode = "openFilesOnly",
  --         stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
  --       },
  --     },
  --   },
  -- },
  -- asm_lsp = {},
  -- bashls = {},
  -- cmakelint = {},
  -- cpplint = {},
  -- docker_compose_language_service = {},
  -- dockerls = {},
  -- html = {},
  -- htmlhint = {},
  -- jupytext = {},
  -- lean_language_server = {},
  -- ltex = {},
  -- lua_ls = {},
  -- markdownlint = {},
  -- marksman = {},
  -- neocmake = {},
  -- ocamllsp = {},
  -- prettier = {},
  -- ruff = {},
  -- texlab = {}
}


local ensure_installed = vim.tbl_keys(servers or {})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed})

-- require("mason-lspconfig").setup({
--   handlers = {
--     function(server_name)
--       local server = servers[server_name] or {}
--       -- This handles overriding only values explicitly passed
--       -- by the server configuration above. Useful when disabling
--       -- certain features of an LSP (for example, turning off formatting for ts_ls)
--       server.capabilities = vim.tbl_deep_extend("force", {},
--         capabilities, server.capabilities or {})
--       require("lspconfig")[server_name].setup(server)
--     end,
--   },
-- })


require("mason-lspconfig").setup()

for server_name, server in pairs(servers) do
  server.capabilities = vim.tbl_deep_extend(
    "force",
    {},
    capabilities,
    server.capabilities or {}
  )

  vim.lsp.config(server_name, server)
  vim.lsp.enable(server_name)
end
