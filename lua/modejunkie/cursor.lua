local M = {}

local colors = require("modejunkie.colors")

M.config = {
  enabled = true,
  force_guicursor = true,
  guicursor_hl = "Cursor",
  groups = { "Cursor", "lCursor", "CursorIM", "TermCursor", "TermCursorNC" },
}

local state = { last_bg = nil }

local function ensure_guicursor_has_hl()
  if not M.config.force_guicursor then return end

  local gc = vim.o.guicursor
  if type(gc) ~= "string" or gc == "" then return end

  local parts = vim.split(gc, ",", { plain = true, trimempty = true })
  local changed = false

  for i, part in ipairs(parts) do
    local colon = part:find(":", 1, true)
    if colon then
      local modes = part:sub(1, colon - 1)
      local is_term = modes:find("t", 1, true) ~= nil

      -- LazyVim sets a highlight group only for terminal-mode cursor by default.
      -- Without an explicit highlight group, terminals keep their own cursor color.
      if not is_term and not part:find("-" .. M.config.guicursor_hl, 1, true) then
        parts[i] = part .. "-" .. M.config.guicursor_hl
        changed = true
      end
    end
  end

  if changed then
    vim.o.guicursor = table.concat(parts, ",")
  end
end

local function hex_to_rgb(hex)
  if type(hex) ~= "string" then return nil end
  local h = hex:gsub("#", "")
  if #h ~= 6 then return nil end
  local r = tonumber(h:sub(1, 2), 16)
  local g = tonumber(h:sub(3, 4), 16)
  local b = tonumber(h:sub(5, 6), 16)
  if not (r and g and b) then return nil end
  return r, g, b
end

local function contrast_fg(bg)
  local r, g, b = hex_to_rgb(bg)
  if not r then return "#0B0C16" end
  -- Relative luminance (rough) to pick a readable fg.
  local y = (r * 299 + g * 587 + b * 114) / 1000
  return (y > 140) and "#0B0C16" or "#F8FAFF"
end

local function mode_color(raw)
  raw = raw or vim.fn.mode(1)
  local m1 = raw:sub(1, 1)

  if raw:sub(1, 2) == "no" then
    local op = vim.v.operator
    if op == "d" then return colors.op.delete.vivid end
    if op == "y" then return colors.op.yank.vivid end
    if op == "c" then return colors.op.change.vivid end
    return "#cc7b4d"
  end

  if m1 == "n" then return colors.normal.vivid end
  if m1 == "i" then return colors.insert.vivid end
  if m1 == "v" or m1 == "V" or m1 == "\22" then return colors.visual.vivid end
  if m1 == "s" or m1 == "S" or m1 == "\19" then return colors.select.vivid end
  if m1 == "R" then return colors.replace.vivid end
  if m1 == "c" then return colors.command.vivid end
  if m1 == "t" then return colors.terminal.vivid end

  return colors.normal.vivid
end

function M.apply(raw_mode)
  if not M.config.enabled then return end

  local bg = mode_color(raw_mode)
  if bg == state.last_bg then return end
  state.last_bg = bg

  local fg = contrast_fg(bg)
  for _, group in ipairs(M.config.groups) do
    vim.api.nvim_set_hl(0, group, { fg = fg, bg = bg })
  end

  -- Force Neovim to re-send terminal cursor color (OSC 12)
  -- after we mutate the highlight used by 'guicursor'.
  if M.config.force_guicursor then
    pcall(vim.api.nvim_set_option_value, "guicursor", vim.o.guicursor, { scope = "global" })
  end
end

function M.setup(user_config)
  if user_config then
    M.config = vim.tbl_deep_extend("force", M.config, user_config)
  end

  ensure_guicursor_has_hl()

  local g = vim.api.nvim_create_augroup("ModeJunkieCursor", { clear = true })
  vim.api.nvim_create_autocmd({ "ModeChanged", "VimEnter", "BufEnter", "TermEnter" }, {
    group = g,
    pattern = "*",
    callback = function()
      -- On ModeChanged, use the new mode from the event when available.
      local ev = vim.v.event or {}
      M.apply(ev.new_mode)
    end,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = g,
    pattern = "*",
    callback = function()
      state.last_bg = nil
      ensure_guicursor_has_hl()
      M.apply()
    end,
  })

  vim.schedule(M.apply)
end

return M
