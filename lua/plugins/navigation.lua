-- Code navigation: a breadcrumb winbar.
return {
  -- Breadcrumb winbar: shows which file > class > function the cursor is inside
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      attach_navic = true, -- auto-attach to capable LSP servers
      show_dirname = false,
      show_basename = true,
      create_autocmd = true, -- keep the breadcrumbs updated automatically
    },
  },
}
