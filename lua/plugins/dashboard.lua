-- Lightweight start screen via mini.starter.
-- Shows when nvim opens with no file argument: a small header, recent files,
-- and a few quick actions. Centered and themed to match rose-pine.
return {
  {
    "echasnovski/mini.starter",
    version = false,
    lazy = false, -- must load at startup to take over the empty buffer
    priority = 900,
    config = function()
      local starter = require("mini.starter")

      starter.setup({
        header = table.concat({
          "",
          "███╗   ██╗ ██╗   ██╗ ██╗ ███╗   ███╗",
          "████╗  ██║ ██║   ██║ ██║ ████╗ ████║",
          "██╔██╗ ██║ ██║   ██║ ██║ ██╔████╔██║",
          "██║╚██╗██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
          "██║ ╚████║  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
          "╚═╝  ╚═══╝   ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
          "",
        }, "\n"),

        items = {
          -- 5 most recent files in the current directory
          starter.sections.recent_files(5, true),
          { name = "Find file",    action = "Telescope find_files", section = "Actions" },
          { name = "Grep text",    action = "Telescope live_grep",  section = "Actions" },
          { name = "Recent files", action = "Telescope oldfiles",   section = "Actions" },
          { name = "New file",     action = "enew",                 section = "Actions" },
          { name = "Config",       action = "edit $MYVIMRC",        section = "Actions" },
          { name = "Lazy",         action = "Lazy",                 section = "Actions" },
          { name = "Quit",         action = "qall",                 section = "Actions" },
        },

        content_hooks = {
          starter.gen_hook.adding_bullet("» "),
          starter.gen_hook.aligning("center", "center"),
        },

        footer = "",
      })
    end,
  },
}
