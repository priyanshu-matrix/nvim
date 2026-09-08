return {
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
	},

	-- CyberDream
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
	},

	--Github 
	{
		'projekt0n/github-nvim-theme',
		lazy = false,
		priority = 1000,
	},

	--Monchrome
	{
		"kdheepak/monochrome.nvim",
		lazy = false,
		priority = 1000,
	},

	--Gruvbox
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = true,
	},

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
					"jellybeans-muted",
					"jellybeans-mono",
					"jellybeans-hc",
					"jellybeans-mono-light",
					"jellybeans-muted-light",
					"jellybeans-light",
					"gruvbox",
					"cyberdream",
					"catppuccin",
					"monochrome"
				},				
				livePreview = true,
			})
		end,
	},
}
