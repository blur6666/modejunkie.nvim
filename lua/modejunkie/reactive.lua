local M = {}
local colors = require("modejunkie.colors")

-- Returns true when the current window should NOT receive mode-coloring.
-- We only want cursorline/linenr colors in real editor buffers:
--   buftype == ""  → normal file buffer (not a plugin panel/quickfix/etc.)
--   buflisted      → buffer is user-visible (not scratch/hidden UI buffers)
-- Floating windows are also excluded even when focusable.
local function skip_non_editor()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype ~= "" then return true end
  if not vim.bo[buf].buflisted then return true end
  local cfg = vim.api.nvim_win_get_config(0)
  if cfg.relative and cfg.relative ~= "" then return true end
  return false
end

function M.setup()
  local ok, reactive = pcall(require, "reactive")
  if not ok then return end

  -- Vivid cursorline highlight per mode.
  reactive.add_preset({
    name = "cursorline",
    skip = skip_non_editor,
    init = function()
      vim.opt.cursorline = true
      -- LazyVim (and some UI configs) often set `cursorlineopt=number`, which
      -- makes the horizontal CursorLine highlight invisible. modejunkie wants
      -- the full mode tint across the whole line, so force line+number.
      local clo = vim.o.cursorlineopt
      if type(clo) == "string" and not clo:match("line") then
        vim.o.cursorlineopt = "both"
      end
    end,
    modes = {
      n = {
        winhl = {
          CursorLine   = { bg = colors.normal.bg },
          CursorLineNr = { fg = colors.normal.vivid, bold = true },
        },
      },
      i = {
        winhl = {
          CursorLine   = { bg = colors.insert.bg },
          CursorLineNr = { fg = colors.insert.vivid, bold = true },
        },
      },
      [{ "v", "V", "\x16" }] = {
        winhl = {
          CursorLine   = { bg = colors.visual.bg },
          CursorLineNr = { fg = colors.visual.vivid, bold = true },
        },
      },
      [{ "s", "S", "\x13" }] = {
        winhl = {
          CursorLine   = { bg = colors.select.bg },
          CursorLineNr = { fg = colors.select.vivid, bold = true },
        },
      },
      R = {
        winhl = {
          CursorLine   = { bg = colors.replace.bg },
          CursorLineNr = { fg = colors.replace.vivid, bold = true },
        },
      },
      t = {
        winhl = {
          CursorLine   = { bg = colors.terminal.bg },
          CursorLineNr = { fg = colors.terminal.vivid, bold = true },
        },
      },
      c = {
        winhl = {
          CursorLine   = { bg = colors.command.bg },
          CursorLineNr = { fg = colors.command.vivid, bold = true },
        },
      },
      no = {
        operators = {
          d = { winhl = { CursorLine = { bg = colors.op.delete.bg }, CursorLineNr = { fg = colors.op.delete.vivid, bold = true } } },
          y = { winhl = { CursorLine = { bg = colors.op.yank.bg },   CursorLineNr = { fg = colors.op.yank.vivid,   bold = true } } },
          c = { winhl = { CursorLine = { bg = colors.op.change.bg }, CursorLineNr = { fg = colors.op.change.vivid, bold = true } } },
        },
      },
    },
  })

  -- Color all line numbers (LineNr) with vivid, distinct colors per mode.
  -- Uses hl (global nvim_set_hl) instead of winhl to avoid Neovim 0.11
  -- winhighlight inconsistencies with LineNr during visual mode transitions.
  reactive.add_preset({
    name = "linenr",
    skip = skip_non_editor,
    static = {
      winhl = {
        inactive = { LineNr = { fg = "#606880" } }, -- neutral for inactive windows
      },
    },
    modes = {
      n = {
        hl = { LineNr = { fg = colors.normal.vivid, bold = true } },
      },
      i = {
        hl = { LineNr = { fg = colors.insert.vivid, bold = true } },
      },
      [{ "v", "V", "\x16" }] = {
        hl = { LineNr = { fg = colors.visual.vivid, bold = true } },
      },
      [{ "s", "S", "\x13" }] = {
        hl = { LineNr = { fg = colors.select.vivid, bold = true } },
      },
      R = {
        hl = { LineNr = { fg = colors.replace.vivid, bold = true } },
      },
      t = {
        hl = { LineNr = { fg = colors.terminal.vivid, bold = true } },
      },
      c = {
        hl = { LineNr = { fg = colors.command.vivid, bold = true } },
      },
      no = {
        operators = {
          d = { hl = { LineNr = { fg = colors.op.delete.vivid, bold = true } } },
          y = { hl = { LineNr = { fg = colors.op.yank.vivid,   bold = true } } },
          c = { hl = { LineNr = { fg = colors.op.change.vivid, bold = true } } },
        },
      },
    },
  })
end

return M
