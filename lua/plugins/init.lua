vim.opt.autochdir = true

return {
	require("plugins.telescope"),
	require("plugins.compitest"),
	require("plugins.matchBrace"),
	require("plugins.commentapi"),
	require("plugins.snippet"),
	require("plugins.treeSitter"),
	require("plugins.mason"),
	require("plugins.formatter"),
	require("plugins.autocomp"),
	require("plugins.lspconfig"),
	require("plugins.alpha"),
	require("plugins.themes"),
	require("plugins.debugger"),
	require("plugins.nvim-tree"),
	require("plugins.leetcode"),
	vim.tbl_extend("force", require("plugins.smearcurs"), {
		keys = {
			{
				"<leader>fc",
				function()
					require("smear_cursor").toggle()
				end,
				desc = "Toggle Smear Cursor",
			},
			{
				"<leader>fcf",
				function()
					require("smear_cursor").toggle_particles()
				end,
				desc = "Toggle Fire Animation",
			},
		},
	}),
}
