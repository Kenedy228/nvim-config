-- CodeCompanion's public custom-request hook covers chat, inline and commands.
return function(client, payload, actions, opts)
	local ollama = require("kenedy.ollama")
	local cancelled, job = false, nil
	local handle = {
		shutdown = function()
			cancelled = true
			if job and job.shutdown then
				job:shutdown()
			end
		end,
	}
	local model = client.adapter.parameters.model or ollama.models.chat
	ollama.check(model, function(ok, message)
		if cancelled then
			return
		end
		if not ok then
			-- Let CodeCompanion finish the request with one actionable explanation.
			actions.callback({ message = message, stderr = message })
			if actions.done then
				actions.done()
			end
			return
		end
		-- Disable this hook only on a request-local copy, avoiding recursion.
		local copy = setmetatable(vim.tbl_extend("force", {}, client), getmetatable(client))
		copy.adapter = vim.deepcopy(client.adapter)
		copy.adapter.opts.request = nil
		local callbacks = vim.tbl_extend("force", {}, actions)
		callbacks.callback = function(err, ...)
			if err then
				ollama.invalidate()
			end
			if not cancelled then
				actions.callback(err, ...)
			end
		end
		callbacks.done = function(...)
			if not cancelled and actions.done then
				actions.done(...)
			end
		end
		job = require("codecompanion.http").request(copy, payload, callbacks, opts)
	end, true)
	return handle
end
