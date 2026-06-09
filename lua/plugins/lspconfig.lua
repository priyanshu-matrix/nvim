return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- 1. Initialize Mason & Mason-LSPConfig
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "clangd" },
		})

		-- 2. Pull the completion capabilities from your cmp setup
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- 3. The Global Wildcard: Applies capabilities to EVERY single LSP
		-- you install via Mason completely hands-free.
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- 4. Specific Override for clangd
		-- We use "clangd" directly now because Mason adds its own binaries
		-- to your path automatically—no more hardcoded Homebrew paths.
		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--query-driver=/Library/Developer/CommandLineTools/usr/bin/clang++",
			},
			filetypes = { "c", "cpp", "objc", "objcpp" },
		})

		-- Manually kickstart clangd execution
		vim.lsp.enable("clangd")
	end,
}
