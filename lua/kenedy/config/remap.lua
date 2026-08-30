-- basic remaps
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>", { desc = "применить изменения в конфиге" })

-- telescope bindings
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "открыть поиск файлов внутри проекта" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "открыть поиск по слову среди файлов проекта" })

-- lsp bindings
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "форматировать файл через lsp-сервак" })

vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "переход к определению переменной" })
vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "открыть окно описания" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references,
	{ desc = "показывает все ссылки/использования переменной в проекте" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "переименовать переменную во всем проекте" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "вызывать тулу для исправления" })

vim.keymap.set("n", "<leader>[d", vim.diagnostic.goto_next, { desc = "перейти к следующей ошибке/ворнингу" })
vim.keymap.set("n", "<leader>]d", vim.diagnostic.goto_prev, { desc = "перейти к предыдущей ошибке/ворнингу" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- oil bindings
vim.keymap.set("n", "<leader>pv", ":Oil<CR>", { desc = "открыть родительскую директорию через Oil" })

-- undotree bindings
vim.keymap.set("n", "<leader>1", vim.cmd.UndotreeToggle, { desc = "открыть локальную историю изменений файла" })

-- gitsigns bindings
local gs = require("gitsigns")

vim.keymap.set("n", "<leader>[h", gs.next_hunk, { desc = "прыгнуть к следующему изменению в файле" })
vim.keymap.set("n", "<leader>]h", gs.prev_hunk, { desc = "прыгнуть к предыдущему изменению в файле" })
vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "добавить изменения в stage индекс" })
vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { desc = "сбросить изменения из stage индекса" })
vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "откатить изменения в блоке до состояния из HEAD" })
vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { desc = "откатить изменения в файле до состояния из HEAD" })
vim.keymap.set("n", "<leader>hd", gs.diffthis, { desc = "diff относительно последнего комита" })
vim.keymap.set("n", "<leader>hb", gs.blame_line, { desc = "показать изменения из гита на текущей строчке" })

-- harpoon bindings
local harpoon = require("harpoon")

vim.keymap.set("n", "<leader>px", function() harpoon:list():add() end, { desc = "добавить в индекс текущий буфер" })
vim.keymap.set("n", "<leader>pb", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
	{ desc = "открыть меню с буферами" })

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "перейти к первому буферу" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "перейти ко второму буферу" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "перейти к третьему буферу" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "перейти к четвертому буферу" })
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "перейти к пятому буферу" })
vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end, { desc = "перейти к шестому буферу" })
vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end, { desc = "перейти к седьмому буферу" })
vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end, { desc = "перейти к восьмому буферу" })
vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end, { desc = "перейти к девятому буферу" })

vim.keymap.set("n", "<leader>pn", function() harpoon:list():prev() end, { desc = "перейти к следующему буферу" })
vim.keymap.set("n", "<leader>pN", function() harpoon:list():next() end, { desc = "перейти к предыдущему буферу" })

-- themery
vim.keymap.set("n", "<leader>tt", ":Themery<CR>", { desc = "открыть селектор с темами" })
