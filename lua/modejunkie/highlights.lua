local M = {}

function M.apply()
  -- transparent background
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
  vim.api.nvim_set_hl(0, "Terminal", { bg = "none" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "none" })

  -- transparent background for neotree
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { bg = "none" })
  vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "none" })
  vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })

  -- transparent background for nvim-tree
  vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = "none" })
  vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

  -- noice cmdline popup
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopup",             { bg = "none" })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder",       { fg = "#e0af68", bg = "none" })       -- yellow (commands)
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", { fg = "#50f872", bg = "none" })       -- green  (search)
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle",        { fg = "#e0af68", bg = "none", bold = true }) -- yellow
  vim.api.nvim_set_hl(0, "NoiceCmdlineIcon",              { fg = "#e0af68" })                    -- yellow
  vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch",        { fg = "#50f872" })                    -- green
  -- per-type icon colors (used via icon_hl_group in noice.lua)
  vim.api.nvim_set_hl(0, "NoiceCmdlineIconCmd",           { fg = "#e0af68" })                    -- yellow
  vim.api.nvim_set_hl(0, "NoiceCmdlineIconShell",         { fg = "#a4ffec" })                    -- mint
  vim.api.nvim_set_hl(0, "NoiceCmdlineIconLua",           { fg = "#7cf8f7" })                    -- cyan
  vim.api.nvim_set_hl(0, "NoiceCmdlineIconHelp",          { fg = "#86a7df" })                    -- periwinkle

  -- noice popupmenu (cmdline completion list)
  vim.api.nvim_set_hl(0, "NoicePopupmenu",         { bg = "none" })
  vim.api.nvim_set_hl(0, "NoicePopupmenuBorder",   { fg = "#e0af68", bg = "none" })
  vim.api.nvim_set_hl(0, "NoicePopupmenuSelected", { fg = "#ddf7ff", bg = "#1a2040", bold = true })
  vim.api.nvim_set_hl(0, "NoicePopupmenuMatch",    { fg = "#50f872", bold = true })

  -- search highlights
  vim.api.nvim_set_hl(0, "Search",    { fg = "#0B0C16", bg = "#85ff9d", bold = true }) -- light green bg
  vim.api.nvim_set_hl(0, "IncSearch", { fg = "#0B0C16", bg = "#50f872", bold = true }) -- bright green bg (active)
  vim.api.nvim_set_hl(0, "CurSearch", { fg = "#0B0C16", bg = "#7cf8f7", bold = true }) -- cyan bg (cursor match)

  -- message area
  vim.api.nvim_set_hl(0, "MsgArea", { fg = "#85E1FB", bg = "none" })

  -- transparent notify background
  vim.api.nvim_set_hl(0, "NotifyINFOBody", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyERRORBody", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyWARNBody", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyTRACEBody", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyINFOTitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyERRORTitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyWARNTitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyTRACETitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyINFOBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyERRORBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyWARNBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { bg = "none" })
end

return M
