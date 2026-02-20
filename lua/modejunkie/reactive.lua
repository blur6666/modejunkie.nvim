local M = {}
local colors = require("modejunkie.colors")

function M.setup()
  local ok, reactive = pcall(require, "reactive")
  if not ok then return end

  -- Vivid cursorline highlight per mode.
  reactive.add_preset({
    name = "cursorline",
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
