return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		----------------------------------------------------------------------
		-- 1. GLOBAL CAPABILITIES
		-- Informs the language servers about Neovim's autocomplete support
		----------------------------------------------------------------------
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Apply these capabilities natively to ALL servers
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		----------------------------------------------------------------------
		-- 2. MASON SETUP
		-- Manage external tooling installations (LSP servers, formatters)
		----------------------------------------------------------------------
		require("mason").setup({
			ui = { border = "rounded" }, -- Optional: Makes the Mason window look cleaner
		})

		require("mason-lspconfig").setup({
			ensure_installed = { "clangd" },
		})

		----------------------------------------------------------------------
		-- 3. SERVER-SPECIFIC CONFIGURATIONS
		-- Define custom behavior for individual servers BEFORE enabling them
		----------------------------------------------------------------------

		-- Clangd (C / C++ / Objective-C)
		vim.lsp.config("clangd", {
			cmd = {
				-- Force Neovim to use Mason's clangd instead of Apple's system clangd
				vim.fn.stdpath("data") .. "/mason/bin/clangd",

				-- Performance and behavior flags
				"--background-index", -- Index project in the background for faster go-to-definition
				"--clang-tidy=false", -- Disable clang-tidy (set true if you want linting)
				"--header-insertion=iwyu", -- Add #includes automatically based on usage (can be "never")
				"--completion-style=detailed", -- Provides more detailed completion items in the UI
				"--function-arg-placeholders", -- Adds placeholders for function arguments when autocompleting

				-- Mac-specific GCC discovery paths (clangd does NOT expand globs like g++-*)
				"--query-driver=/opt/homebrew/bin/g++-15,/opt/homebrew/bin/g++,/opt/homebrew/bin/gcc-15,/opt/homebrew/bin/gcc",
			},
			filetypes = { "c", "cpp", "objc", "objcpp" },

			-- Inject C23 and C++23 standard support cleanly here.
			-- 'fallbackFlags' are used by clangd when no compile_commands.json is found in your project root.
			init_options = {
				fallbackFlags = {
					"-std=c23", -- Force C23 standard for .c files
					"-std=c++23", -- Force C++23 standard for .cpp files
				},
			},
		})

		-- Sourcekit (Swift - Non-Mason, system installed)
		vim.lsp.config("sourcekit", {
			cmd = { "sourcekit-lsp" },
			filetypes = { "swift" },
			root_markers = { "Package.swift", ".git" },
		})

		----------------------------------------------------------------------
		-- 4. ENABLE SERVERS
		-- Start all Mason-installed servers + standalone servers
		----------------------------------------------------------------------

		-- Enable standalone Sourcekit explicitly
		vim.lsp.enable("sourcekit")

		-- Safely fetch all installed Mason servers and enable them iteratively.
		-- This avoids manually listing them and handles the modern setup gracefully.
		local installed_servers = require("mason-lspconfig").get_installed_servers()
		for _, server in ipairs(installed_servers) do
			vim.lsp.enable(server)
		end

		----------------------------------------------------------------------
		-- 5. KEYMAPS & UTILITIES
		----------------------------------------------------------------------

		-- Toggle LSP functionality on the fly
		local lsp_enabled = true
		vim.keymap.set("n", "<leader>l", function()
			if lsp_enabled then
				vim.cmd("LspStop")
				vim.notify("LSP disabled", vim.log.levels.WARN)
			else
				vim.cmd("LspStart")
				vim.notify("LSP enabled", vim.log.levels.INFO)
			end
			lsp_enabled = not lsp_enabled
		end, { desc = "Toggle LSP", silent = true })
	end,
}
