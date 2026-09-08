return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- 1. Capabilities (Applies to all servers natively via wildcard)
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- 2. Setup Mason & ensure installations
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "clangd" },
		})

		-- 3. Define custom configurations for specific servers FIRST
		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--query-driver=/opt/homebrew/bin/g++,/opt/homebrew/bin/g++-*,/usr/bin/g++,/opt/homebrew/bin/gcc,/opt/homebrew/bin/gcc-*",
			},
			filetypes = {  "c", "cpp", "objc", "objcpp" },
		})

		-- Sourcekit (Non-Mason, system installed)
		vim.lsp.config("sourcekit", {
			cmd = { "sourcekit-lsp" },
			filetypes = { "swift" },
			root_markers = { "Package.swift", ".git" },
		})
		vim.lsp.enable("sourcekit")

		-- 4. Automatically enable all Mason-installed servers 
		-- This safely replaces the broken setup_handlers
		local installed_servers = require("mason-lspconfig").get_installed_servers()
		
		for _, server in ipairs(installed_servers) do
			vim.lsp.enable(server)
		end

		------------------------------------------------------------------
		-- Toggle LSP
		------------------------------------------------------------------
		local lsp_enabled = true

		vim.keymap.set("n", "<leader>l", function()
			if lsp_enabled then
				vim.cmd("LspStop")
				vim.notify("LSP disabled")
			else
				vim.cmd("LspStart")
				vim.notify("LSP enabled")
			end

			lsp_enabled = not lsp_enabled
		end, {
			desc = "Toggle LSP",
			silent = true,
		})
	end,
}
