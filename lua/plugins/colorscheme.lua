-- Catppuccin Mocha: deep charcoal base, royal mauve/lavender accents,
-- gold highlights. Transparent so the terminal background shows through.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before everything else
  lazy = false, -- override defaults.lazy so the colorscheme applies at startup
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- "latte" | "frappe" | "macchiato" | "mocha"
      transparent_background = true, -- let the terminal background show through
      styles = {
        comments = { "italic" },
        keywords = { "bold" },
      },
      -- Only the integrations for plugins actually in this config.
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        indent_blankline = { enabled = true },
        mason = true,
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            warnings = { "undercurl" },
          },
        },
        nvimtree = true,
        rainbow_delimiters = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
      -- Royal touches: gold cursor line number, mauve floats/borders.
      custom_highlights = function(c)
        return {
          CursorLineNr = { fg = c.yellow, style = { "bold" } }, -- gold current line
          FloatBorder = { fg = c.mauve },
          TelescopeBorder = { fg = c.mauve },
          TelescopePromptPrefix = { fg = c.yellow },
          TelescopeSelectionCaret = { fg = c.yellow },
          WinSeparator = { fg = c.surface1 },
          Visual = { bg = c.surface1, style = { "bold" } },
        }
      end,
    })
    vim.cmd("colorscheme catppuccin")

    -- Used to dim the gutter (line numbers, signs, folds) in inactive splits.
    -- Catppuccin's "overlay0" tone — see core/autocmds.lua.
    local function set_gutter_dim()
      vim.api.nvim_set_hl(0, "GutterDim", { fg = "#6c7086" })
    end
    set_gutter_dim()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("UserGutterDim", { clear = true }),
      callback = set_gutter_dim,
    })
  end,
}
