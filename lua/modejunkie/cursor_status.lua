local M = {}
local colors = require("modejunkie.colors")

M.config = {
  disabled_filetypes = {
    "alpha", "dashboard", "lazy", "mason", "TelescopePrompt",
    "NvimTree", "neo-tree", "Trouble", "noice", "notify",
    "toggleterm", "help",
  },
  disabled_buftypes = { "terminal", "prompt", "quickfix", "nofile" },
  padding = 1,
  max_filename = 20,
}

local MODE_MAP = {
  n       = { label = "NORMAL",   hl = "CursorStatusNormal"  },
  i       = { label = "INSERT",   hl = "CursorStatusInsert"  },
  v       = { label = "VISUAL",   hl = "CursorStatusVisual"  },
  V       = { label = "V-LINE",   hl = "CursorStatusVisual"  },
  ["\22"] = { label = "V-BLOCK",  hl = "CursorStatusVisual"  },
  s       = { label = "SELECT",   hl = "CursorStatusSelect"  },
  S       = { label = "S-LINE",   hl = "CursorStatusSelect"  },
  ["\19"] = { label = "S-BLOCK",  hl = "CursorStatusSelect"  },
  R       = { label = "REPLACE",  hl = "CursorStatusReplace" },
  c       = { label = "COMMAND",  hl = "CursorStatusCommand" },
  no      = { label = "OP-PEND",  hl = "CursorStatusOp"     },
  t       = { label = "TERMINAL", hl = "CursorStatusTerminal" },
}

local state = { buf = nil, win = nil, enabled = true, last_modified = false, last_width = 0 }

local function tbl_set(list)
  local s = {}
  for _, v in ipairs(list) do s[v] = true end
  return s
end

function M.define_highlights()
  local hls = {
    CursorStatusNormal   = { fg = colors.normal.muted,   bg = "none" },
    CursorStatusInsert   = { fg = colors.insert.muted,   bg = "none" },
    CursorStatusVisual   = { fg = colors.visual.muted,   bg = "none" },
    CursorStatusSelect   = { fg = colors.select.muted,   bg = "none" },
    CursorStatusReplace  = { fg = colors.replace.muted,  bg = "none" },
    CursorStatusTerminal = { fg = colors.terminal.muted, bg = "none" },
    CursorStatusCommand  = { fg = colors.command.muted,  bg = "none" },
    CursorStatusOp       = { fg = "#cc7b4d",             bg = "none" },
    CursorStatusFile     = { fg = "#606880",             bg = "none" },
    CursorStatusModified = { fg = "#bb5a6c",             bg = "none" },
    CursorStatusWin      = { link = "Pmenu" },
    CursorStatusBorder   = { fg = "#2e3248",             bg = "none" },
  }
  for group, opts in pairs(hls) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

local function is_disabled()
  return M._disabled_ft[vim.bo.filetype] or M._disabled_bt[vim.bo.buftype]
end

local function build_content()
  local raw_mode  = vim.fn.mode(1)
  local mode_info = MODE_MAP[raw_mode] or MODE_MAP[raw_mode:sub(1,1)]
                    or { label = raw_mode:upper(), hl = "CursorStatusNormal" }
  local fname = vim.fn.expand("%:t")
  if fname == "" then fname = "[No Name]" end
  if #fname > M.config.max_filename then
    fname = "…" .. fname:sub(-(M.config.max_filename - 1))
  end
  local modified = vim.bo.modified and " ●" or ""
  local pad      = string.rep(" ", M.config.padding)
  local lbl      = mode_info.label
  local line     = pad .. lbl .. pad .. fname .. modified .. pad
  return {
    line   = line,
    mode_hl = mode_info.hl,
    mode_s = #pad,             mode_e = #pad + #lbl,
    file_s = #pad + #lbl + #pad, file_e = #pad + #lbl + #pad + #fname,
    mod_s  = #pad + #lbl + #pad + #fname, mod_e = #line - #pad,
  }
end

local function compute_position(w)
  local spos = vim.fn.screenpos(0, vim.fn.line("."), vim.fn.col("."))
  -- Pin to right edge; +2 accounts for the left/right border chars
  local col = vim.o.columns - (w + 2) - (spos.col - 1)
  -- Place below cursor, but flip above if within 3 rows of bottom
  local row = (spos.row + 3 > vim.o.lines) and -3 or 1
  return { row = row, col = col }
end

local function ensure_buf()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then return state.buf end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"; vim.bo[buf].bufhidden = "hide"; vim.bo[buf].swapfile = false
  state.buf = buf; return buf
