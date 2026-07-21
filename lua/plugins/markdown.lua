-- Markdown rendering. Two complementary layers:
--   render-markdown.nvim -> pretty in-buffer rendering while you edit (no deps)
--   markdown-preview.nvim -> live browser preview with tables/katex/mermaid
return {
  -- In-buffer: headings as blocks, bulleted lists, real checkboxes, boxed
  -- code fences, rendered tables. Concealed while editing a line, so the raw
  -- text is always one cursor move away.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = "markdown",
    opts = {
      heading = { width = "block", left_pad = 0, right_pad = 2 },
      code = { width = "block", left_pad = 2, right_pad = 2, border = "thick" },
      checkbox = { unchecked = { icon = "󰄱 " }, checked = { icon = "󰱒 " } },
      dash = { width = 80 },
    },
    keys = {
      {
        "<leader>mr",
        function()
          require("render-markdown").toggle()
        end,
        desc = "Toggle inline markdown render",
      },
    },
  },

  -- Browser: opens a live-syncing tab, scroll-linked to the buffer.
  -- Renders GitHub-flavoured markdown properly (tables, footnotes, math,
  -- mermaid diagrams) — everything glow's terminal output has to flatten.
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
      {
        "<leader>mp",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown preview (browser)",
      },
    },
  },
}
