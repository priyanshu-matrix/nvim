
vim.g.mapleader = " "

-- For opening netrw
vim.keymap.set("n","<leader>e", vim.cmd.Ex)

-- For clearing highlight after search
vim.keymap.set("n", "<Esc>", vim.cmd.noh)

-- For opening terminal
vim.keymap.set('n', "<C-\\>", vim.cmd.term)

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
