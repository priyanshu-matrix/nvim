return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},

	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		vim.lsp.config("clangd", {
			capabilities = capabilities,

			cmd = {
				"/opt/homebrew/opt/llvm/bin/clangd",
				"--query-driver=/Library/Developer/CommandLineTools/usr/bin/clang++",
			},

			filetypes = { "c", "cpp", "objc", "objcpp" },
		})

		vim.lsp.enable("clangd")
	end,
}
