return {
	-- 1. Automatic Mason bridging
	{
		"zapling/mason-conform.nvim",
		dependencies = { "williamboman/mason.nvim", "stevearc/conform.nvim" },
		config = function()
			require("mason-conform").setup({
				automatic_installation = true,
			})
		end,
	},

	-- 2. Format execution configuration
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				-- Pointing explicitly to your custom identifier
				cpp = { "clang_format" },
				c   = { "clang_format" },
				markdown = {"prettier"},
				lua = { "stylua" },
				python = { "isort", "black" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			formatters = {
				-- Defining the custom "clang_format" configuration explicitly
				clang_format = {
					-- Tells conform the exact CLI command binary name to execute
					command = "clang-format",
					-- Your custom style flags appended directly to the command
					
				prepend_args = { "--style={BasedOnStyle: LLVM, UseTab: Always, IndentWidth: 8, TabWidth: 8, BreakBeforeBraces: Linux}" },
				},
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	}
}




--[[ On line-10 we can put this and change the style

The Google Style : prepend_args = { "--style={BasedOnStyle: Google, IndentWidth: 8}" },

The linux style : prepend_args = { "--style={BasedOnStyle: LLVM, UseTab: Always, IndentWidth: 8, TabWidth: 8, BreakBeforeBraces: Linux}" },

Microsoft style : prepend_args = { "--style={BasedOnStyle: Microsoft, IndentWidth: 4, BreakBeforeBraces: Allman}" },

Strict LLVM : prepend_args = { "--style={BasedOnStyle: LLVM, IndentWidth: 4, PointerAlignment: Left}" },

Chromium : prepend_args = { "--style={BasedOnStyle: Chromium, IndentWidth: 4, AllowShortBlocksOnASingleLine: Always, AllowShortLoopsOnASingleLine: true}" }, ]]
