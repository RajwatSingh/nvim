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

    -- Used to dim the gutter (line numbers, signs, folds) in inactive splits.
    -- Rosé Pine's "muted" tone — see core/autocmds.lua.
    local function set_gutter_dim()
      vim.api.nvim_set_hl(0, "GutterDim", { fg = "#6e6a86" })
    end
    set_gutter_dim()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("UserGutterDim", { clear = true }),
      callback = set_gutter_dim,
    })
  end,
}
