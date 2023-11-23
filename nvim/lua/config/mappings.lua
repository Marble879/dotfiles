vim.g.mapleader = " "

-- To add a new mapping:
-- refer to: https://m4xshen.dev/posts/build-your-modern-neovim-config-in-lua/
-- vim.keymap.set({ mode }, { lhs }, { rhs }, { opts })

local keymap = vim.keymap

-- map leader+y to copy to system clipboard in normal and visual mode
keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true })

-- Map tab functionality
keymap.set({"n"}, "<Tab>", ":+tabnext<CR>", { noremap = true, silent = true}) -- Move to next tab
keymap.set({"n"}, "<Shift-Tab>", ":-tabnext<CR>", { noremap = true, silent = true}) -- Move to previous tab

