-- https://github.com/mhinz/vim-startify#options

-- https://github.com/mhinz/vim-startify/issues/387
vim.g.startify_change_to_dir = 0

local setup_startify = function()
	vim.g['startify_lists'] = {
		{ type = 'dir', header = { '   Recent in ' .. vim.fn.getcwd() } },
	}
end

return {
	'mhinz/vim-startify',
	-- event = 'VimEnter',
	init = setup_startify,
}
