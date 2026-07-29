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
		"wtfox/jellybeans.nvim",
		lazy = false,
		priority = 1000,
		opts = {
		},
	},

	-- CyberDream
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
	},

	--LaserWave
	{
		"lettertwo/laserwave.nvim",
		lazy = false,
		priority = 1000,
	},

	--Github 
	{
		'projekt0n/github-nvim-theme',
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
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
					"tokyonight-night",
					"tokyonight-storm",
					"tokyonight-moon",
					"tokyonight-day",
					"rose-pine-main",
					"rose-pine-moon",
					"rose-pine-dawn",
					"github_dark_default",
					"github_dark_dimmed",
					"github_light",
					"jellybeans",
					"jellybeans-muted",
					"jellybeans-mono",
					"jellybeans-hc",
					"jellybeans-mono-light",
					"jellybeans-muted-light",
					"jellybeans-light",
					"cyberdream",
					"laserwave",
				},				
				livePreview = true,
			})
		end,
	},
}
