return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
		{ "<leader><space>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
	},
	config = function()
		require("nvim-web-devicons").setup()
		require("nvim-tree").setup({
			hijack_netrw = true,
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
				side = "left",
			},
			renderer = {
				group_empty = true,
				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
				},
			},
			filters = {
				dotfiles = false,
			},
		})
	end,
}
