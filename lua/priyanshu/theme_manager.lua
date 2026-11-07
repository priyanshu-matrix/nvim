local M = {}

local state_file = vim.fn.stdpath("data") .. "/theme_state"

local defaults = {
	colorscheme = "tokyonight",
	transparent = true,
	-- Separate preferences for each system appearance mode.
	-- When nil, falls back to `colorscheme` for the first run.
	dark_theme = nil,
	light_theme = nil,
}

local state = vim.deepcopy(defaults)

-- Track the last known system appearance so we only act on actual changes.
local last_appearance = nil

-- Tracks whether the most recent colorscheme change was triggered by the
-- auto-sync logic (true) or by the user / Themery (false).
local auto_switching = false

local transparent_groups = {
	"Normal",
	"NormalNC",
	-- "NormalFloat",
	"FloatBorder",
	"FloatTitle",
	-- "SignColumn",
	-- "LineNr",
	-- "CursorLineNr",
	-- "EndOfBuffer",
	-- "MsgArea",
	-- "StatusLine",
	-- "StatusLineNC",
	"NvimTreeNormal",
	"NvimTreeNormalNC",
	"TelescopeNormal",
	"TelescopeBorder",
	"TelescopePromptBorder",
	"TelescopeResultsBorder",
	"TelescopePreviewBorder",
}

function M.apply_transparency()
	if not state.transparent then
		return
	end

	for _, group in ipairs(transparent_groups) do
		local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
		hl.bg = "none"
		hl.ctermbg = "none"
		vim.api.nvim_set_hl(0, group, hl)
	end

	vim.opt.winblend = 0
	vim.opt.pumblend = 0
end

-- ─── System appearance detection ─────────────────────────────────────────────

--- Returns "dark" or "light" by querying macOS, or nil on failure.
local function get_system_appearance()
	local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()
	-- "Dark\n" → dark, anything else (empty string when Light) → light
	if result and result:match("^Dark") then
		return "dark"
	end
	return "light"
end

--- Apply the stored theme for the given appearance without updating state.
local function apply_appearance_theme(appearance)
	local theme
	if appearance == "light" then
		theme = state.light_theme or state.colorscheme
	else
		theme = state.dark_theme or state.colorscheme
	end

	if theme and theme ~= vim.g.colors_name then
		auto_switching = true
		pcall(vim.cmd.colorscheme, theme)
		auto_switching = false
	end
end

--- Check system appearance and switch theme if it has changed.
function M.sync_with_system()
	local appearance = get_system_appearance()
	if not appearance then
		return
	end

	if appearance ~= last_appearance then
		last_appearance = appearance
		apply_appearance_theme(appearance)
	end
end

-- ─── ColorScheme autocmd ──────────────────────────────────────────────────────

-- Auto-apply transparency whenever any colorscheme is loaded (including via
-- Themery) and persist the selected colorscheme.
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function(args)
		local current = vim.g.colors_name or args.match
		if not current or current == "" then
			return
		end

		if auto_switching then
			-- This change was triggered by the system auto-sync; just apply
			-- transparency and update the base colorscheme field — do NOT
			-- flip the per-mode preference.
			state.colorscheme = current
			M.save()
		else
			-- User / Themery changed the theme manually.
			state.colorscheme = current

			-- Persist the choice to the slot matching the current appearance.
			local appearance = last_appearance or get_system_appearance()
			if appearance == "light" then
				state.light_theme = current
			else
				state.dark_theme = current
			end

			M.save()
		end

		if state.transparent then
			M.apply_transparency()
		end
	end,
})

-- ─── Persistence ─────────────────────────────────────────────────────────────

function M.save()
	local f = io.open(state_file, "w")
	if not f then
		return
	end

	f:write(vim.json.encode(state))
	f:close()
end

function M.load()
	local f = io.open(state_file, "r")

	if f then
		local content = f:read("*a")
		f:close()

		local ok, decoded = pcall(vim.json.decode, content)

		if ok and decoded then
			state = vim.tbl_extend("force", defaults, decoded)
		end
	else
		-- If theme_state doesn't exist yet, sync with Themery state file if available
		local themery_state_file = vim.fn.stdpath("data") .. "/themery/state.json"
		local tf = io.open(themery_state_file, "r")
		if tf then
			local tcontent = tf:read("*a")
			tf:close()
			local tok, tdecoded = pcall(vim.json.decode, tcontent)
			if tok and tdecoded and tdecoded.colorscheme then
				state.colorscheme = tdecoded.colorscheme
			end
		end
	end

	-- Determine current system appearance before applying so the right slot
	-- is used from the very first load.
	last_appearance = get_system_appearance()

	local theme_to_apply
	if last_appearance == "light" then
		theme_to_apply = state.light_theme or state.colorscheme
	else
		theme_to_apply = state.dark_theme or state.colorscheme
	end

	if theme_to_apply then
		auto_switching = true
		pcall(vim.cmd.colorscheme, theme_to_apply)
		auto_switching = false
	end

	if state.transparent then
		M.apply_transparency()
	end

	-- Start polling for system appearance changes (~5-second interval).
	M.start_appearance_watcher()
end

-- ─── Appearance watcher ───────────────────────────────────────────────────────

local watcher_timer = nil

function M.start_appearance_watcher()
	if watcher_timer then
		return
	end

	watcher_timer = vim.uv.new_timer()
	-- Poll every 5 000 ms; use vim.schedule so the callback runs on the main
	-- Neovim thread (safe to call nvim API / colorscheme commands).
	watcher_timer:start(
		5000,
		5000,
		vim.schedule_wrap(function()
			M.sync_with_system()
		end)
	)
end

function M.stop_appearance_watcher()
	if watcher_timer then
		watcher_timer:stop()
		watcher_timer:close()
		watcher_timer = nil
	end
end

-- ─── Public API ──────────────────────────────────────────────────────────────

function M.apply()
	if state.colorscheme then
		pcall(vim.cmd.colorscheme, state.colorscheme)
	end
	if state.transparent then
		M.apply_transparency()
	end
end

function M.set_theme(theme)
	state.colorscheme = theme
	M.apply()
	M.save()
end

function M.toggle_transparency()
	state.transparent = not state.transparent
	if state.transparent then
		M.apply_transparency()
	else
		local current = vim.g.colors_name or state.colorscheme
		if current then
			pcall(vim.cmd.colorscheme, current)
		end
	end
	M.save()

	print("Transparency " .. (state.transparent and "enabled" or "disabled"))
end

function M.current_theme()
	return state.colorscheme
end

function M.is_transparent()
	return state.transparent
end

--- Return the currently detected system appearance ("dark" / "light" / nil).
function M.current_appearance()
	return last_appearance
end

return M
