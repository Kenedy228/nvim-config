return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "NvimTreeToggle",
	opts = {
		view = { width = 35 },
		filters = { dotfiles = false },
	},
}
