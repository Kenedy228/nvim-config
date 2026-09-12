return {
	"MagicDuck/grug-far.nvim",
	cmd = { "GrugFar", "GrugFarWithin" },
	opts = {},
	keys = {
		{ "<leader>sr", ":GrugFar<CR>", mode = { "n", "x" }, desc = "Search and replace" },
		{
			"<leader>sw",
			function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>"), flags = "--fixed-strings" } })
			end,
			desc = "Search and replace word under cursor",
		},
	},
}
