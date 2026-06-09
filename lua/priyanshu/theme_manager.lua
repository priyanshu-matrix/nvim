
local M = {}

local state_file = vim.fn.stdpath("data") .. "/theme_state"

local defaults = {
	colorscheme = "tokyonight",
	transparent = true,
}

local state = vim.deepcopy(defaults)

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
	end

	M.apply()
end

function M.apply()
	if state.colorscheme == "tokyonight" then
		require("tokyonight").setup({
			transparent = state.transparent,
		})
	elseif state.colorscheme == "rose-pine" then
		require("rose-pine").setup({
			disable_background = state.transparent,
		})
	end

	vim.cmd.colorscheme(state.colorscheme)
end

function M.set_theme(theme)
	state.colorscheme = theme
	M.apply()
	M.save()
end

function M.toggle_transparency()
	state.transparent = not state.transparent
	M.apply()
	M.save()

	print(
		"Transparency "
			.. (state.transparent and "enabled" or "disabled")
	)
end

function M.current_theme()
	return state.colorscheme
end

return M
