return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths 
    "L3MON4D3/LuaSnip", -- snippet engine  
    "saadparwaiz1/cmp_luasnip", -- for autocompletion 
    "rafamadriz/friendly-snippets", --useful snippets
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    --loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      -- configures how the completion menu works
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll up in preview menu
        ["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll down in preview menu
        ["<C-e>"] = cmp.mapping.abort(), -- Close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false}) -- confirm selection
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        -- order of the following determines priority in the list
        { name = "nvim_lsp"}, -- this is so we can get LSP recommendations when we type
        { name = "luasnip" }, --snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      })
    })
  end,
}
