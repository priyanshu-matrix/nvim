
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

