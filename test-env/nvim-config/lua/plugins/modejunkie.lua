return {
  {
    dir = "/root/projects/modejunkie.nvim", -- mounted from host
    name = "modejunkie.nvim",
    lazy = false,
    priority = 900,
    dependencies = { "rasulomaroff/reactive.nvim" },
    config = function()
      require("modejunkie").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      return require("modejunkie.lualine").apply(opts)
    end,
  },
}
