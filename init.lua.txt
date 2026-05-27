-- ~/.config/nvim/init.lua
-- =============================================================================
-- LAZY.NVIM PLUGIN MANAGER SETUP
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- BASIC NEOVIM SETTINGS
-- =============================================================================
vim.g.mapleader = ' '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard:append('unnamedplus')

-- =============================================================================
-- CUSTOM KEYMAPS
-- =============================================================================

-- Ctrl + C to copy entire buffer to clipboard
vim.keymap.set('n', '<C-c>', function()
    vim.cmd('%yank +')
    print('Entire file copied to clipboard')
end, {
    silent = false,
    desc = 'Copy entire file to clipboard'
})

-- Remove Search Highlight
vim.keymap.set('n', '<Esc>', ':noh<CR>', { desc = 'Clear search highlighting' })

-- =============================================================================
-- WINDOW MANAGEMENT KEYMAPS
-- =============================================================================
-- Split windows
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>wh', '<cmd>split<cr>', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>wc', '<cmd>close<cr>', { desc = 'Close current window' })
vim.keymap.set('n', '<leader>wo', '<cmd>only<cr>', { desc = 'Close all other windows' })

-- Navigate between windows (Ctrl + hjkl)
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows (leader + arrow-like keys for macOS)
vim.keymap.set('n', '<leader>wk', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<leader>wj', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<leader>w,', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<leader>w.', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Equalize window sizes
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = 'Equalize window sizes' })

