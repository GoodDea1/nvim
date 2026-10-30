return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {},
	init = function()
		local config = require("ibl")
		config.setup({
			scope = {
				enabled = true,
				show_start = true,
				show_end = true,
				injected_languages = true,
				highlight = { "Function", "Label" },
				priority = 500,
			},
		})
	end,
}
