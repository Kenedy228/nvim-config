local M = {
	url = "http://127.0.0.1:11434",
	models = { completion = "qwen2.5-coder:1.5b", chat = "qwen3:8b" },
}

local state = { models = {}, reason = "Проверка Ollama ещё не завершена", checked = nil, pending = false }
local waiters = {}
local ttl = 15000

local function reason(model)
	return state.reason or ("Модель " .. model .. " не установлена. Выполни: ollama pull " .. model)
end

local function fresh()
	return state.checked ~= nil and vim.uv.now() - state.checked < ttl
end

local function finish(models, failure)
	vim.schedule(function()
		state.models, state.reason = models or {}, failure
		state.checked, state.pending = vim.uv.now(), false
		local callbacks = waiters
		waiters = {}
		for _, entry in ipairs(callbacks) do
			entry.callback(state.models[entry.model] == true, reason(entry.model))
		end
	end)
end

-- Callback always runs on the main loop; simultaneous callers share one probe.
function M.check(model, callback, force)
	if not force and not state.pending and fresh() then
		vim.schedule(function()
			callback(state.models[model] == true, reason(model))
		end)
		return
	end
	table.insert(waiters, { model = model, callback = callback })
	if state.pending then
		return
	end
	state.pending = true
	if vim.fn.executable("curl") ~= 1 then
		finish(nil, "Для локального AI нужен curl. Установи curl и выполни :OllamaRefresh.")
		return
	end
	local ok = pcall(vim.system, {
		"curl", "--silent", "--show-error", "--fail",
		"--noproxy", "127.0.0.1,localhost",
		"--connect-timeout", "1", "--max-time", "2", M.url .. "/api/tags",
	}, { text = true }, function(result)
		if result.code ~= 0 then
			finish(nil, "Ollama недоступна на " .. M.url .. ". Установи/запусти Ollama и выполни :OllamaRefresh.")
			return
		end
		local decoded, data = pcall(vim.json.decode, result.stdout)
		if not decoded or type(data) ~= "table" or type(data.models) ~= "table" then
			finish(nil, "Ollama вернула некорректный список моделей. Проверь сервер и выполни :OllamaRefresh.")
			return
		end
		local models = {}
		for _, item in ipairs(data.models) do
			if type(item) == "table" and type(item.name) == "string" then
				models[item.name] = true
			end
		end
		finish(models)
	end)
	if not ok then
		finish(nil, "Не удалось запустить curl для проверки Ollama. Выполни :OllamaRefresh после установки curl.")
	end
end

function M.available(model)
	if state.pending then
		return false
	end
	if not fresh() then
		M.check(model, function() end)
		return false
	end
	return state.models[model] == true
end

function M.invalidate()
	state.models, state.checked = {}, nil
end

-- User-triggered actions get one explanation; startup and typing stay quiet.
function M.run(model, action)
	local win, buf = vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf()
	M.check(model, function(ok, message)
		if vim.api.nvim_get_current_win() ~= win or vim.api.nvim_get_current_buf() ~= buf then
			return
		end
		if ok then
			action()
		else
			vim.notify(message, vim.log.levels.INFO)
		end
	end, true)
end

function M.warmup()
	M.check(M.models.completion, function(ok)
		if not ok then
			return
		end
		local spawned = pcall(vim.system, {
			"curl", "--silent", "--show-error", "--fail",
			"--noproxy", "127.0.0.1,localhost",
			"--connect-timeout", "1", "--max-time", "120",
			M.url .. "/api/generate", "-H", "Content-Type: application/json",
			"-d", vim.json.encode({
				model = M.models.completion, prompt = " ", stream = false,
				keep_alive = "30m", options = { num_predict = 1 },
			}),
		}, {}, function(result)
			if result.code ~= 0 then
				vim.schedule(M.invalidate)
			end
		end)
		if not spawned then
			M.invalidate()
		end
	end)
end

function M.setup()
	vim.api.nvim_create_user_command("OllamaRefresh", function()
		M.check(M.models.completion, function()
			local lines = {}
			for _, model in ipairs({ M.models.completion, M.models.chat }) do
				table.insert(lines, state.models[model] and (model .. ": доступна") or reason(model))
			end
			vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
			if #vim.api.nvim_list_uis() > 0 then
				M.warmup()
			end
		end, true)
	end, { desc = "Проверить Ollama и локальные AI-модели", force = true })
end

return M
