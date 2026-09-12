local function wide()
	return vim.o.columns >= 100
end

local function spacious()
	return vim.o.columns >= 130
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "auto",
			globalstatus = true,
			component_separators = { left = "│", right = "│" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { statusline = { "lazy", "mason" } },
		},
		sections = {
			lualine_a = { { "mode", fmt = function(mode) return wide() and mode or mode:sub(1, 1) end } },
			lualine_b = {
				{ "branch", icon = "", cond = wide },
				{
					"diff",
					source = function()
						local git = vim.b.gitsigns_status_dict
						if git then
							return { added = git.added, modified = git.changed, removed = git.removed }
						end
					end,
					symbols = { added = "+", modified = "~", removed = "-" },
					cond = wide,
				},
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					sections = { "error", "warn" },
					symbols = { error = " ", warn = " " },
				},
			},
			lualine_c = {
				{
					"filename",
					path = 1,
					shorting_target = 50,
					symbols = { modified = "●", readonly = "", unnamed = "[No Name]", newfile = "[New]" },
					newfile_status = true,
				},
			},
			lualine_x = {
				{ "lsp_status", icon = "", cond = spacious },
				{ "encoding", cond = spacious },
				{ "fileformat", cond = spacious },
				{ "filetype", cond = wide },
			},
			lualine_y = { { "progress", cond = wide } },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {}, lualine_b = {},
			lualine_c = { { "filename", path = 1 } },
			lualine_x = { "location" },
			lualine_y = {}, lualine_z = {},
		},
		extensions = { "oil", "quickfix" },
	},
}
