local M = {}

local state_file = vim.fn.stdpath("data") .. "/theme_state"

local defaults = {
	colorscheme = "tokyonight",
	transparent = true,
}

local state = vim.deepcopy(defaults)

local transparent_groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"FloatBorder",
	"FloatTitle",
	"SignColumn",
	"LineNr",
	"CursorLineNr",
	"EndOfBuffer",
	"MsgArea",
	"StatusLine",
	"StatusLineNC",
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
		vim.api.nvim_set_hl(0, group, { bg = "none" })
	end
end

-- Auto-apply transparency whenever any colorscheme is loaded (including via Themery)
-- and automatically persist the selected colorscheme.
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function(args)
		local current = vim.g.colors_name or args.match
		if current and current ~= "" and current ~= state.colorscheme then
			state.colorscheme = current
			M.save()
		end
		if state.transparent then
			M.apply_transparency()
		end
	end,
})

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

	M.apply()
end

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

return M
