local M = {}

M.config = {
  -- Make line-number and cursorline indicators actually visible.
  number = true,
  -- Keep nil to avoid forcing relative numbers (LazyVim often uses this).
  relativenumber = nil,
  cursorline = true,
  -- If the current value doesn't include "line" (e.g. "number"), modejunkie
  -- will switch it to this value so the horizontal line tint is visible.
  cursorlineopt = "both",

  disabled_filetypes = {
    "alpha", "dashboard", "lazy", "mason", "TelescopePrompt",
    "NvimTree", "neo-tree", "Trouble", "noice", "notify",
    "toggleterm", "help",
  },
  disabled_buftypes = { "terminal", "prompt", "quickfix", "nofile" },
}

local function is_disabled(buf)
  local ft = vim.bo[buf].filetype
  local bt = vim.bo[buf].buftype
  for _, v in ipairs(M.config.disabled_buftypes) do
    if bt == v then return true end
  end
  for _, v in ipairs(M.config.disabled_filetypes) do
    if ft == v then return true end
  end
  return false
end

local function ensure_cursorlineopt()
  local target = M.config.cursorlineopt
  if not target or target == "" then return end
  local clo = vim.o.cursorlineopt
  if type(clo) == "string" and not clo:match("line") then
    vim.o.cursorlineopt = target
  end
end

local function apply(win, buf)
  if not (win and vim.api.nvim_win_is_valid(win)) then return end
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then return end
  if is_disabled(buf) then return end

  if M.config.number ~= nil then
    vim.wo[win].number = M.config.number
  end
  if M.config.relativenumber ~= nil then
    vim.wo[win].relativenumber = M.config.relativenumber
  end
  if M.config.cursorline ~= nil then
    vim.wo[win].cursorline = M.config.cursorline
  end

  ensure_cursorlineopt()
end

function M.setup(user_config)
  -- Allow disabling entirely: `defaults = false`
  if user_config == false then return end
  if user_config then
    M.config = vim.tbl_deep_extend("force", M.config, user_config)
  end

  local g = vim.api.nvim_create_augroup("ModeJunkieDefaults", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    group = g,
    callback = function(args)
      apply(vim.api.nvim_get_current_win(), args.buf)
    end,
  })

  vim.schedule(function()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    apply(win, buf)
  end)
end

return M
