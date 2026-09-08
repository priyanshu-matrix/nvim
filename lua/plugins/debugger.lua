return{
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },

    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        --------------------------------------------------
        -- DAP UI
        --------------------------------------------------

        dapui.setup()

        --------------------------------------------------
        -- CodeLLDB
        --------------------------------------------------

        dap.adapters.codelldb = {
            type = "executable",
            command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        }

        --------------------------------------------------
        -- C++
        --------------------------------------------------

        dap.configurations.cpp = {
            {
                name = "Launch C++",
                type = "codelldb",
                request = "launch",

		program = function()
			local file = vim.fn.expand("%:r")
			return vim.fn.input(
				"Executable: ",
				file,
				"file"
			)
		end,

                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
        }

        dap.configurations.c = dap.configurations.cpp

        --------------------------------------------------
        -- Automatically open DAP UI
        --------------------------------------------------

        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end

        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end

        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        --------------------------------------------------
        -- Keymaps
        --------------------------------------------------

	vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint,
	{ desc = "Debug: Toggle Breakpoint" })

	vim.keymap.set("n", "<leader>dc", dap.continue,
	{ desc = "Debug: Continue" })

	vim.keymap.set("n", "<leader>dn", dap.step_over,
	{ desc = "Debug: Step Over" })

	vim.keymap.set("n", "<leader>di", dap.step_into,
	{ desc = "Debug: Step Into" })

	vim.keymap.set("n", "<leader>do", dap.step_out,
	{ desc = "Debug: Step Out" })

	vim.keymap.set("n", "<leader>dq", dap.terminate,
	{ desc = "Debug: Terminate" })

	vim.keymap.set("n", "<leader>du", dapui.toggle,
	{ desc = "Debug: Toggle UI" })

	vim.keymap.set("n", "<leader>dx", function()
		require("dap").repl.clear()
	end, { desc = "DAP: Clear Console" })
end,
}
