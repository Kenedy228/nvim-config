# Neovim config

Личный Lua-конфиг: lazy.nvim, Blink, Telescope с fzf, Oil, Harpoon,
Gitsigns, UndoTree, LSP/Mason, Treesitter и VimTeX.

## Требования

Проверено на Linux с Neovim `0.13.0-dev-1572+g318ea4de21`.
Версия nvim-treesitter из `lazy-lock.json` требует Neovim 0.12+ и
[tree-sitter CLI 0.26.1+](https://github.com/nvim-treesitter/nvim-treesitter#requirements).

- `git`, `curl`, `tar`, C-компилятор, `make`, `tree-sitter` в `PATH`.
- `ripgrep` (`rg`) для поиска текста через Telescope; `fd` необязателен.
- Для установки соответствующих LSP через Mason могут потребоваться Node.js/npm
  и Go; ошибки и дополнительные требования доступны в `:Mason` и `:checkhealth mason`.
- Для Dart нужен отдельно установленный Dart/Flutter SDK с командой `dart` в `PATH`.
- Для LaTeX нужны TeX-дистрибутив и `latexmk`; PDF-просмотрщик настраивается в VimTeX.
- Для отображения иконок рекомендуется Nerd Font в терминале.

## Установка и обновления

Если `~/.config/nvim` уже существует, сначала сохрани его отдельно.
Клонируй репозиторий в свободный каталог конфигурации:

```sh
git clone https://github.com/Kenedy228/nvim-config.git ~/.config/nvim
nvim
```

При первом запуске lazy.nvim устанавливает плагины, Mason — управляемые LSP,
Treesitter — недостающие парсеры. Для загрузки нужен интернет; дождись завершения
установки и перезапусти Neovim.

- `:Lazy restore` — восстановить версии плагинов из `lazy-lock.json`.
- `:Lazy update` — обновить плагины и lockfile. Изменения lockfile стоит просмотреть
  и закоммитить отдельно после проверки.
- `:TSUpdate` — обновить парсеры под установленную версию Treesitter.
- `:checkhealth` — проверить окружение; `:checkhealth vim.lsp` — диагностика LSP.

Lockfile фиксирует плагины; версии SDK, Mason-пакетов и системных инструментов
управляются отдельно.

## Настройки редактирования

| Файлы | Отступ | Ширина текста | Визуальный перенос |
|---|---|---|---|
| Lua, JS/JSX, TS/TSX, Svelte, JSON, YAML, Dart | 2 пробела | Без ограничения | Выключен |
| Go | Табуляция, отображение в 4 колонки | Без ограничения | Выключен |
| Markdown, TeX | Зависит от стандартного ftplugin | 80 колонок | Включён |
| Остальные | По умолчанию 4 пробела; ftplugin может переопределить | По умолчанию без ограничения | Выключен |

Вертикальная отметка стоит на 81-й колонке. `textwidth` влияет на форматирование
и автоматический перенос согласно `formatoptions`; `wrap` меняет только отображение.
EditorConfig проекта также может переопределять настройки отступов и ширины.

Undo-история сохраняется между запусками (`undofile`); расположение файлов можно
посмотреть через `:set undodir?`. Swap-файлы выключены.

## LSP и парсеры

Единый список серверов — `lua/kenedy/config/lsp.lua`. Ключ — имя сервера
nvim-lspconfig; `mason = false` исключает его из автоматической установки.
Все перечисленные серверы включаются через `vim.lsp.enable`; автоматическое
включение серверов со стороны Mason отключено.

Dart использует внешний SDK, остальные серверы из списка устанавливает Mason.
Установленные вручную через Mason серверы не включаются, пока их нет в списке.

Парсеры перечислены в `lua/kenedy/config/treesitter.lua`: C, Lua, Vim/Vimdoc,
Query, Go, JavaScript, TypeScript, Svelte, Markdown/Markdown inline, LaTeX и Dart.

## Основные клавиши

`<leader>` — пробел.

| Клавиши | Действие |
|---|---|
| `<leader>ff` | Поиск файлов |
| `<leader>fw` / `<leader>fg` | Поиск текста внутри файлов проекта |
| `<leader>pv` | Oil |
| `<leader>u` | UndoTree |
| `<leader>px` / `<leader>pb` | Добавить файл в Harpoon / открыть список |
| `<leader>1` … `<leader>9` | Перейти к файлу Harpoon |
| `<leader>pn` / `<leader>pN` | Следующий / предыдущий файл Harpoon |
| `<leader>[d` / `<leader>]d` | Предыдущая / следующая диагностика |
| `<leader>[h` / `<leader>]h` | Предыдущее / следующее Git-изменение |
| `<leader>gd` / `<leader>gr` | Определение / использования |
| `<leader>k` / `<leader>rn` / `<leader>ca` | Справка / переименование / code action |
| `<leader>lf` | Форматирование через LSP |
| `<leader>tt` | Выбор темы |
| `<leader>lc` / `<leader>lk` | Запустить / остановить компиляцию LaTeX |
| `<leader>?` | Подсказки which-key |

Основные файлы: `lua/kenedy/config/opts.lua` — общие настройки,
`after/ftplugin/` — настройки языков, `lua/kenedy/config/autocmd.lua` — перенос
строк при переключении буферов, `lua/kenedy/config/remap.lua` — клавиши,
`lua/kenedy/plugins/` — настройки плагинов.

После изменения конфигурации надёжнее перезапустить Neovim: `:source` одного
файла не перезагружает все Lua-модули из кеша `require`.
