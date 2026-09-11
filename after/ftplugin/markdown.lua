vim.opt_local.textwidth = 80
vim.opt_local.spelllang = { "ru", "en" }

vim.api.nvim_buf_create_user_command(0, "MarkdownExportPDF", function()
	require("kenedy.markdown").export_pdf()
end, { desc = "Export Markdown to PDF" })
vim.keymap.set("n", "<leader>me", "<cmd>MarkdownExportPDF<CR>", { buffer = true, desc = "Export Markdown to PDF" })

for _, key in ipairs({ "j", "k" }) do
	vim.keymap.set({ "n", "x" }, key, function()
		return vim.v.count == 0 and "g" .. key or key
	end, { buffer = true, expr = true, silent = true, desc = "Move by display line" })
end

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
	.. " | setlocal textwidth< spelllang<"
	.. " | silent! nunmap <buffer> j | silent! nunmap <buffer> k"
	.. " | silent! xunmap <buffer> j | silent! xunmap <buffer> k"
	.. " | silent! nunmap <buffer> <leader>me | silent! delcommand -buffer MarkdownExportPDF"
