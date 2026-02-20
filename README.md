# modejunkie.nvim

For when your statusline is too far away and you still can't tell what mode you're in.

modejunkie colors **four UI elements simultaneously** based on your current vim mode — cursorline, line numbers, a floating widget near your cursor, and your statusline. No more accidentally typing `iiiiii` into your buffer because you forgot you were in normal mode.

<!-- TODO: add screenshot/demo gif -->

## Features

- **Cursorline** — current line background tinted per mode
- **Line numbers** — all line numbers + current line number colored per mode
- **Floating indicator** — a small widget near your cursor showing mode label, filename, and modified status
- **Lualine** — statusline section A colored per mode

All four update instantly on every mode change, including operator-pending sub-modes (`d`, `y`, `c`).

## Supported modes

| Mode | Label | Color |
|---|---|---|
| Normal | `NORMAL` | `#7aa2f7` blue |
| Insert | `INSERT` | `#ff9e64` orange |
| Visual | `VISUAL` | `#bb9af7` purple |
| V-Line | `V-LINE` | `#bb9af7` purple |
| V-Block | `V-BLOCK` | `#bb9af7` purple |
| Select | `SELECT` | `#9d7cd8` purple |
| S-Line | `S-LINE` | `#9d7cd8` purple |
| S-Block | `S-BLOCK` | `#9d7cd8` purple |
| Replace | `REPLACE` | `#f7768e` red |
| Command | `COMMAND` | `#e0af68` yellow |
| Terminal | `TERMINAL` | `#7dcfff` cyan |
| Op-pending (delete) | `OP-PEND` | `#f7768e` red |
| Op-pending (yank) | `OP-PEND` | `#ff9e64` orange |
| Op-pending (change) | `OP-PEND` | `#7aa2f7` blue |

Each mode has three color variants used across the UI:
- **vivid** — bright foreground (line numbers, labels)
- **muted** — softer foreground (floating widget)
- **bg** — subtle background tint (cursorline)

## Requirements

- Neovim >= 0.9
- [reactive.nvim](https://github.com/rasulomaroff/reactive.nvim) — **required**, drives cursorline and line number coloring
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) — optional, for statusline coloring

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "blur6666/modejunkie.nvim",
  lazy = false,
  priority = 900,
  dependencies = { "rasulomaroff/reactive.nvim" },
  config = function()
    require("modejunkie").setup()
  end,
},
-- Optional: lualine integration
{
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    return require("modejunkie.lualine").apply(opts)
  end,
},
```

## Configuration

Pass options to `setup()` to configure the floating indicator:

```lua
require("modejunkie").setup({
  cursor_status = {
    disabled_filetypes = {
      "alpha", "dashboard", "lazy", "mason", "TelescopePrompt",
      "NvimTree", "neo-tree", "Trouble", "noice", "notify",
      "toggleterm", "help",
    },
    disabled_buftypes = { "terminal", "prompt", "quickfix", "nofile" },
    padding      = 1,   -- horizontal padding inside the floating widget
    max_filename = 20,  -- truncate long filenames
  },
})
```

All options are optional. The defaults above are used when nothing is passed.

## Colors

All mode colors are defined in [`lua/modejunkie/colors.lua`](lua/modejunkie/colors.lua). Edit that file directly to change the palette. The structure is:

```lua
{
  normal  = { vivid = "#7aa2f7", muted = "#5578bb", bg = "#1e2952" },
  insert  = { vivid = "#ff9e64", muted = "#cc8040", bg = "#3a1a08" },
  visual  = { vivid = "#bb9af7", muted = "#8870bb", bg = "#2e1a4a" },
  -- ...
}
```

## Why?

Vim modes are invisible by default. A single character in the statusline, 50 lines away from where you're looking. modejunkie makes the current mode impossible to ignore — your cursorline, your line numbers, your cursor, all shift color the instant you change modes. It's mode awareness for people who don't want to think about it.
