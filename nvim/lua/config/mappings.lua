vim.g.mapleader = " "

-- To add a new mapping:
-- refer to: https://m4xshen.dev/posts/build-your-modern-neovim-config-in-lua/
-- vim.keymap.set({ mode }, { lhs }, { rhs }, { opts })

-- map leader+y to copy to system clipboard in normal and visual mode
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true })

