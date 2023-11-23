return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      python = { "pylint" },
    }

    -- setup auto command that executes on different nvim events and triggers linting.
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })


    -- neovim events to trigger linting, :h events shows list of all nvim events
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function() -- lint plugin will try to execute lint for current buffer when we enter buffer, write to buffer, exit insert mode (defined events above)
        lint.try_lint()
      end,
    })

    -- add a keymap to trigger linting manually
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linitng for current file" })
  end,

}
