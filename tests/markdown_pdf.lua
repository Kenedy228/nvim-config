-- Run: nvim --headless -u NONE -l tests/markdown_pdf.lua
-- Requires pandoc, xelatex, pdftotext and DejaVu fonts.
vim.opt.rtp:prepend(vim.fn.getcwd())
local dir = vim.fn.tempname() .. ' заметки с пробелами'
vim.fn.mkdir(dir, 'p')
local messages = {}
vim.notify = function(message, level)
  messages[#messages + 1] = { message = message, level = level }
end
local function export()
  messages = {}
  vim.cmd('MarkdownExportPDF')
  assert(vim.wait(120000, function()
    for _, item in ipairs(messages) do
      if item.level == vim.log.levels.ERROR or item.message:find('PDF создан:', 1, true) then
        return true
      end
    end
    return false
  end, 50), 'Export timed out')
  return messages[#messages]
end
local ok, err = pcall(function()
  local source = dir .. '/конспект $ draft.md'
  vim.fn.writefile({ 'Old disk content' }, source)
  vim.cmd.edit(vim.fn.fnameescape(source))
  dofile('after/ftplugin/markdown.lua')
  assert(vim.fn.exists(':MarkdownExportPDF') == 2, 'Markdown export command is missing')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    '# Конспект', '', 'Новые правки в буфере. English text.', '',
    '$E = mc^2$', '', '| Тема | Балл |', '|---|---|', '| Алгебра | 5 |',
  })
  local result = export()
  assert(result.level ~= vim.log.levels.ERROR, result.message)
  local pdf = dir .. '/конспект $ draft.pdf'
  local converted = vim.system({ 'pdftotext', pdf, '-' }, { text = true }):wait()
  assert(converted.code == 0, converted.stderr)
  assert(converted.stdout:find('Новые правки', 1, true), converted.stdout)
  assert(converted.stdout:find('Алгебра', 1, true), converted.stdout)
  assert(vim.bo.modified, 'Export must not save the Markdown buffer')
  assert(vim.fn.readfile(source)[1] == 'Old disk content')
  vim.fn.mkdir(dir .. '/assets', 'p')
  assert(vim.uv.fs_copyfile(pdf, dir .. '/assets/figure.pdf'))
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { '```{=latex}', '\\UndefinedExportTestCommand', '```' })
  local failure = export()
  assert(failure.level == vim.log.levels.ERROR, 'LaTeX failure must be reported')
  assert(failure.message:find('Undefined control sequence', 1, true), failure.message)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    '# Обновлено', '', 'Повторный экспорт.', '', '![Рисунок](assets/figure.pdf){width=30mm}',
  })
  assert(export().level ~= vim.log.levels.ERROR)
  converted = vim.system({ 'pdftotext', pdf, '-' }, { text = true }):wait()
  assert(converted.stdout:find('Повторный экспорт', 1, true))
  assert(converted.stdout:find('Новые правки', 1, true), 'Relative PDF image was not embedded')
  vim.cmd('enew!')
  dofile('after/ftplugin/markdown.lua')
  assert(export().level == vim.log.levels.ERROR, 'Unnamed buffer must produce a useful error')
  print('PASS: Cyrillic, math, table, relative image; spaces and shell characters in path; unsaved changes; failure and retry; unnamed buffer')
end)
vim.fn.delete(dir, 'rf')
if not ok then error(err) end
