vim.g.rustaceanvim = {
	server = {
		on_attach = function(client, bufnr)
			-- Disable the built-in formatting capabilities
			-- of rust-analyzer
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
	},
}

return {
	{
		'mrcjkb/rustaceanvim',
		version = '^5', -- Recommended
		lazy = false, -- This plugin is already lazy

	}
}
