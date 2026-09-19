return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- 1. Apply Autocomplete Capabilities to ALL servers natively
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- 2. Setup Mason with the modern v2+ API
		require("mason").setup({ ui = { border = "rounded" } })

		require("mason-lspconfig").setup({
			ensure_installed = { "clangd" },
			-- NEW API: Tells mason-lspconfig to automatically run `vim.lsp.enable()`
			-- for any server it ensures is installed.
			automatic_enable = true,
		})

		-- 3. Define Server Configurations (Natively)
		vim.lsp.config("clangd", {
			cmd = {
				vim.fn.stdpath("data") .. "/mason/bin/clangd",
				"--background-index",
				"--clang-tidy=false",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--query-driver=/opt/homebrew/bin/g++-15,/opt/homebrew/bin/g++,/opt/homebrew/bin/gcc-15,/opt/homebrew/bin/gcc",
			},
			filetypes = { "c", "cpp", "objc", "objcpp" },
		})

		vim.lsp.config("sourcekit", {
			cmd = { "sourcekit-lsp" },
			filetypes = { "swift" },
			root_markers = { "Package.swift", ".git" },
		})

		-- Explicitly enable standalone servers that Mason doesn't manage
		vim.lsp.enable("sourcekit")

		-- 4. Toggle Keymap (Updated to modern Neovim commands)
		local lsp_enabled = true
		vim.keymap.set("n", "<leader>l", function()
			if lsp_enabled then
				-- Neovim 0.11+ uses `:lsp disable`, falling back to `:LspStop` if on 0.10
				local cmd = vim.fn.exists(":lsp") == 2 and "lsp disable" or "LspStop"
				vim.cmd(cmd)
				vim.notify("LSP disabled", vim.log.levels.WARN)
			else
				local cmd = vim.fn.exists(":lsp") == 2 and "lsp enable" or "LspStart"
				vim.cmd(cmd)
				vim.notify("LSP enabled", vim.log.levels.INFO)
			end
			lsp_enabled = not lsp_enabled
		end, { desc = "Toggle LSP", silent = true })
	end,
}
