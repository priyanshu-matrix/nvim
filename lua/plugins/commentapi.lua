-- Perfect Comment execution

return {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    config = function()
        local U = require("Comment.utils")

        require("Comment").setup({
            padding = true,
            sticky  = true,
            ignore  = "^$",

            toggler = {
                line  = "gcc",
                block = "gcc",
            },

            opleader = {
                line  = "gc",
                block = "gB",
            },

            extra = {
                above = "gcO",
                below = "gco",
                eol   = "gcA",
            },

            mappings = {
                basic = true,
                extra = true,
            },

            pre_hook = function(ctx)
                local ft = vim.bo.filetype

                -- fix block comments for C / C++
                if vim.tbl_contains({ "c", "cpp" }, ft) then
                    if ctx.ctype == U.ctype.blockwise then
                        return "/*%s*/"
                    else
                        return "//%s"
                    end
                end
            end,
        })
    end,
}
