local M = {}
local running = {}

function M.export_pdf()
	local source = vim.api.nvim_buf_get_name(0)
	if source == "" or vim.bo.buftype ~= "" then
		vim.notify("Сначала задайте имя Markdown-файлу через :saveas.", vim.log.levels.ERROR)
		return
	end
	for _, executable in ipairs({ "pandoc", "xelatex" }) do
		if vim.fn.executable(executable) ~= 1 then
			vim.notify("Для экспорта PDF требуется " .. executable .. " в PATH.", vim.log.levels.ERROR)
			return
		end
	end
	local output = vim.fn.fnamemodify(source, ":r") .. ".pdf"
	if running[output] then
		vim.notify("Экспорт этого конспекта уже выполняется.", vim.log.levels.WARN)
		return
	end
	local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") .. "\n"
	running[output] = true
	vim.notify("Создание PDF: " .. output, vim.log.levels.INFO)
	local ok, err = pcall(vim.system, {
		"pandoc",
		"--from=markdown",
		"--pdf-engine=xelatex",
		"--variable=mainfont:DejaVu Serif",
		"--variable=monofont:DejaVu Sans Mono",
		"--variable=geometry:margin=2cm",
		"--variable=papersize:a4",
		"--output=" .. output,
	}, {
		cwd = vim.fn.fnamemodify(source, ":h"),
		stdin = content,
		text = true,
		timeout = 120000,
	}, function(result)
		vim.schedule(function()
			running[output] = nil
			if result.code == 0 then
				vim.notify("PDF создан: " .. output, vim.log.levels.INFO)
			else
				vim.notify("Ошибка экспорта PDF:\n" .. (result.stderr or "Код " .. result.code), vim.log.levels.ERROR)
			end
		end)
	end)
	if not ok then
		running[output] = nil
		vim.notify("Не удалось запустить экспорт PDF: " .. tostring(err), vim.log.levels.ERROR)
	end
end

return M
