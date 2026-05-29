return {
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = ':TSUpdate',
	config = function()
		require("nvim-treesitter.config").setup({
			highlight = { 
				enable = true, 
				additional_vim_regex_highlighting = false,
			},
			ensure_installed = { 'rust', 'javascript', 'python', 'cpp', 'java' , 'help' , 'lua'},
			sync_install = false,
			auto_install = true,
			incremental_selection = { enable = true },
			indent = { enable = true },
		})
	end,
}