-- =============================================================================
-- PLUGIN DEFINITIONS
-- =============================================================================
require("lazy").setup({

-- Catppuccin colorscheme
{
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
},

-- Colorscheme manager
{
    'zaldih/themery.nvim',
    config = function()
        require('themery').setup({
            themes = {
                {
                    name = "catppuccin-mocha",
                    colorscheme = "catppuccin-mocha"
                }
            },
            livePreview = false,
        })
        -- Set the default theme directly
        vim.cmd('colorscheme habamax')
    end
},

-- Autopairs for matching brackets
{
    'windwp/nvim-autopairs',
    config = function()
        require('nvim-autopairs').setup()
    end
},

-- NEW: Commenting plugin with Ctrl + / keymap
{
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
        -- Keymap for Normal mode (comments the current line)
        vim.keymap.set('n', '<C-/>', function()
            require('Comment.api').toggle.linewise.current()
        end, {
            silent = true,
            desc = 'Toggle comment'
        })

        -- Keymap for Visual mode (comments the selection)
        vim.keymap.set('v', '<C-/>', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', {
            silent = true,
            noremap = true,
            desc = 'Toggle comment'
        })
    end
},

-- Snippet engine
{
    'L3MON4D3/LuaSnip',
    dependencies = {'rafamadriz/friendly-snippets'},
    config = function()
        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node

        -- Load friendly snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Custom C++ template snippet
        ls.add_snippets("cpp", {
            s("template", {
                t("#include<bits/stdc++.h>"),
                t({"", "using namespace std;", ""}),
                t({"", "int main() {", "    "}),
                i(1, "// Your code here"),
                t({"", "    return 0;", "}"})
            })
        })

        -- Custom keymap for m+. to trigger cpp template
        vim.keymap.set('n', 'm.', function()
            if vim.bo.filetype == 'cpp' then
                vim.ui.select({'y', 'n'}, {
                    prompt = 'Load C++ template? ',
                }, function(choice)
                    if choice == 'y' then
                        -- Clear the buffer and insert template
                        vim.cmd('normal! ggdG')
                        ls.snip_expand(ls.get_snippets('cpp')[1])
                    end
                end)
            else
                print("Not in a C++ file")
            end
        end, {
            silent = true,
            desc = 'Load C++ template snippet'
        })
    end
},

-- The competitive programming plugin and its dependency
{
    'xeluxee/competitest.nvim',
    dependencies = {'MunifTanjim/nui.nvim'},
    config = function()
        require('competitest').setup {
            compile_command = {
                cpp = {
                    exec = 'g++-15',
                    args = {'$(FNAME)', '-o', '$(FNOEXT)'}
                }
            },
            run_command = {
                cpp = {
                    exec = './$(FNOEXT)'
                }
            },
            template_file = {
                cpp = "~/.config/nvim/CP/template.cpp"
            },
            contests_dir = '~/cpvim/contests'
        }

        -- Keymaps for competitest.nvim
        local map = vim.keymap.set
        map('n', '<leader>cn', '<cmd>CompetiTest receive problem<cr>', {
            silent = true,
            desc = 'CompetiTest: Listen'
        })
        map('n', '<leader>cr', '<cmd>CompetiTest run<cr>', {
            silent = true,
            desc = 'CompetiTest: Run tests'
        })
        map('n', '<leader>cd', '<cmd>CompetiTest delete_testcase<cr>', {
            silent = true,
            desc = 'CompetiTest: Run tests'
        })
        map('n', '<leader>ce', '<cmd>CompetiTest edit_testcase<cr>', {
            silent = true,
            desc = 'CompetiTest: Run tests'
        })
        map('n', '<leader>ct', '<cmd>CompetiTest add_testcase<cr>', {
            silent = true,
            desc = 'CompetiTest: Add testcase'
        })
    end
},

-- Telescope for fuzzy finding (used for template picker)
{
    'nvim-telescope/telescope.nvim',
    dependencies = {'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons'},
    config = function()
        require('telescope').setup({})
        -- Open template picker: <leader>t (replace entire buffer)
        vim.keymap.set('n', '<leader>t', function()
            require('template_picker').open()
        end, { silent = true, desc = 'Insert template from list (replace buffer)' })

        -- Open snippet picker: <leader>s (insert at cursor)
        vim.keymap.set('n', '<leader>s', function()
            require('template_picker').open_snippets()
        end, { silent = true, desc = 'Insert snippet at cursor' })
    end
},

-- =============================================================================
-- TREESITTER - SYNTAX HIGHLIGHTING
-- =============================================================================
-- Provides better syntax highlighting for many languages
-- Parsers are auto-installed on first file open
-- =============================================================================
{
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
        if not status_ok then
            vim.notify('nvim-treesitter not loaded yet', vim.log.levels.WARN)
            return
        end

        configs.setup({
            -- Auto-install parsers when opening a file
            auto_install = true,

            -- Enable syntax highlighting
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            -- Enable indentation
            indent = {
                enable = true
            },
        })
    end
},

-- =============================================================================
-- MASON - PACKAGE MANAGER FOR LSP SERVERS, LINTERS, FORMATTERS
-- =============================================================================
-- CLI COMMANDS:
--   :Mason                        - Open Mason UI to browse/install packages
--   :MasonInstall <package>       - Install a language server/tool
--   :MasonUninstall <package>     - Uninstall a package
--   :MasonUpdate                  - Update all installed packages
--
-- POPULAR LANGUAGE SERVERS:
--   rust_analyzer    - Rust LSP (error detection, completion, go-to-def)
--   pyright          - Python LSP
--   lua_ls           - Lua LSP
--   clangd           - C/C++ LSP
--   gopls            - Go LSP
--   ts_ls            - TypeScript/JavaScript LSP
--   html             - HTML LSP
--   cssls            - CSS LSP
--   jsonls           - JSON LSP
--
-- EXAMPLE: Install Rust support
--   1. :MasonInstall rust_analyzer
--   2. Open a .rs file - you'll get error detection, completion, etc!
-- =============================================================================
{
    'williamboman/mason.nvim',
    config = function()
        require('mason').setup({
            ui = {
                border = 'rounded',
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        })
    end
},

-- =============================================================================
-- LSP CONFIGURATION
-- =============================================================================
-- clangd (C++) is configured directly below using the system install at
-- /usr/bin/clangd. It uses g++-15 as the query-driver so clangd asks GCC
-- for its real include paths — this is what makes bits/stdc++.h resolve.
-- All other language servers are managed by Mason automatically.
--
-- KEYMAPS (active when an LSP attaches):
--   gd           - Go to definition
--   gD           - Go to declaration
--   gr           - Show references
--   K            - Hover documentation
--   <leader>rn   - Rename symbol
--   <leader>ca   - Code actions
--   <leader>xd   - Toggle diagnostics (hidden by default)
-- =============================================================================
{
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' },
    config = function()
        -- -------------------------------------------------------------------
        -- Mason ↔ LSP bridge — enables Mason-installed servers via the
        -- built-in vim.lsp.enable() API (Neovim 0.11+).
        -- clangd is excluded: we configure it directly below.
        -- -------------------------------------------------------------------
        require('mason-lspconfig').setup({
            ensure_installed = {},
            automatic_installation = { exclude = { 'clangd' } },
            handlers = {
                function(server_name)
                    vim.lsp.enable(server_name)
                end,
            }
        })

        -- -------------------------------------------------------------------
        -- clangd — C++ LSP via system install (/usr/bin/clangd, Apple 17)
        -- --query-driver makes clangd invoke g++-15 to learn its system
        -- include paths, which resolves bits/stdc++.h and all GCC headers.
        -- compile_flags.txt supplies -std=c++20 / -DONLINE_JUDGE.
        -- -------------------------------------------------------------------
        vim.lsp.config('clangd', {
            cmd = {
                '/usr/bin/clangd',
                '--background-index',
                '--header-insertion=never',
                '--completion-style=detailed',
            },
            filetypes = { 'c', 'cpp', 'cc' },
            root_dir = function(fname)
                -- Works for single-file CP problems: falls back to the file's own dir
                local util = require('lspconfig.util')
                return util.root_pattern('compile_flags.txt', 'compile_commands.json', '.git')(fname)
                    or vim.fn.fnamemodify(fname, ':h')
            end,
        })
        vim.lsp.enable('clangd')

        -- -------------------------------------------------------------------
        -- LSP keymaps — set up each time an LSP attaches to a buffer
        -- -------------------------------------------------------------------
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(ev)
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,  vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
                vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
                vim.keymap.set('n', 'gr',         vim.lsp.buf.references,  vim.tbl_extend('force', opts, { desc = 'Show references' }))
                vim.keymap.set('n', 'K',          vim.lsp.buf.hover,       vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,      vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code actions' }))
            end
        })

        -- -------------------------------------------------------------------
        -- Diagnostics: hidden by default — press <leader>xd to toggle
        -- -------------------------------------------------------------------
        local diag_enabled = false
        vim.diagnostic.config({
            virtual_text     = false,
            signs            = false,
            underline        = false,
            update_in_insert = false,
            severity_sort    = true,
        })

        vim.keymap.set('n', '<leader>xd', function()
            diag_enabled = not diag_enabled
            if diag_enabled then
                vim.diagnostic.config({ signs = true, underline = true })
                vim.diagnostic.show()
                print('Diagnostics ON')
            else
                vim.diagnostic.config({ signs = false, underline = false })
                vim.diagnostic.hide()
                print('Diagnostics OFF')
            end
        end, { desc = 'Toggle LSP diagnostics' })

        -- Diagnostic sign symbols
        local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        -- Float diagnostic on CursorHold (only while diagnostics are enabled)
        vim.o.updatetime = 300
        vim.api.nvim_create_autocmd('CursorHold', {
            callback = function()
                if vim.fn.mode() == 'n' and diag_enabled then
                    vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor', border = 'rounded' })
                end
            end,
        })
    end
},

-- Pretty diagnostics list
{
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
        { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
        { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix (Trouble)' },
    }
},

-- =============================================================================
-- DEBUGGING FOR C++ (DAP + UI)
-- =============================================================================
-- HOW TO USE:
--   1. First compile your code with debug symbols: g++-15 -g myfile.cpp -o myfile
--   2. Set breakpoints with <leader>b (Space + b) on lines you want to pause
--   3. Press F5 to start debugging - it will ask for the executable path
--   4. Use F10 (step over), F11 (step into), F12 (step out) to navigate
--   5. Press F5 again to continue to next breakpoint
--   6. The debug UI opens automatically showing variables, call stack, etc.
-- =============================================================================
{
    'mfussenegger/nvim-dap'
},
{
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')
        dapui.setup()
        -- Auto open/close debug UI
        dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
        dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
        dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

        local map = vim.keymap.set
        map('n', '<F5>', function() dap.continue() end, { desc = 'DAP Continue' })         -- Start/Continue debugging
        map('n', '<F10>', function() dap.step_over() end, { desc = 'DAP Step Over' })      -- Execute current line
        map('n', '<F11>', function() dap.step_into() end, { desc = 'DAP Step Into' })      -- Go inside function
        map('n', '<F12>', function() dap.step_out() end, { desc = 'DAP Step Out' })        -- Exit current function
        map('n', '<leader>b', function() dap.toggle_breakpoint() end, { desc = 'DAP Toggle Breakpoint' })  -- Set/remove breakpoint
        map('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
            { desc = 'DAP Conditional Breakpoint' })  -- Breakpoint with condition (e.g., i == 5)
    end
},
{
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
    config = function()
        require('mason-nvim-dap').setup({
            ensure_installed = { 'codelldb' },  -- Debug adapter for C/C++
            automatic_installation = true,
            handlers = {}
        })
    end
},

-- =============================================================================
-- TERMINAL PLUGIN (ToggleTerm)
-- =============================================================================
-- HOW TO USE:
--   1. Press Ctrl+\ to toggle terminal (normal mode)
--   2. Press Ctrl+\ in terminal to hide it (goes to normal mode first with Ctrl+\Ctrl+n)
--   3. <leader>tf - Float terminal (centered floating window)
--   4. <leader>th - Horizontal split terminal
--   5. <leader>tv - Vertical split terminal
--   6. Multiple terminals: <leader>t1, <leader>t2, <leader>t3
--   7. Press 'i' or 'a' in terminal window to enter insert mode
--   8. Terminal windows persist - they don't close, just hide
-- =============================================================================
{
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
        require('toggleterm').setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            persist_size = true,
            persist_mode = true,
            direction = 'float',
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = 'curved',
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
        })

        local map = vim.keymap.set
        -- Different terminal layouts
        map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'Terminal: Float' })
        map('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', { desc = 'Terminal: Horizontal' })
        map('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>', { desc = 'Terminal: Vertical' })

        -- Multiple terminals
        map('n', '<leader>t1', '<cmd>1ToggleTerm<cr>', { desc = 'Terminal 1' })
        map('n', '<leader>t2', '<cmd>2ToggleTerm<cr>', { desc = 'Terminal 2' })
        map('n', '<leader>t3', '<cmd>3ToggleTerm<cr>', { desc = 'Terminal 3' })

        -- Easier escape from terminal mode
        map('t', '<C-x>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
    end
},

