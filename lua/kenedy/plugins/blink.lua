return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = { "milanglacier/minuet-ai.nvim" },
	opts = {
		keymap = {
			preset = "default",

			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
		},

		completion = {
			trigger = { prefetch_on_insert = false },
			documentation = {
				auto_show = true,
			},

			menu = {
				auto_show = true,
			},
		},

		signature = {
			enabled = true,
		},

		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"minuet",
			},
			per_filetype = {
				codecompanion = { "codecompanion", "buffer" },
			},
			providers = {
				minuet = {
					enabled = function()
						local ollama = require("kenedy.ollama")
						return ollama.available(ollama.models.completion)
					end,
					name = "minuet", module = "minuet.blink", async = true,
					timeout_ms = 10000, score_offset = 50,
				},
			},
		},

		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
	},
}
