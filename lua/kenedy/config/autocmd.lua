local group = vim.api.nvim_create_augroup("KenedyWindowOptions", { clear = true })

-- 'wrap' belongs to a window: refresh it when switching buffers as well.
vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
	group = group,
	callback = function()
		local prose = { markdown = true, tex = true, plaintex = true }
		vim.wo.wrap = prose[vim.bo.filetype] == true
	end,
})