-- =============================================================================
-- FILE TREE VIEWER (nvim-tree)
-- =============================================================================
-- HOW TO USE:
--   1. Press <leader>e (Space + e) to toggle the file tree
--   2. Press <leader>E to focus on current file in tree
--   3. Navigation in tree:
--      - Enter or o or l: Open file/folder
--      - Ctrl+v: Open in VERTICAL SPLIT (side by side)
--      - Ctrl+s: Open in HORIZONTAL SPLIT (top/bottom)
--      - Ctrl+t: Open in new tab
--      - h: Close directory (go up)
--      - W: Collapse all directories
--      - a: Create new file/folder (end with / for folder)
--      - d: Delete file/folder
--      - r: Rename file/folder
--      - x: Cut file
--      - c: Copy file
--      - p: Paste file
--      - y: Copy filename
--      - Y: Copy relative path
--      - R: Refresh tree
--      - H: Toggle hidden files
--      - q: Close tree
--      - ?: Show help with all keybindings
-- =============================================================================
{
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        -- Disable netrw (vim's default file explorer)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require('nvim-tree').setup({
            view = {
                width = 35,
                side = 'left',
            },
            renderer = {
                group_empty = true,
                highlight_git = true,
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                },
            },
            filters = {
                dotfiles = false,  -- Show hidden files by default
            },
            git = {
                enable = true,
                ignore = false,
            },
            actions = {
                open_file = {
                    quit_on_open = false,  -- Keep tree open after opening file
                    resize_window = true,
                },
            },
            on_attach = function(bufnr)
                local api = require('nvim-tree.api')
                local function opts(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- Default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- Custom mappings (override defaults)
                vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
                -- SPLIT WINDOW COMMANDS - Open files side by side
                vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split (side by side)'))
                vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split (top/bottom)'))
                vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
                vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
                vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse All'))
                vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
                vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
                vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
                vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
                vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
                vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
                vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
                vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
                vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
                vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Hidden'))
                vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
                vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
            end,
        })

        -- Keymaps for nvim-tree
        local map = vim.keymap.set
        map('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { silent = true, desc = 'Toggle File Tree' })
        map('n', '<leader>E', '<cmd>NvimTreeFindFile<cr>', { silent = true, desc = 'Find Current File in Tree' })
    end
},

-- =============================================================================
-- COOL FEATURE: LUALINE STATUS BAR
-- =============================================================================
-- A beautiful and informative status line at the bottom showing:
-- Mode | Git branch | Filename | Diagnostics | Encoding | File type | Progress
-- =============================================================================
{
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            options = {
                theme = 'auto',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                globalstatus = true,
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { { 'filename', path = 1 } },  -- Show relative path
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            extensions = { 'nvim-tree', 'trouble' }
        })
    end
}
})
