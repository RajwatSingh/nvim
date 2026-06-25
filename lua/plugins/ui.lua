-- Statusline, bufferline, indent guides, which-key, autopairs.
return {
  -- Icons (shared dependency)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "rose-pine",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "dashboard", "NvimTree" } },
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
      },
    },
  },

  -- Bufferline (open files as tabs) — slanted, like your old setup
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        separator_style = "slant",
        always_show_bufferline = false,
        show_buffer_close_icons = true,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        indicator = { style = "underline" },
        offsets = {
          { filetype = "NvimTree", text = "Explorer", highlight = "Directory", text_align = "left" },
        },
      },
    },
  },

  -- Indent guides with scope highlight
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },

  -- Auto-close brackets/quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Keybinding discovery popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>c", group = "code / lsp" },
        { "<leader>f", group = "find (telescope)" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "git hunks" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },
}
