return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {},
		keys = {
			{ "<leader>mp", "<cmd>RenderMarkdown toggle<CR>", ft = "markdown", desc = "Toggle Markdown rendering" },
		},
	},
	{
		"bullets-vim/bullets.vim",
		ft = "markdown",
		init = function()
			vim.g.bullets_enabled_file_types = { "markdown" }
			vim.g.bullets_enable_in_empty_buffers = 0
			vim.g.bullets_checkbox_markers = " x"
		end,
	},
}
