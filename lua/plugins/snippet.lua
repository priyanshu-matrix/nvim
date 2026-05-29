return{
    'L3MON4D3/LuaSnip',
    dependencies = {'rafamadriz/friendly-snippets'},
    config = function()
        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node

        -- Load friendly snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Load all snippets from the snippets/ folder
        -- Each file becomes a snippet whose trigger is the filename (without extension)
        -- The filetype is inferred from the file extension
        local snippets_dir = vim.fn.stdpath("config") .. "/snippets"

        local function load_snippets_from_folder()
            local files = vim.fn.globpath(snippets_dir, "*", false, true)
            for _, filepath in ipairs(files) do
                local filename = vim.fn.fnamemodify(filepath, ":t")     -- e.g. "dijkstra.cpp"
                local trigger  = vim.fn.fnamemodify(filepath, ":t:r")   -- e.g. "dijkstra"
                local ext      = vim.fn.fnamemodify(filepath, ":e")     -- e.g. "cpp"

                if ext ~= "" then
                    local lines = vim.fn.readfile(filepath)
                    if #lines > 0 then
                        -- Build text nodes: first line is plain, rest are {"", line}
                        local nodes = { t(lines[1]) }
                        for idx = 2, #lines do
                            table.insert(nodes, t({"", lines[idx]}))
                        end
                        ls.add_snippets(ext, {
                            s(trigger, nodes)
                        })
                    end
                end
            end
        end

        load_snippets_from_folder()

        -- m. keymap: pick a snippet from the snippets/ folder and insert it
        vim.keymap.set('n', 'm.', function()
            local ft = vim.bo.filetype
            local files = vim.fn.globpath(snippets_dir, "*." .. ft, false, true)

            if #files == 0 then
                -- Fallback: show all snippet files regardless of filetype
                files = vim.fn.globpath(snippets_dir, "*", false, true)
            end

            if #files == 0 then
                vim.notify("No snippets found in " .. snippets_dir, vim.log.levels.WARN)
                return
            end

            local items = {}
            for _, filepath in ipairs(files) do
                table.insert(items, {
                    name = vim.fn.fnamemodify(filepath, ":t:r"),
                    path = filepath,
                })
            end

            vim.ui.select(
                vim.tbl_map(function(item) return item.name end, items),
                { prompt = "Insert snippet: " },
                function(choice, idx)
                    if not choice then return end
                    local lines = vim.fn.readfile(items[idx].path)
                    -- Insert snippet content at cursor position
                    local row = vim.api.nvim_win_get_cursor(0)[1]
                    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
                end
            )
        end, {
            silent = true,
            desc = 'Pick and insert a snippet from snippets folder'
        })
    end
}
