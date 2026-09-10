return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		local parsers = require("kenedy.config.treesitter")

		require("nvim-treesitter").setup()

		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
