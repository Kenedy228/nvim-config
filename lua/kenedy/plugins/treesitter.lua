return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master", -- Явное указание старой стабильной ветки
	build = ":TSUpdate",
	config = function()
		local parsers = require("kenedy.config.treesitter")

		require("nvim-treesitter.configs").setup({
			ensure_installed = parsers,
			highlight = {
				enable = true, -- В старой ветке это снова будет работать
			},
		})
	end,
}
