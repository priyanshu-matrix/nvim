return {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        -- Queries Treesitter to dynamically choose comment syntax anywhere in a file
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
        -- Setup Treesitter commentstring integration
        local ts_cs = require("ts_context_commentstring.integrations.comment_nvim")
        require("ts_context_commentstring").setup({
            enable_autocmd = false,
        })

        -- Custom filetype mappings (fallback for extra languages or custom block syntax)
        local ft = require("Comment.ft")
        ft.set("c", { "//%s", "/*%s*/" })
        ft.set("cpp", { "//%s", "/*%s*/" })
        ft.set("go", { "//%s", "/*%s*/" })
        ft.set("rust", { "//%s", "/*%s*/" })
        ft.set("cuda", { "//%s", "/*%s*/" })

        require("Comment").setup({
            padding = true,
            sticky = true,
            ignore = "^$",

            toggler = {
                line = "gcc",
                block = "gbc", -- Fixed duplicate keymap (was "gcc")
            },

            opleader = {
                line = "gc",
                block = "gb",
            },

            extra = {
                above = "gcO",
                below = "gco",
                eol = "gcA",
            },

            mappings = {
                basic = true,
                extra = true,
            },

            -- Automatically detects the exact language at cursor using Treesitter
            pre_hook = ts_cs.create_pre_hook(),
        })
    end,
}
