return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- Mason
		require("mason").setup()

		require("mason-lspconfig").setup({
			ensure_installed = { "clangd" },
		})

		-- Capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Default config for all servers
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- clangd
		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--query-driver=/opt/homebrew/bin/g++,/opt/homebrew/bin/g++-*,/usr/bin/g++",
			},
			filetypes = { "c", "cpp", "objc", "objcpp" },
		})

		-- Enable clangd
		vim.lsp.enable("clangd")

		------------------------------------------------------------------
		-- Toggle LSP
		------------------------------------------------------------------
		local lsp_enabled = true

		vim.keymap.set("n", "<leader>l", function()
			if lsp_enabled then
				-- Disable automatic attachment
				vim.lsp.enable("clangd", false)

				-- Stop all running clients
				for _, client in ipairs(vim.lsp.get_clients()) do
					client:stop(true)
				end

				vim.notify("LSP disabled")
			else
				-- Enable automatic attachment
				vim.lsp.enable("clangd", true)

				-- Attach to current buffer
				vim.cmd("edit")

				vim.notify("LSP enabled")
			end

			lsp_enabled = not lsp_enabled
		end, {
			desc = "Toggle LSP",
			silent = true,
		})
	end,
}
