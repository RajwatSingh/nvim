-- Grape Soda: deep grape-purple base fading to lavender text, with a pop of
-- lime green. Built on Catppuccin Mocha, recolored via color_overrides so all
-- integrations keep working. Transparent so the terminal background shows through.
-- Mirrored in ~/.config/ghostty/themes/GrapeSoda and the [palettes.grape_soda]
-- block of ~/.config/ghostty/starship.toml — keep the three in sync.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before everything else
  lazy = false, -- override defaults.lazy so the colorscheme applies at startup
  config = function()
    -- Reserved "pop" lime. Deliberately not part of the palette: `green` is worn
    -- by every string in the file, so it can't also carry emphasis. This is kept
    -- for the few things that should grab the eye (live search, matching paren).
    local pop = "#c9ff66"

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
          green = "#a8dd48", -- strings/diff-add; calmer than the reserved pop lime (#c9ff66)
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
      -- Three accent tiers: grape carries structure, gold marks focus, and `pop`
      -- lime is held back for the handful of things that should grab the eye.
      custom_highlights = function(c)
        return {
          CursorLine = { bg = c.surface0 }, -- subtle tint one step above the transparent base
          LineNr = { fg = c.overlay1 }, -- brighter than the default surface1, readable on the transparent bg
          CursorLineNr = { fg = c.yellow, style = { "bold" } }, -- gold current line
          -- Catppuccin maps Comment to overlay0, which is only 2.6:1 on this base.
          -- Overridden by hex rather than by lifting overlay0, which LineNr depends on.
          Comment = { fg = "#7d6fa0", style = { "italic" } },
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
          FloatBorder = { fg = c.mauve, bg = c.mantle },

          -- Borderless Telescope: each border fg matches its own bg, so the
          -- panes read as flat layers instead of boxes.
          TelescopeNormal = { bg = c.mantle },
          TelescopeBorder = { fg = c.mantle, bg = c.mantle },
          TelescopeResultsTitle = { fg = c.mantle, bg = c.mantle },
          TelescopePromptNormal = { bg = c.surface0 },
          TelescopePromptBorder = { fg = c.surface0, bg = c.surface0 },
          TelescopePromptTitle = { fg = c.base, bg = c.mauve, style = { "bold" } },
          TelescopePreviewTitle = { fg = c.base, bg = c.green, style = { "bold" } },
          TelescopeSelection = { bg = c.surface1, style = { "bold" } },
          TelescopeMatching = { fg = c.yellow, style = { "bold" } },
          TelescopePromptPrefix = { fg = c.green },
          TelescopeSelectionCaret = { fg = c.green },

          IblScope = { fg = c.mauve },
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
