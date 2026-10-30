return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
		"mfussenegger/lua-debug.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_dap = require("mason-nvim-dap")
		local dap = require("dap")
		local ui = require("dapui")
		local dap_virtual_text = require("nvim-dap-virtual-text")

		-- Dap Virtual Text
		dap_virtual_text.setup()

		mason_dap.setup({
			ensure_installed = { "cppdbg", "bash-debug-adapter" },
			automatic_installation = true,
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		})

		-- Adapters
		-- C/CPP/Rust
		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
		}
		-- Bash
		dap.adapters.bashdb = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
			name = "bashdb",
		}

		-- Configurations
		-- C/CPP/Rust
		dap.configurations.c = {
			{
				name = "Launch",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			},
			{
				name = "Select and attach to process",
				type = "gdb",
				request = "attach",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				pid = function()
					local name = vim.fn.input("Executable name (filter): ")
					return require("dap.utils").pick_process({ filter = name })
				end,
				cwd = "${workspaceFolder}",
			},
			{
				name = "Attach to gdbserver :1234",
				type = "gdb",
				request = "attach",
				target = "localhost:1234",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
			},
		}
		dap.configurations.cpp = dap.configurations.c
		dap.configurations.rust = dap.configurations.c

		-- Bash
		dap.configurations.sh = {
			{
				type = "bashdb",
				request = "launch",
				name = "Launch file",
				showDebugOutput = true,
				pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
				pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
				trace = true,
				file = "${file}",
				program = "${file}",
				cwd = "${workspaceFolder}",
				pathCat = "cat",
				pathBash = "/bin/bash",
				pathMkfifo = "mkfifo",
				pathPkill = "pkill",
				args = {},
				argsString = "",
				env = {},
				terminalKind = "integrated",
			},
		}

		-- Dap UI

		ui.setup()

		vim.fn.sign_define("DapBreakpoint", { text = "🔴" })

		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			ui.close()
		end

		-- Key binds
		-- Toggle Breakpoint
		vim.keymap.set("n", "<leader>dt", function()
			require("dap").toggle_breakpoint()
		end, { desc = "Toggle Breakpoint" })

		-- List Breakpoints
		vim.keymap.set("n", "<leader>db", function()
			require("dap").list_breakpoints()
		end, { desc = "List Breakpoints" })

		-- Continue
		vim.keymap.set("n", "<leader>dc", function()
			require("dap").continue()
		end, { desc = "Continue" })

		-- Step Into
		vim.keymap.set("n", "<leader>di", function()
			require("dap").step_into()
		end, { desc = "Step Into" })

		-- Step Over
		vim.keymap.set("n", "<leader>do", function()
			require("dap").step_over()
		end, { desc = "Step Over" })

		-- Step Out
		vim.keymap.set("n", "<leader>du", function()
			require("dap").step_out()
		end, { desc = "Step Out" })

		-- Run Last
		vim.keymap.set("n", "<leader>dl", function()
			require("dap").run_last()
		end, { desc = "Run Last" })

		-- Set Exception Breakpoints
		vim.keymap.set("n", "<leader>de", function()
			require("dap").set_exception_breakpoints({ "all" })
		end, { desc = "Set Exception Breakpoints" })

		-- Open REPL
		vim.keymap.set("n", "<leader>dr", function()
			require("dap").repl.open()
		end, { desc = "Open REPL" })

		-- Quit
		vim.keymap.set("n", "<leader>dq", function()
			require("dap").terminate()
			require("dapui").close()
			require("nvim-dap-virtual-text").toggle()
		end, { desc = "Quit Debugging" })
	end,
}
