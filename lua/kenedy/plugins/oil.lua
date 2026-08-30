return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-mini/mini.icons", opts = {} },
	lazy = false,
	config = function()
		require("oil").setup({
			columns = {
				"icon",
				"permissions",
			},
			view_options = {
				show_hidden = true,
			},
		})
	end
}
