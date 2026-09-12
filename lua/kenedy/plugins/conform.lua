return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	dependencies = { "mason-org/mason.nvim" },
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = { "n", "v" },
			desc = "Format buffer or selection",
		},
		{
			"<leader>uf",
			function()
				vim.b.disable_autoformat = not vim.b.disable_autoformat
				vim.notify("Format on save: " .. (vim.b.disable_autoformat and "off" or "on"))
			end,
			desc = "Toggle format on save (buffer)",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "goimports", "gofmt" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
		},
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat or vim.bo[bufnr].buftype ~= "" then
				return
			end
			return { timeout_ms = 2000, lsp_format = "fallback" }
		end,
	},
}
