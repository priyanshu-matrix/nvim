return {
	-- =========================================================================
	-- INSTALLED THEMES
	-- =========================================================================

	-- Tokyo Night
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},

	-- Rose Pine
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
	},

	-- Jellybeans
	{
		"metalelf0/jellybeans-nvim",
		lazy = false,
		priority = 1000,
		dependencies = {
			"rktjmp/lush.nvim",
		},
	},

	-- =========================================================================
	-- THEMERY GUI Theme Switcher
	-- =========================================================================
	{
		"zaldih/themery.nvim",
		lazy = false,
		config = function()
			require("themery").setup({
				themes = {
					"tokyonight",
					"rose-pine",
					"jellybeans-nvim",
				},
				livePreview = true,
			})
		end,
	},
}
