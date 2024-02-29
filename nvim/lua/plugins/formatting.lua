return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- Dont need formatting as soon as neovim starts. we only need this when we are working in a buffer
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				-- yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				rust = { "rustfmt" },
			},
			format_on_save = {
				lsp_fallback = true, -- if a formatter is not available for current filetype, it will try to fallback to lsp formatting
				async = false, -- formatting wont be asynchronous
				timeout_ms = 1000,
			},
		})

		-- set a custom keymap to invoke the formatter
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
