local M = {}

function M.setup(opts)
  opts = opts or {}

  -- 1. Mode-colored cursor
  require("modejunkie.cursor").setup(opts.cursor)

  -- 2. Make sure the UI indicators are actually visible.
  -- This enables `number`/`cursorline` in real editor buffers and fixes
  -- `cursorlineopt` if it's set to only highlight the number.
  require("modejunkie.options").setup(opts.defaults)

  -- 3. Floating tip/window showing mode + filename (near cursor)
  -- Default: disabled. Set floating_tip = true to enable.
  local enable_floating = opts.floating_tip == true or opts.floating_window == true
  if enable_floating then
    require("modejunkie.cursor_status").setup(opts.cursor_status)
  else
    require("modejunkie.cursor_status").setup(false)
  end

  -- 4. Register reactive presets (cursorline + linenr) if reactive.nvim is loaded
  require("modejunkie.reactive").setup()

  -- 5. Re-apply cursor highlight after any colorscheme change
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("ModeJunkieHighlights", { clear = true }),
    pattern = "*",
    callback = function()
      require("modejunkie.cursor").apply()
    end,
  })
end

return M
