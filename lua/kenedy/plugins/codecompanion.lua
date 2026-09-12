local ollama = require("kenedy.ollama")

local function action(command)
	return function()
		ollama.run(ollama.models.chat, function()
			vim.cmd(command)
		end)
	end
end

return {
	"olimorris/codecompanion.nvim",
	version = "v19.24.0",
	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
	dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
	keys = {
		{ "<leader>aa", action("CodeCompanionChat Toggle"), mode = { "n", "v" }, desc = "AI: toggle chat" },
		{ "<leader>ap", action("CodeCompanionActions"), mode = { "n", "v" }, desc = "AI: actions" },
		{ "<leader>ai", function()
			ollama.run(ollama.models.chat, function()
				vim.api.nvim_feedkeys(":CodeCompanion ", "n", false)
			end)
		end, mode = { "n", "v" }, desc = "AI: inline edit" },
		{ "<leader>as", action("CodeCompanionChat Add"), mode = "v", desc = "AI: add selection to chat" },
	},
	opts = {
		opts = { language = "Russian" },
		adapters = {
			http = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						env = { url = ollama.url },
						opts = { request = require("kenedy.ollama_request") },
						raw = { "--noproxy", "127.0.0.1,localhost" },
						schema = {
							model = {
								default = ollama.models.chat,
								choices = {
									[ollama.models.chat] = { opts = { can_use_tools = true, can_reason = true, has_vision = false } },
								},
							},
							think = { default = false },
							num_ctx = { default = 8192 },
							keep_alive = { default = "30m" },
						},
					})
				end,
			},
		},
		interactions = {
			chat = { adapter = "ollama" },
			inline = { adapter = "ollama" },
			cmd = { adapter = "ollama" },
			background = { adapter = "ollama" },
		},
	},
}
