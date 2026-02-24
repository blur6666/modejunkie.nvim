local M = {}

function M.setup(opts)
  opts = opts or {}

  -- 1. Apply transparency + noice + search highlights (global, ns=0)
  require("modejunkie.highlights").apply()

  -- 1.25 Mode-colored cursor
  require("modejunkie.cursor").setup(opts.cursor)

  -- 1.5 Make sure the UI indicators are actually visible.
  -- This enables `number`/`cursorline` in real editor buffers and fixes
  -- `cursorlineopt` if it's set to only highlight the number.
  require("modejunkie.options").setup(opts.defaults)

  -- 2. Setup floating mode widget
  require("modejunkie.cursor_status").setup(opts.cursor_status)

  -- 3. Register reactive presets (cursorline + linenr) if reactive.nvim is loaded
  require("modejunkie.reactive").setup()

  -- 4. Setup modejunkie LazyReload handler
  require("modejunkie.hotreload").setup()

  -- 5. Re-apply highlights after any colorscheme change
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("ModeJunkieHighlights", { clear = true }),
    pattern = "*",
    callback = function()
      require("modejunkie.highlights").apply()
      require("modejunkie.cursor").apply()
    end,
  })
end

return M
