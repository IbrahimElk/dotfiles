function setup_cmp()
    local ncmp = require("cmp")
    local luasnip = require("luasnip")
    luasnip.config.setup({})
    
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    
    ncmp.setup({
        sources = {
            {
                name = "lazydev",
                -- set group index to 0 to skip loading LuaLS completions
                -- as lazydev recommends it
                group_index = 0,
            },
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "path" },
    	    { name = "git" }
        },
        -- https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        mapping = ncmp.mapping.preset.insert({
            ["<Tab>"]   = ncmp.mapping.select_next_item(),
            ["<S-Tab>"] = ncmp.mapping.select_prev_item(),
            ["<CR>"]    = ncmp.mapping.confirm({ select = true })
        }),
        -- Enable luasnip to handle snippet expansion for nvim-cmp
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
    
    })
    
    -- Setup up vim-dadbod
    ncmp.setup.filetype({ "sql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })

    -- Setup git_cmp which is a source for cmp under the name `git`.
    require("cmp_git").setup()
end

return {
    {
    	"hrsh7th/nvim-cmp",
    	event = "InsertEnter",
        dependencies = 
        {
    	    "hrsh7th/cmp-path",
    	    "hrsh7th/cmp-nvim-lsp",
    	    "saadparwaiz1/cmp_luasnip",
    	    { 
    	        "L3MON4D3/LuaSnip",
    	        build = "make install_jsregexp" 
    	    },
    	},
    	config = function()
			setup_cmp()
    	end,
    },
}
