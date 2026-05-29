-- Competetive programming suite
return {
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
}
