return {
	"stevearc/dressing.nvim",
	opts = {},
	init = function()
		require("dressing").setup({
			input = {
				border = "single",
			},
		})
	end,
}
