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

## Defaults (so you actually see it)

modejunkie enables the minimum editor options needed for the visuals to be visible in normal buffers:

- `number` on (otherwise line-number colors have nothing to color)
- `cursorline` on (otherwise the horizontal tint doesn't render)
- fixes `cursorlineopt` if it's set to `number` (switches to `both` so the full line tint shows)

You can disable this behavior with `defaults = false` (see Configuration).

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

### LazyVim

Create `lua/plugins/modejunkie.lua`:

```lua
return {
  {
    "blur6666/modejunkie.nvim",
    dependencies = { "rasulomaroff/reactive.nvim" },
    opts = {
      -- see Configuration
    },
    config = function(_, opts)
      require("modejunkie").setup(opts)
    end,
  },
  -- Optional: lualine integration
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      return require("modejunkie.lualine").apply(opts)
    end,
  },
}
```

### lazy.nvim (non-LazyVim)

Add to your `require("lazy").setup({ ... })` spec:

```lua
{
  "blur6666/modejunkie.nvim",
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
  -- Optional: enforce sane defaults so indicators are actually visible.
  -- Set `defaults = false` if you don't want modejunkie touching options.
  defaults = {
    number = true,          -- required for line-number coloring to be visible
    relativenumber = nil,   -- keep nil to not force it either way
    cursorline = true,      -- required for cursorline tint to be visible
    cursorlineopt = "both", -- fixes configs like `cursorlineopt=number`
  },
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

To disable all option-tweaking (modejunkie will still apply highlights and the floating indicator):

```lua
require("modejunkie").setup({ defaults = false })
```

All options are optional. The defaults above are used when nothing is passed.

If you don't see the horizontal tint or line-number colors, check these options:

```vim
:set cursorline?
:set cursorlineopt?
:set number?
```

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

## Dev / Docker

This repo includes a throwaway Docker test harness at `test-env/` that boots a fresh LazyVim and loads modejunkie from the local directory.

If you're hacking on the plugin, it's a convenient way to verify "fresh install" behavior without touching your real config.

## Why?

Vim modes are invisible by default. A single character in the statusline, 50 lines away from where you're looking. modejunkie makes the current mode impossible to ignore: your cursorline, your line numbers, your floating indicator, and your statusline all shift color the instant you change modes. It's mode awareness for people who don't want to think about it.
