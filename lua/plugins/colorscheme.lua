-- Neon Tide: deep midnight-navy base with vibrant azure, mint-teal, coral and
-- gold accents, plus an electric-cyan pop. Built on Catppuccin Mocha, recolored
-- via color_overrides so all integrations keep working. Transparent so the
-- terminal background shows through.
-- Mirrored in ~/.config/ghostty/themes/NeonTide and the [palettes.neon_tide]
-- block of ~/.config/starship.toml — keep the three in sync.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before everything else
  lazy = false, -- override defaults.lazy so the colorscheme applies at startup
  config = function()
    -- Reserved "pop" electric cyan. Deliberately not part of the palette: the
    -- teals/blues are worn by everyday syntax, so they can't also carry
    -- emphasis. This is kept for the few things that should grab the eye
    -- (live search, matching paren).
    local pop = "#3bfee7"

    require("catppuccin").setup({
      flavour = "mocha", -- "latte" | "frappe" | "macchiato" | "mocha"
      transparent_background = true, -- let the terminal background show through
      -- Neon Tide palette — same color roles Catppuccin uses, retinted.
      -- Accents sit at uniform perceived lightness with moderate chroma (dialed
      -- back from the original max-chroma neon so everyday syntax stays calm),
      -- hues spaced >=42deg, every accent >=6:1 on base. The reserved `pop` cyan
      -- keeps full chroma so it stands out against the quieter accents.
      color_overrides = {
        mocha = {
          rosewater = "#e8bdb6",
          flamingo = "#e5a1af",
          pink = "#d99cc7", -- muted rose
          mauve = "#a892dc", -- softened violet (keywords)
          red = "#e37d8b", -- muted coral
          maroon = "#e08a99",
          peach = "#e8a077",
          yellow = "#e2c887", -- softer gold (types, focus)
          green = "#8fbe7e", -- sage strings/diff-add
          teal = "#5cb89f", -- muted mint-teal
          sky = "#74bccc",
          sapphire = "#6cabd0",
          blue = "#84a8de", -- softened azure (functions)
          lavender = "#a7b0de",
          text = "#d5dde7",
          subtext1 = "#adb7c2",
          subtext0 = "#95a1af",
          overlay2 = "#7e8b99",
          overlay1 = "#677583",
          overlay0 = "#4f5c6a",
          surface2 = "#323e4c",
          surface1 = "#242f3b",
          surface0 = "#1b2530",
          base = "#0e1720",
          mantle = "#0a121a",
          crust = "#060d13",
        },
      },
      styles = {
        comments = { "italic" },
      },
      -- Only the integrations for plugins actually in this config.
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        harpoon = true,
        indent_blankline = { enabled = true },
        markdown = true,
        mason = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            warnings = { "undercurl" },
          },
        },
        nvim_surround = true,
        nvimtree = true,
        semantic_tokens = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
      -- Three accent tiers: azure/violet carry structure, gold marks focus, and
      -- `pop` cyan is held back for the handful of things that should grab the eye.
      custom_highlights = function(c)
        return {
          CursorLine = { bg = c.surface0 }, -- subtle tint one step above the transparent base
          LineNr = { fg = c.overlay1 }, -- brighter than the default surface1, readable on the transparent bg
          CursorLineNr = { fg = c.yellow, style = { "bold" } }, -- gold current line
          -- Catppuccin maps Comment to overlay0, which is only 2.7:1 on this
          -- base. This hex is 4.7:1 (WCAG AA). Overridden directly rather than
          -- by lifting overlay0, which LineNr depends on.
          Comment = { fg = "#768297", style = { "italic" } },
          WinSeparator = { fg = c.surface2 },

          -- The pop tier. Search lands on the current match only, so the other
          -- matches stay quiet and the live one is unmistakable.
          IncSearch = { bg = pop, fg = c.base, style = { "bold" } },
          CurSearch = { bg = pop, fg = c.base, style = { "bold" } },
          Substitute = { bg = pop, fg = c.base, style = { "bold" } },
          Search = { bg = c.surface2, fg = c.text, style = { "bold" } },
          MatchParen = { fg = pop, bg = c.surface2, style = { "bold" } },

          -- The editor stays transparent; popups get a backing so they don't
          -- read as muddy against the blurred desktop behind Ghostty.
          NormalFloat = { bg = c.mantle },
          FloatBorder = { fg = c.blue, bg = c.mantle },

          -- Borderless Telescope: each border fg matches its own bg, so the
          -- panes read as flat layers instead of boxes.
          TelescopeNormal = { bg = c.mantle },
          TelescopeBorder = { fg = c.mantle, bg = c.mantle },
          TelescopeResultsTitle = { fg = c.mantle, bg = c.mantle },
          TelescopePromptNormal = { bg = c.surface0 },
          TelescopePromptBorder = { fg = c.surface0, bg = c.surface0 },
          TelescopePromptTitle = { fg = c.base, bg = c.blue, style = { "bold" } },
          TelescopePreviewTitle = { fg = c.base, bg = c.teal, style = { "bold" } },
          TelescopeSelection = { bg = c.surface1, style = { "bold" } },
          TelescopeMatching = { fg = c.yellow, style = { "bold" } },
          TelescopePromptPrefix = { fg = c.teal },
          TelescopeSelectionCaret = { fg = c.teal },

          IblScope = { fg = c.blue },
        }
      end,
    })
    -- Visual can't be fixed from custom_highlights: Catppuccin merges those with
    -- tbl_deep_extend("keep", ...) and only then expands `style` into attributes,
    -- so Visual's default `style = { "bold" }` survives an omitted key and its
    -- expansion beats an explicit bold = false. nvim_set_hl replaces outright.
    -- The bold is worth removing — it makes text change weight as you drag a
    -- selection over it, which shimmers.
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "catppuccin*",
      callback = function()
        local c = require("catppuccin.palettes").get_palette()
        vim.api.nvim_set_hl(0, "Visual", { bg = c.surface2 })
      end,
    })

    vim.cmd("colorscheme catppuccin")
  end,
}
