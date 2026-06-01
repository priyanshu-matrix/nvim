return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				-- Completion sources
				sources = {
					{ name = "buffer" },
				},

				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),

					-- 3. CRITICAL: Crucial for auto-imports!
					-- Behavior must be set to 'replace' or 'insert' to apply LSP textEdits (like include insertions)
					["<CR>"] = cmp.mapping.confirm({ 
						behavior = cmp.ConfirmBehavior.Replace, 
						select = true, 
					}),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
			})
		end,
	},
}
