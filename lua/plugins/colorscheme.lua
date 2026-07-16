-- Slack Tide: calm OKLCH re-tune of Neon Tide — royal-velvet text, gold focus,
-- azure/violet structure on deep navy, plus an electric-cyan pop. Built on
-- Catppuccin Mocha, recolored via color_overrides so all integrations keep
-- working. Transparent so the terminal background shows through.
-- Mirrored in ~/.config/ghostty/themes/SlackTide and the [palettes.neon_tide]
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
      -- Slack Tide palette — same color roles Catppuccin uses, retinted.
      -- Same OKLCH pipeline as the Ghostty theme: uniform accent lightness,
      -- chroma ~0.08–0.13, every accent >=5.7:1 on the terminal background.
      -- Text is the royal velvet of the shell; keywords a deeper violet so
      -- they separate from it. The reserved `pop` cyan keeps full chroma.
      color_overrides = {
        mocha = {
          rosewater = "#ddbbb5",
          flamingo = "#deabae",
          pink = "#dba4c8", -- muted rose
          mauve = "#a584dc", -- deep violet (keywords) — darker than the velvet text
          red = "#de9491", -- calm coral
          maroon = "#e49a9f",
          peach = "#cc9e68", -- amber, matches shell warnings
          yellow = "#ebc573", -- gold (types, focus) — matches typed-command gold
          green = "#81bb8d", -- sage strings/diff-add
          teal = "#62beb0", -- muted teal
          sky = "#81c4d0",
          sapphire = "#74b5d4",
          blue = "#84aee3", -- azure (functions)
          lavender = "#afb4de",
          text = "#c8b3e3", -- royal velvet, same as Ghostty foreground
          subtext1 = "#a5acb2",
          subtext0 = "#9299a1",
          overlay2 = "#80878f",
          overlay1 = "#69737d",
          overlay0 = "#454e58",
          surface2 = "#364452",
          surface1 = "#273442",
          surface0 = "#1d2732",
          base = "#141b24",
          mantle = "#0e141c",
          crust = "#080e14",
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
          Comment = { fg = "#7d8792", style = { "italic" } },
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
