return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},

		config = function()
			local servers = require("kenedy.config.lsp")

			require("mason-lspconfig").setup({
				ensure_installed = servers,
			})
		end,
	},
}
