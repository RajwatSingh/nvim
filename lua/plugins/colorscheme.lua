-- lua/plugins/rose-pine.lua
return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000, -- load before everything else
  lazy = false, -- override defaults.lazy so the colorscheme applies at startup
  config = function()
    vim.cmd("colorscheme rose-pine")
  end,
}
