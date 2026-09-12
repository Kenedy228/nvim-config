local ollama = require("kenedy.ollama")
local model = ollama.models.completion

return {
	"milanglacier/minuet-ai.nvim",
	init = function()
		ollama.setup()
	end,
	opts = {
		provider = "openai_fim_compatible",
		curl_extra_args = { "--noproxy", "127.0.0.1,localhost" },
		n_completions = 1,
		context_window = 2048,
		request_timeout = 10,
		throttle = 1000,
		debounce = 400,
		provider_options = {
			openai_fim_compatible = {
				name = "Ollama",
				end_point = ollama.url .. "/v1/completions",
				model = model,
				api_key = function()
					return "ollama"
				end,
				optional = { max_tokens = 128, temperature = 0.2, top_p = 0.9 },
			},
		},
	},
	config = function(_, opts)
		require("minuet").setup(opts)
		if #vim.api.nvim_list_uis() > 0 then
			ollama.warmup()
		end
	end,
}
