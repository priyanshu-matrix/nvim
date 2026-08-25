return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
	    "",
	    "",
	    "",
	    "",
	    "",
	    "",
	    "",
        "┌────────────────────────────────────┐",
        "│░█▀█░█▀▄░▀█▀░█░█░█▀█░█▀█░█▀▀░█░█░█░█│",
        "│░█▀▀░█▀▄░░█░░░█░░█▀█░█░█░▀▀█░█▀█░█░█│",
        "│░▀░░░▀░▀░▀▀▀░░▀░░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀▀│",
        "└────────────────────────────────────┘",
    }
    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
      dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua <CR>"),
      dashboard.button("q", "󰞇  Quit", ":qa<CR>"),
    }

    -- Set footer
    local stats = require("lazy").stats()
    dashboard.section.footer.val = "Neovim loaded " .. stats.count .. " plugins in " .. stats.startuptime .. "ms"

    -- Send config to alpha
    alpha.setup(dashboard.opts)
  end,
}

