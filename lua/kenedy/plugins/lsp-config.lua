return {
	"neovim/nvim-lspconfig",
	config = function()
		local servers = require("kenedy.config.lsp")

		vim.lsp.enable(vim.tbl_keys(servers))
	end
}
