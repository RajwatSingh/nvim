-- Animated cursor: draws a smooth "smear"/trail when the cursor jumps.
-- Works in the terminal (Ghostty) by drawing the trail itself.
return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- Snappier but still smooth. Higher stiffness = faster; lower = longer/slower.
      stiffness = 0.6, -- head catches up quickly
      trailing_stiffness = 0.45, -- tail follows promptly -> shorter, quicker trail
      trailing_exponent = 2, -- gentle taper
      distance_stop_animating = 0.5, -- finish a touch sooner
      time_interval = 17, -- ms between frames (~60fps); higher = fewer redraws / lighter

      -- Smear across bigger movements (the "jump" feel you asked for)
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      smear_insert_mode = false, -- keep typing crisp; only animate navigation

      -- Matches catppuccin's "mauve" accent so the trail fits the theme.
      -- Set to "none" to use the terminal's cursor color instead.
      cursor_color = "#cba6f7",
    },
  },
}
