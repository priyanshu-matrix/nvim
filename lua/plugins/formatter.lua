return {
	'stevearc/conform.nvim',
	opts = {
		formatters_by_ft = {
			cpp        = { "clang_format" },
			c          = { "clang_format" },
			javascript = { "prettier" },
			html 	   = { "prettier" },
			css	   = { "prettier" },
			rust 	   = { "rustfmt" },
		},
		formatters = {
			clang_format = {
				-- This appends the style flag directly to the command: clang-format --style="..."
				prepend_args = { 
					"--style={BasedOnStyle: LLVM, UseTab: Always, IndentWidth: 8, TabWidth: 8, BreakBeforeBraces: Linux}" 
				},

			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}


--[[ On line-10 we can put this and change the style

The Google Style : prepend_args = { "--style={BasedOnStyle: Google, IndentWidth: 8}" },

The linux style : prepend_args = { "--style={BasedOnStyle: LLVM, UseTab: Always, IndentWidth: 8, TabWidth: 8, BreakBeforeBraces: Linux}" },

Microsoft style : prepend_args = { "--style={BasedOnStyle: Microsoft, IndentWidth: 4, BreakBeforeBraces: Allman}" },

Strict LLVM : prepend_args = { "--style={BasedOnStyle: LLVM, IndentWidth: 4, PointerAlignment: Left}" },

Chromium : prepend_args = { "--style={BasedOnStyle: Chromium, IndentWidth: 4, AllowShortBlocksOnASingleLine: Always, AllowShortLoopsOnASingleLine: true}" }, ]]
