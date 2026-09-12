return {
	{ "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
	{ "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000, opts = {} },
	{ "rebelot/kanagawa.nvim", lazy = false, priority = 1000, opts = {} },
	{ "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000, opts = {} },
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				styles = {
					transparency = true,
				},
			})
		end
	},
	{
		'projekt0n/github-nvim-theme',
		name = 'github-theme',
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require('github-theme').setup({

			})
		end,
	},
	{
		"ring0-rootkit/ring0-dark.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
		end,
	},
	{
		"zenbones-theme/zenbones.nvim",
		-- Optionally install Lush. Allows for more configuration or extending the colorscheme
		-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
		-- In Vim, compat mode is turned on as Lush only works in Neovim.
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
		config = function()
		end
	},
	{
		"blazkowolf/gruber-darker.nvim",
		config = function()
		end
	},
	{
	  "oskarnurm/koda.nvim",
	  lazy = false, -- make sure we load this during startup if it is your main colorscheme
	  priority = 1000, -- make sure to load this before all the other start plugins
	  config = function()
	  end,
	}
}
