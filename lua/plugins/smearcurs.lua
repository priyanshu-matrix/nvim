return {

	"sphamba/smear-cursor.nvim",

	opts = {

		smear_between_buffers = true,

		smear_between_neighbor_lines = true,


		-- Draw the smear in buffer space instead of screen space when scrolling

		scroll_buffer_space = true,


		legacy_computing_symbols_support = false,


		-- Smear cursor in insert mode.

		-- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.

		smear_insert_mode = true,

		cursor_color = "#ff4000",

		particles_enabled = true,

		stiffness = 0.5,

		trailing_stiffness = 0.2,

		trailing_exponent = 5,

		damping = 0.6,

		gradient_exponent = 0,

		gamma = 1,

		never_draw_over_target = true,

		hide_target_hack = true,

		particle_spread = 1,

		particles_per_second = 500,

		particles_per_length = 50,

		particle_max_lifetime = 800,

		particle_max_initial_velocity = 20,

		particle_velocity_from_cursor = 0.5,

		particle_damping = 0.15,

		particle_gravity = -50,

		min_distance_emit_particles = 0,

	},

	config = function(_, opts)

		require("smear_cursor").setup(opts)



		-- Set the actual cursor color to match the fire animation when idle

		local set_cursor_color = function()

			vim.api.nvim_set_hl(0, "Cursor", { bg = "#ff4000", fg = "#000000" })

			vim.api.nvim_set_hl(0, "TermCursor", { bg = "#ff4000", fg = "#000000" })



			-- Force the guicursor to use the Cursor highlight group in all modes

			vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

		end



		set_cursor_color()



		-- Ensure the color stays even if a theme is loaded or changed later

		vim.api.nvim_create_autocmd("ColorScheme", {

			pattern = "*",

			callback = set_cursor_color,

		})

	end,

} 
