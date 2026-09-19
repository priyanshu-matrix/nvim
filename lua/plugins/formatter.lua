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
				cpp = { "clang_format" },
				c = { "clang_format" },
				markdown = { "prettier" },
				lua = { "stylua" },
				python = { "black" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			formatters = {
				clang_format = {
					command = "clang-format",
					prepend_args = function(self, ctx)
						-- Check if a local .clang-format or _clang-format file exists up the directory tree
						local config_file = vim.fs.find({ ".clang-format", "_clang-format" }, {
							upward = true,
							path = ctx.filename,
						})[1]

						-- If config file is found, use it directly without injecting --style
						if config_file then
							return {}
						end

						-- Fallback inline style when no local config exists (Linux kernel style)
						return {
							"--style={BasedOnStyle: LLVM, UseTab: Always, IndentWidth: 8, TabWidth: 8, BreakBeforeBraces: Linux}",
						}
					end,
				},
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
}

--[[ Alternative Fallback Styles (replace inside prepend_args return block):

Google Style:
return { "--style={BasedOnStyle: Google, IndentWidth: 8}" }

Microsoft Style:
return { "--style={BasedOnStyle: Microsoft, IndentWidth: 4, BreakBeforeBraces: Allman}" }

Strict LLVM:
return { "--style={BasedOnStyle: LLVM, IndentWidth: 4, PointerAlignment: Left}" }

Chromium:
return { "--style={BasedOnStyle: Chromium, IndentWidth: 4, AllowShortBlocksOnASingleLine: Always, AllowShortLoopsOnASingleLine: true}" }
]]
