-- Run: nvim --headless -u NONE -l tests/ollama.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
local calls, pending, messages = {}, {}, {}
local has_curl = true
vim.fn.executable = function() return has_curl and 1 or 0 end
vim.notify = function(message) table.insert(messages, message) end
vim.system = function(args, _, callback)
	table.insert(calls, args)
	table.insert(pending, callback)
	return { kill = function() end }
end
local function complete(code, body)
	local cb = table.remove(pending, 1)
	assert(cb, 'No pending request')
	cb({ code = code, stdout = body or '', stderr = '' })
	vim.wait(20, function() return false end)
end
local ai = require('kenedy.ollama')
assert(not ai.available(ai.models.completion), 'Unknown state must disable AI')
assert(#calls == 1)
ai.check(ai.models.chat, function(ok) assert(not ok) end)
assert(#calls == 1, 'Concurrent probes must be coalesced')
complete(7)
assert(not ai.available(ai.models.chat))
assert(#messages == 0, 'Offline startup must be silent')
local result
ai.check(ai.models.chat, function(ok, reason) result = {ok, reason} end, true)
complete(0, vim.json.encode({models={{name=ai.models.completion}}}))
assert(ai.available(ai.models.completion))
assert(not result[1] and result[2]:find('ollama pull', 1, true))
local before = #calls
for _ = 1, 100 do ai.available(ai.models.completion) end
assert(#calls == before, 'Do not query per keystroke')
ai.check(ai.models.chat, function(ok) result = ok end, true)
complete(0, vim.json.encode({models={{name=ai.models.chat}}}))
assert(result and not ai.available(ai.models.completion), 'Models must be independent')
ai.check(ai.models.chat, function(ok) result = ok end, true)
complete(0, 'invalid JSON')
assert(not result, 'Malformed responses must disable AI')
ai.check(ai.models.chat, function(ok) result = ok end, true)
complete(0, '{}')
assert(not result, 'Missing model list must disable AI')
ai.check(ai.models.chat, function(ok) result = ok end, true)
complete(0, '{"models":[]}')
assert(not result)
has_curl = false
before = #calls
ai.check(ai.models.chat, function(ok, reason) result = {ok, reason} end, true)
vim.wait(20, function() return result and type(result) == 'table' end)
assert(not result[1] and result[2]:find('curl', 1, true))
assert(#calls == before, 'Missing curl must not spawn a process')
has_curl = true
ai.check(ai.models.chat, function(ok) result = ok end, true)
complete(0, vim.json.encode({models={{name=ai.models.chat},{name=ai.models.completion}}}))
assert(result and ai.available(ai.models.completion), 'Recovery must work without restart')
-- A guarded action must not run after switching buffers during the probe.
local ran = false
ai.run(ai.models.chat, function() ran = true end)
vim.api.nvim_set_current_buf(vim.api.nvim_create_buf(true, false))
complete(0, vim.json.encode({models={{name=ai.models.chat}}}))
assert(not ran)
-- Expired cache rechecks without blocking or enabling a stale source.
local now = vim.uv.now
vim.uv.now = function() return now() + 16000 end
before = #calls
assert(not ai.available(ai.models.chat))
assert(#calls == before + 1)
complete(7)
vim.uv.now = now
-- The CodeCompanion guard also covers requests issued through direct commands.
local request = require('kenedy.ollama_request')
local client = { adapter = { parameters = { model = ai.models.chat }, opts = { request = request } } }
local sent, stopped, failed, finished = 0, false, nil, false
local forwarded
package.loaded['codecompanion.http'] = {
	request = function(copy, _, callbacks)
		assert(copy.adapter.opts.request == nil, 'Hook must not recurse')
		assert(client.adapter.opts.request == request, 'Original adapter must be unchanged')
		sent, forwarded = sent + 1, callbacks
		return {shutdown=function() stopped = true end}
	end,
}
local callbacks = {
	callback = function(err) failed = err end,
	done = function() finished = true end,
}
request(client, {}, callbacks, {})
complete(0, '{"models":[]}')
assert(sent == 0 and failed.message:find('ollama pull', 1, true) and finished)
local cancelled = request(client, {}, callbacks, {})
cancelled:shutdown()
complete(0, vim.json.encode({models={{name=ai.models.chat}}}))
assert(sent == 0, 'Cancelled preflight must not start generation')
local handle = request(client, {}, callbacks, {})
complete(0, vim.json.encode({models={{name=ai.models.chat}}}))
assert(sent == 1)
forwarded.callback({message='server disconnected'})
assert(not ai.available(ai.models.chat), 'Transport failure must invalidate cache')
complete(7)
handle:shutdown()
assert(stopped, 'Cancellation must reach the running job')
before = #calls
ai.warmup()
vim.wait(20, function() return false end)
assert(#calls == before, 'Offline warmup must not generate')
ai.check(ai.models.completion, function() end, true)
complete(0, vim.json.encode({models={{name=ai.models.completion}}}))
ai.warmup()
vim.wait(20, function() return #pending > 0 end)
assert(vim.tbl_contains(calls[#calls], ai.url .. '/api/generate'), 'Warmup must use generate endpoint')
complete(7)
assert(not ai.available(ai.models.completion), 'Failed warmup must disable AI until rechecked')
complete(7)
print('PASS: offline, missing curl/models, malformed replies, cache expiry, recovery, guarded actions/requests, cancellation')
