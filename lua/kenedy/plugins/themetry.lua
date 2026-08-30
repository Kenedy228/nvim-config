return {
	"zaldih/themery.nvim",
	lazy = false,
	config = function()
		require("themery").setup({
			themes = { "ring0dark", "github_dark_high_contrast", "rose-pine", "zenbones", "gruber-darker", "koda" }
		})
	end
}
