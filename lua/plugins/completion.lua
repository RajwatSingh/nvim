-- blink.cmp: fast completion. Uses a prebuilt binary (no Rust toolchain needed).
return {
  {
    "saghen/blink.cmp",
    version = "*", -- release tag -> downloads prebuilt fuzzy matcher
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "default", -- <C-y> accept, <C-space> open, <C-n>/<C-p> navigate
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      appearance = { nerd_font_variant = "normal" },
      completion = {
        documentation = { auto_show = false }, -- open docs manually; no surprise floats
        menu = { border = "rounded" },
        ghost_text = { enabled = false }, -- no gray inline preview as you type
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
