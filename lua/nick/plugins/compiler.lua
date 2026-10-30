return {
	{ -- This plugin
		"Zeioth/compiler.nvim",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
		opts = {},
	},
	{ -- The task runner we use
		"stevearc/overseer.nvim",
		commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		opts = {
			task_list = {
				direction = "bottom",
				min_height = 25,
				max_height = 25,
				default_detail = 1,
			},
		},
	},
	-- Key binds
	-- Open compiler
	vim.api.nvim_set_keymap(
		"n",
		"<leader>co",
		"<cmd>CompilerOpen<cr>",
		{ desc = "[O]pen Complier", noremap = true, silent = true }
	),

	-- Redo last selected option
	vim.api.nvim_set_keymap(
		"n",
		"<leader>cr",
		"<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
			.. "<cmd>CompilerRedo<cr>",
		{ desc = "[R]edo Compile", noremap = true, silent = true }
	),

	-- Toggle compiler results
	vim.api.nvim_set_keymap(
		"n",
		"<leader>ct",
		"<cmd>CompilerToggleResults<cr>",
		{ desc = "[T]oggle Compiler", noremap = true, silent = true }
	),
}
