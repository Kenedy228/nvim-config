local group = vim.api.nvim_create_augroup("KenedyWindowOptions", { clear = true })

-- 'wrap' belongs to a window: refresh it when switching buffers as well.
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType" }, {
	group = group,
	callback = function()
		vim.wo.wrap = true
		vim.wo.linebreak = true
		vim.wo.breakindent = true
		vim.wo.spell = vim.bo.filetype == "markdown"
	end,
})
