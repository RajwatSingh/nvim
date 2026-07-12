-- Grape Soda: deep grape-purple base fading to lavender text, with a pop of
-- lime green. Built on Catppuccin Mocha, recolored via color_overrides so all
-- integrations keep working. Transparent so the terminal background shows through.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before everything else
  lazy = false, -- override defaults.lazy so the colorscheme applies at startup
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- "latte" | "frappe" | "macchiato" | "mocha"
      transparent_background = true, -- let the terminal background show through
      -- Grape Soda palette — same color roles Catppuccin uses, retinted.
      color_overrides = {
        mocha = {
          rosewater = "#e0c8f0",
          flamingo = "#e0a3d0",
          pink = "#e8a0e0",
          mauve = "#b28df0", -- grape
          red = "#f26d9c",
          maroon = "#f487ab",
          peach = "#f0a95e",
          yellow = "#f2d06b",
          green = "#b8f24d", -- the lime green pop
          teal = "#8fe0c0",
          sky = "#a3edd0",
          sapphire = "#93c9f0",
          blue = "#9d7ae8", -- grape-blue
          lavender = "#c4b0f0",
          text = "#e4d9f7",
          subtext1 = "#c3b3e6",
          subtext0 = "#a99cd0",
          overlay2 = "#8b7db0",
          overlay1 = "#726690",
          overlay0 = "#5b5175",
          surface2 = "#43335c",
          surface1 = "#332548",
          surface0 = "#241934",
          base = "#181022",
          mantle = "#130d1c",
          crust = "#0e0a15",
        },
      },
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
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            warnings = { "undercurl" },
          },
        },
        nvimtree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
      -- Royal touches: gold cursor line number, mauve floats/borders.
      custom_highlights = function(c)
        return {
          CursorLine = { bg = c.surface0 }, -- subtle tint one step above the transparent base
          LineNr = { fg = c.overlay1 }, -- brighter than the default surface1, readable on the transparent bg
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
  end,
}
