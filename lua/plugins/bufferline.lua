-- ─────────────────────────────────────────────────────────────────────────────
--  Buffer Manager · akinsho/bufferline.nvim
--
--  Keymaps
--    <leader>bb     toggle buffer bar
--    ⌥← / ⌥→       cycle buffers  (⌘⌥← / ⌘⌥→ in GUI/Neovide)
--    <leader>bd     smart-close buffer
--    <leader>bD     force-close (discard changes)
--    <leader>bp     pick buffer  (letter-jump)
--    <leader>bP     pick-close buffer
--    <leader>bh/l   move buffer left / right
--    <leader>bn     pin / unpin buffer
--    <leader>bo     close all other buffers
--    <leader>1-9    jump to buffer by position
-- ─────────────────────────────────────────────────────────────────────────────

return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",

	init = function()
		vim.opt.showtabline = 0
	end,

	opts = function()
		local bl = require("bufferline")
		return {
			options = {
				mode = "buffers",
				style_preset = bl.style_preset.default,
				themable = true,

				-- ordinal number on each tab  (pairs with <leader>1-9 jumps)
				numbers = function(o)
					return o.ordinal
				end,

				-- NOTE: do NOT set close_command to bufferline internals —
				-- that causes a stack overflow. Leave it nil so bufferline
				-- uses its own safe default.
				close_command = "bdelete! %d",
				right_mouse_command = "vertical sbuffer %d",
				left_mouse_command = "buffer %d",
				middle_mouse_command = nil,

				indicator = { icon = "▎", style = "icon" },
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",

				max_name_length = 18,
				max_prefix_length = 15,
				truncate_names = true,
				tab_size = 16,

				-- LSP diagnostics inline on tabs
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,

				-- Hide utility / sidebar buffers from the bar
				custom_filter = function(bufnr)
					local excluded = {
						NvimTree = true,
						alpha = true,
						dashboard = true,
						["neo-tree"] = true,
						Trouble = true,
						lazy = true,
						mason = true,
					}
					return not excluded[vim.bo[bufnr].filetype]
				end,

				-- Offset for nvim-tree sidebar
				offsets = {
					{
						filetype = "NvimTree",
						text = "  WorkDir",
						text_align = "left",
						separator = true,
					},
				},

				color_icons = false,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				show_duplicate_prefix = true,
				persist_buffer_sort = true,
				move_wraps_at_ends = false,

				separator_style = "thin", -- slant | slope | thin | thick
				enforce_regular_tabs = false,
				always_show_bufferline = true,

				hover = { enabled = true, delay = 150, reveal = { "close" } },
				sort_by = "insert_at_end",
			},

			highlights = {
				fill = { bg = "NONE" },
				background = { italic = false },
				buffer_selected = { bold = true, italic = false },
				numbers_selected = { bold = true },
				diagnostic_selected = { bold = true },
				pick_selected = { bold = true, italic = false },
				pick_visible = { italic = true },
				pick = { italic = true },
			},
		}
	end,

	config = function(_, opts)
		local bl = require("bufferline")
		bl.setup(opts)

		-- ── toggle visibility ──────────────────────────────────────────────────
		local bar_visible = false
		vim.opt.showtabline = 0
		local function toggle_bar()
			bar_visible = not bar_visible
			vim.opt.showtabline = bar_visible and 2 or 0
			vim.notify(
				bar_visible and "󰓩  Buffer bar ON" or "󰓨  Buffer bar OFF",
				vim.log.levels.INFO,
				{ title = "Bufferline" }
			)
		end

		-- ── smart close (won't quit nvim on last buffer) ───────────────────────
		local function smart_close(force)
			local listed = vim.fn.getbufinfo({ buflisted = 1 })
			if #listed <= 1 then
				vim.cmd(force and "bwipeout!" or "enew")
				return
			end
			local cur = vim.api.nvim_get_current_buf()
			vim.cmd("bprevious")
			pcall(vim.cmd, (force and "bwipeout! " or "bwipeout ") .. cur)
		end

		-- ── close every buffer except the current one ──────────────────────────
		local function close_others()
			local cur = vim.api.nvim_get_current_buf()
			for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
				if buf.bufnr ~= cur then
					pcall(vim.cmd, "bwipeout " .. buf.bufnr)
				end
			end
		end

		-- ── keymap helper ──────────────────────────────────────────────────────
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
		end

		-- toggle bar
		map("<leader>bb", toggle_bar, "Toggle buffer bar")

		-- cycle  (⌥arrow in terminal, ⌘⌥arrow in GUI)
		map("<M-Right>", "<Cmd>BufferLineCycleNext<CR>", "Next buffer (⌥→)")
		map("<M-Left>", "<Cmd>BufferLineCyclePrev<CR>", "Prev buffer (⌥←)")
		map("<D-M-Right>", "<Cmd>BufferLineCycleNext<CR>", "Next buffer (⌘⌥→)")
		map("<D-M-Left>", "<Cmd>BufferLineCyclePrev<CR>", "Prev buffer (⌘⌥←)")

		-- close
		map("<leader>bd", function()
			smart_close(false)
		end, "Close buffer")
		map("<leader>bD", function()
			smart_close(true)
		end, "Force-close buffer")

		-- pick / pick-close
		map("<leader>bp", "<Cmd>BufferLinePick<CR>", "Pick buffer")
		map("<leader>bP", "<Cmd>BufferLinePickClose<CR>", "Pick-close buffer")

		-- reorder
		map("<leader>bl", "<Cmd>BufferLineMoveNext<CR>", "Move buffer right")
		map("<leader>bh", "<Cmd>BufferLineMovePrev<CR>", "Move buffer left")

		-- pin
		map("<leader>bn", "<Cmd>BufferLineTogglePin<CR>", "Pin / unpin buffer")

		-- close others
		map("<leader>bo", close_others, "Close other buffers")

		-- jump by position  <leader>1 … <leader>9
		for i = 1, 9 do
			map("<leader>" .. i, function()
				bl.go_to(i, true)
			end, "Buffer " .. i)
		end
	end,
}
