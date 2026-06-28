-- lua/plugins/rose-pine.lua
return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000, -- load before everything else
  lazy = false, -- override defaults.lazy so the colorscheme applies at startup
  config = function()
    require("rose-pine").setup({
      variant = "main", -- "main" | "moon" | "dawn" — try :Telescope colorscheme
      styles = {
        transparency = true, -- let the terminal background show through
        italic = false,
        bold = true,
      },
    })
    vim.cmd("colorscheme rose-pine")
  end,
}
