local dir = vim.fn.tempname()
assert(vim.fn.mkdir(dir, "p") == 1)
local file = dir .. "/Component.svelte"
vim.fn.writefile({ '{"name":"svelte-lsp-test","private":true}' }, dir .. "/package.json")
vim.fn.writefile({ "<script>", "  let =", "</script>" }, file)
vim.cmd.edit(file)

assert(vim.bo.filetype == "svelte", "Svelte filetype was not detected")
assert(vim.wait(8000, function()
	return #vim.lsp.get_clients({ bufnr = 0, name = "svelte" }) > 0
end, 100), "Svelte LSP did not attach")
assert(#vim.lsp.get_clients({ bufnr = 0, name = "lua_ls" }) == 0, "Lua LSP attached to Svelte")
assert(vim.wait(8000, function()
	return #vim.diagnostic.get(0) > 0
end, 100), "Svelte diagnostics were not published")

vim.fn.delete(dir, "rf")
print("Svelte LSP and diagnostics OK")
vim.cmd("qa!")
