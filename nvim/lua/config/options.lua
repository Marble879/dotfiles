-- enable line number and relative line number
vim.opt.number = true
vim.opt.relativenumber = false

-- width of a tab
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- use number of spaces to insert a <Tab>
vim.opt.expandtab = true

-- Disable line wrapping globally, enable for markdown
vim.opt.wrap = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
  end,
})

-- Case insensitive searching Unless /C or capital in search
vim.opt.ignorecase = true

-- System wide copy with yy
vim.opt.clipboard = "unnamed"
vim.opt.textwidth = 80
