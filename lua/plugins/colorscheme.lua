-- Rosé Pine Moon: muted, low-contrast-but-legible palette for long sessions.
-- Stock palette, small hue budget (rose/gold/foam/iris/pine/love), no neon.
-- Gold is the focus tier (current line number, search, Telescope matches);
-- everything else stays quiet. Transparent so the terminal shows through.
-- Mirrored in ~/.config/ghostty/themes/RosePineMoon and the
-- [palettes.rose_pine_moon] block of ~/.config/starship.toml — keep in sync.
return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000, -- load before everything else
  lazy = false, -- override defaults.lazy so the colorscheme applies at startup
  config = function()
    require("rose-pine").setup({
      variant = "moon",
      dark_variant = "moon",
      styles = {
        bold = true,
        italic = true, -- Rosé Pine uses italics sparingly (comments, params)
        transparency = true, -- let the terminal background show through
      },
      highlight_groups = {
        CursorLine = { bg = "highlight_low" }, -- subtle tint one step above the transparent base
        CursorLineNr = { fg = "gold", bold = true }, -- gold current line (focus tier)
        -- Rosé Pine maps Comment to muted, which is only ~3:1 on this base.
        -- Subtle is ~4.9:1 (WCAG AA) — comments stay genuinely readable.
        Comment = { fg = "subtle", italic = true },
        WinSeparator = { fg = "highlight_med" },

        -- The pop tier: gold inverted-background lands on the current match
        -- only, so the other matches stay quiet and the live one is
        -- unmistakable. Same idea for the matching paren.
        IncSearch = { fg = "base", bg = "gold", bold = true },
        CurSearch = { fg = "base", bg = "gold", bold = true },
        Substitute = { fg = "base", bg = "gold", bold = true },
        Search = { fg = "text", bg = "highlight_med", bold = true },
        MatchParen = { fg = "gold", bg = "highlight_med", bold = true },

        -- The editor stays transparent; popups get a backing so they don't
        -- read as muddy against the blurred desktop behind Ghostty.
        NormalFloat = { bg = "surface" },
        FloatBorder = { fg = "foam", bg = "surface" },

        -- Borderless Telescope: each border fg matches its own bg, so the
        -- panes read as flat layers instead of boxes.
        TelescopeNormal = { bg = "surface" },
        TelescopeBorder = { fg = "surface", bg = "surface" },
        TelescopeResultsTitle = { fg = "surface", bg = "surface" },
        TelescopePromptNormal = { bg = "overlay" },
        TelescopePromptBorder = { fg = "overlay", bg = "overlay" },
        TelescopePromptTitle = { fg = "base", bg = "foam", bold = true },
        TelescopePreviewTitle = { fg = "base", bg = "iris", bold = true },
        TelescopeSelection = { bg = "highlight_med", bold = true },
        TelescopeMatching = { fg = "gold", bold = true },
        TelescopePromptPrefix = { fg = "foam" },
        TelescopeSelectionCaret = { fg = "foam" },

        IblScope = { fg = "foam" },
      },
    })

    vim.cmd("colorscheme rose-pine-moon")
  end,
}
