-- Debugging: nvim-dap driven by delve for Go.
-- <leader>d is taken (delete-without-yank), so debug lives on <leader>D + the F-keys.
-- Needs dlv on PATH: `go install github.com/go-delve/delve/cmd/dlv@latest`
-- (or :MasonInstallTools).
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
      { "leoluz/nvim-dap-go", ft = "go", opts = {} },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: continue / start" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<leader>Db", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      {
        "<leader>DB",
        function()
          vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
            if cond and cond ~= "" then
              require("dap").set_breakpoint(cond)
            end
          end)
        end,
        desc = "Debug: conditional breakpoint",
      },
      { "<leader>Dc", function() require("dap").continue() end, desc = "Debug: continue / start" },
      { "<leader>Du", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
      { "<leader>De", function() require("dapui").eval(nil, { enter = true }) end, mode = { "n", "v" }, desc = "Debug: eval expression" },
      { "<leader>Dr", function() require("dap").run_last() end, desc = "Debug: re-run last session" },
      { "<leader>Dx", function() require("dap").terminate() end, desc = "Debug: terminate" },
      { "<leader>Dt", function() require("dap-go").debug_test() end, ft = "go", desc = "Debug: nearest Go test" },
      { "<leader>DT", function() require("dap-go").debug_last_test() end, ft = "go", desc = "Debug: last Go test" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      -- Sign text must be non-empty: a sign with no text can't be placed, and
      -- nvim-dap stores breakpoints *as* signs, so it would drop them silently.
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })

      -- Open the variables/stack UI for the duration of a session
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"] = function() dapui.close() end
    end,
  },
}
