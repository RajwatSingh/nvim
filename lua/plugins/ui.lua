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
        disabled_filetypes = { statusline = { "ministarter", "starter", "NvimTree" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
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

  -- Indent guides. Current-scope highlighting is handled by mini.indentscope
  -- instead (below) — its animated line, this just draws the static guides.
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
    },
  },

  -- Animated line marking the current indent scope as you move around.
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
        draw = {
          delay = 60,
          animation = require("mini.indentscope").gen_animation.quadratic({ duration = 40, unit = "step" }),
        },
      })
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#c4a7e7" }) -- rose-pine iris

      -- No scope line in UI-ish / non-code buffers
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserIndentscopeDisable", { clear = true }),
        pattern = { "help", "qf", "man", "lspinfo", "checkhealth", "git", "ministarter", "NvimTree" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- Rounded floating prompts for vim.ui.input / vim.ui.select instead of
  -- the plain command-line versions (matches the rounded LSP/telescope floats).
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { border = "rounded" },
      select = { backend = { "telescope", "builtin" }, builtin = { border = "rounded" } },
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
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code / lsp" },
        { "<leader>f", group = "find (telescope)" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "git hunks" },
        { "<leader>s", group = "split / search" },
        { "<leader>t", group = "terminal" },
        { "<leader>x", group = "quickfix / trouble" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },
}
