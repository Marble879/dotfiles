return {
  "nvim-telescope/telescope.nvim",
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {'nvim-telescope/telescope-fzf-native.nvim', build='make'},
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        mappings = {
          n = {
            ["q"] = actions.close,
          },
          i = {
            ["<C-o>"] = function(prompt_bufnr) require("telescope.actions").select_default(prompt_bufnr)
            require("telescope.builtin").resume()
            end,
            ["<C-t>"] = function(prompt_bufnr) actions.file_tab(prompt_bufnr) builtin.resume()
            end,
          },
        },
      },
    })

  --set keymaps
  telescope.load_extension("fzf")

  local keymap = vim.keymap

  keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
  end
}
