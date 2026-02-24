local M = {}
local colors = require("modejunkie.colors")

function M.apply(opts)
  local dark = "#111111"
  local ok, auto = pcall(require, "lualine.themes.auto")
  if ok then
    opts.options = opts.options or {}
    opts.options.theme = vim.tbl_deep_extend("force", auto, {
      normal   = { a = { fg = dark, bg = colors.normal.vivid,   gui = "bold" } },
      insert   = { a = { fg = dark, bg = colors.insert.vivid,   gui = "bold" } },
      visual   = { a = { fg = dark, bg = colors.visual.vivid,   gui = "bold" } },
      select   = { a = { fg = dark, bg = colors.select.vivid,   gui = "bold" } },
      replace  = { a = { fg = dark, bg = colors.replace.vivid,  gui = "bold" } },
      command  = { a = { fg = dark, bg = colors.command.vivid,  gui = "bold" } },
      terminal = { a = { fg = dark, bg = colors.terminal.vivid, gui = "bold" } },
    })
  end
  return opts
end

return M