end

local NS = vim.api.nvim_create_namespace("modejunkie")

local function hide_win()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true); state.win = nil
  end
end

local function reposition()
  if not (state.win and vim.api.nvim_win_is_valid(state.win)) then return end
  local pos = compute_position(state.last_width)
  vim.api.nvim_win_set_config(state.win, {
    relative = "cursor", row = pos.row, col = pos.col,
    width = state.last_width, height = 1,
  })
end

local function open_or_update(content, pos)
  local buf = ensure_buf()
  local w   = vim.fn.strdisplaywidth(content.line)
  state.last_width = w
  local cfg = {
    relative = "cursor", row = pos.row, col = pos.col,
    width = w, height = 1, style = "minimal",
    focusable = false, zindex = 10,
  }
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_config(state.win, cfg)
  else
    state.win = vim.api.nvim_open_win(buf, false, vim.tbl_extend("force", cfg, { noautocmd = true }))
    vim.api.nvim_set_option_value("winhighlight",
      "Normal:CursorStatusWin,NormalFloat:CursorStatusWin,FloatBorder:CursorStatusBorder", { win = state.win })
    for _, opt in ipairs({"wrap","number","relativenumber","cursorline"}) do
      vim.api.nvim_set_option_value(opt, false, { win = state.win })
    end
    vim.api.nvim_set_option_value("signcolumn", "no", { win = state.win })
  end
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { content.line })
  vim.bo[buf].modifiable = false
  vim.api.nvim_buf_clear_namespace(buf, NS, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, NS, content.mode_hl,         0, content.mode_s, content.mode_e)
  vim.api.nvim_buf_add_highlight(buf, NS, "CursorStatusFile",      0, content.file_s, content.file_e)
  vim.api.nvim_buf_add_highlight(buf, NS, "CursorStatusModified",  0, content.mod_s,  content.mod_e)
end

function M.update()
  if not state.enabled or is_disabled() then hide_win(); return end
  local mc = vim.fn.mode(1):sub(1,1)
  if mc == "c" or mc == "r" then hide_win(); return end
  local content = build_content()
  local pos     = compute_position(vim.fn.strdisplaywidth(content.line))
  vim.schedule(function()
    if not state.enabled or is_disabled() then hide_win(); return end
    open_or_update(content, pos)
  end)
end

function M.toggle()
  state.enabled = not state.enabled
  if state.enabled then M.update() else hide_win() end
  vim.notify("Cursor status: " .. (state.enabled and "enabled" or "disabled"),
    vim.log.levels.INFO, { title = "cursor_status" })
end

function M.setup(user_config)
  -- Clear existing augroup first so re-setup properly cleans up old autocmds
  local g = vim.api.nvim_create_augroup("CursorStatus", { clear = true })

  -- Allow disabling entirely: `floating_tip = false`
  if user_config == false then
    state.enabled = false
    hide_win()
    return
  end

  if user_config then M.config = vim.tbl_deep_extend("force", M.config, user_config) end
  M._disabled_ft = tbl_set(M.config.disabled_filetypes)
  M._disabled_bt = tbl_set(M.config.disabled_buftypes)
  M.define_highlights()
  vim.api.nvim_create_autocmd("ModeChanged",               { group=g, pattern="*", callback=M.update })
  vim.api.nvim_create_autocmd({"BufEnter","BufWritePost"}, { group=g, pattern="*", callback=M.update })
  vim.api.nvim_create_autocmd({"WinEnter"},                { group=g, pattern="*", callback=M.update })
  vim.api.nvim_create_autocmd({"WinLeave","CmdwinEnter"},  { group=g, pattern="*", callback=hide_win })
  vim.api.nvim_create_autocmd("CmdwinLeave",               { group=g, pattern="*", callback=M.update })
  vim.api.nvim_create_autocmd("VimLeave",                  { group=g, pattern="*", callback=hide_win })
  vim.api.nvim_create_autocmd("ColorScheme",               { group=g, pattern="*", callback=function()
    M.define_highlights(); M.update()
  end })
  vim.api.nvim_create_autocmd({"CursorMoved","CursorMovedI"}, { group=g, pattern="*", callback=reposition })
  vim.api.nvim_create_autocmd({"TextChanged","TextChangedI"}, { group=g, pattern="*", callback=function()
    local cur = vim.bo.modified
    if cur ~= state.last_modified then state.last_modified = cur; M.update() end
  end })
  vim.schedule(M.update)
end

return M
