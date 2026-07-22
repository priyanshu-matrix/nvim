vim.g.mapleader = " "

-- For opening netrw
vim.keymap.set("n","<leader>e", vim.cmd.Ex)

-- For clearing highlight after search
vim.keymap.set("n", "<Esc>", vim.cmd.noh)

-- For opening terminal
local term_buf = nil
local term_win = nil

local function toggle_terminal()
  -- If the window is open and valid, hide it
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
  else
    -- Calculate dimensions for the floating "box" (80% of screen)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create a buffer if it doesn't exist or was wiped
    if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
      term_buf = vim.api.nvim_create_buf(false, true)
    end

    -- Open the floating window
    term_win = vim.api.nvim_open_win(term_buf, true, {
      relative = "editor",
      width = width,
      height = height,
      col = col,
      row = row,
      style = "minimal",
      border = "rounded" -- Gives the terminal a nice box outline
    })

    -- If the buffer isn't a terminal yet, make it one
    if vim.bo[term_buf].buftype ~= "terminal" then
      vim.fn.termopen(vim.o.shell)
    end
    
    -- Automatically enter insert mode so you can type immediately
    vim.cmd("startinsert")
  end
end

-- Map for Normal mode (to open the terminal)
vim.keymap.set('n', '<C-\\>', toggle_terminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })

-- Map for Terminal mode (to close the terminal while you are inside it)
vim.keymap.set('t', '<C-\\>', toggle_terminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })

-- Basic Editor Config
vim.opt.relativenumber = true;
vim.opt.number = true;
vim.opt.termguicolors = true;
vim.opt.clipboard:append('unnamedplus');

-- Ctrl + C to copy entire buffer to clipboard
vim.keymap.set('n', '<C-c>', function()
    vim.cmd('%yank +')
    print('Entire file copied to clipboard')
end, {
    silent = false,
    desc = 'Copy entire file to clipboard'
})



-- 1. Optional: Adjust the hover delay (default is 4000ms / 4 seconds)
-- 500ms is a popular sweet spot for responsiveness without lag
vim.o.updatetime = 500 

-- 2. Create an autocmd to trigger the float on hover
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr, -- Keeps it isolated to the current buffer
  callback = function()
    -- These options prevent the window from stealing focus 
    -- and keep it clean so you can just move your cursor away to close it
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always', -- Shows whether it's from LSP, Lua diagnostics, etc.
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})

-- Theme Manager
local tm = require("priyanshu.theme_manager")

vim.keymap.set("n", "<leader>tt", tm.toggle_transparency, {
	desc = "Toggle transparency",
})

vim.keymap.set("n", "<leader>tn", function()
	tm.set_theme("tokyonight")
end, { desc = "Tokyonight" })

vim.keymap.set("n", "<leader>tr", function()
	tm.set_theme("rose-pine")
end, { desc = "Rose Pine" })

vim.keymap.set("n", "<leader>th", "<cmd>Themery<CR>", { desc = "Open Themery GUI" })

