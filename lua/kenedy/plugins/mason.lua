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
			local managed = vim.tbl_filter(function(name)
				return servers[name].mason ~= false
			end, vim.tbl_keys(servers))
			table.sort(managed)

			require("mason-lspconfig").setup({
				ensure_installed = managed,
				automatic_enable = false,
			})
		end,
	},
}
