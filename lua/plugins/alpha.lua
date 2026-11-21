return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			[[██████╗ ██████╗ ██╗██╗   ██╗ █████╗ ███╗   ██╗███████╗██╗  ██╗██╗   ██╗]],
			[[██╔══██╗██╔══██╗██║╚██╗ ██╔╝██╔══██╗████╗  ██║██╔════╝██║  ██║██║   ██║]],
			[[██████╔╝██████╔╝██║ ╚████╔╝ ███████║██╔██╗ ██║███████╗███████║██║   ██║]],
			[[██╔═══╝ ██╔══██╗██║  ╚██╔╝  ██╔══██║██║╚██╗██║╚════██║██╔══██║██║   ██║]],
			[[██║     ██║  ██║██║   ██║   ██║  ██║██║ ╚████║███████║██║  ██║╚██████╔╝]],
			[[╚═╝     ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ]],
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
			dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua <CR>"),
			dashboard.button("q", "  Quit", ":qa<CR>"),
		}

		-- Set footer
		local stats = require("lazy").stats()
		dashboard.section.footer.val = "Neovim loaded " .. stats.count .. " plugins in " .. stats.startuptime .. "ms"

		-- Dynamic vertical padding that re-centers on every resize
		local function get_padding()
			local header_lines = #dashboard.section.header.val
			local button_lines = #dashboard.section.buttons.val * 2 -- each button takes ~2 lines
			local footer_lines = 1
			local static_gaps = 4 -- gaps between sections
			local total_content = header_lines + button_lines + footer_lines + static_gaps
			local win_height = vim.fn.winheight(0)
			local pad = math.max(0, math.floor((win_height - total_content) / 2))
			return pad
		end

		dashboard.opts.layout = {
			{ type = "padding", val = get_padding },
			dashboard.section.header,
			{ type = "padding", val = 1 },
			dashboard.section.buttons,
			{ type = "padding", val = 1 },
			dashboard.section.footer,
		}

		-- Re-center when the window is resized
		vim.api.nvim_create_autocmd("VimResized", {
			callback = function()
				if vim.bo.filetype == "alpha" then
					alpha.redraw()
				end
			end,
		})

		-- --- HIDE CURSOR ON ALPHA DASHBOARD ---
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				-- Store the current guicursor setting
				local old_guicursor = vim.o.guicursor
				-- Create a fully transparent highlight group
				vim.api.nvim_set_hl(0, "AlphaHiddenCursor", { blend = 100, nocombine = true })
				-- Apply the transparent group to all cursor modes
				vim.o.guicursor = "a:AlphaHiddenCursor"

				-- Restore the original cursor when leaving the Alpha buffer
				vim.api.nvim_create_autocmd("BufLeave", {
					buffer = 0,
					callback = function()
						vim.o.guicursor = old_guicursor
					end,
				})
			end,
		})
		-- --------------------------------------

		-- Send config to alpha
		alpha.setup(dashboard.opts)
	end,
}
