return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },                     -- Load plugin whenever open new buffer/pre eixsitng file. Second one means load plugin when open new buffer/new file that doesnt exist
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",                                   -- Completion source so have LSP reccomendation in auto completion
    { "antosha417/nvim-lsp-file-operations", config = true }, -- lets us rename files via nvim tree + update any effected import statements
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import cmd-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap

    local opts = { noremap = true, silent = true } -- table of options for keymaps
    local on_attach = function(client, bufnr)      -- allows us to define a set of keymaps that will only apply when a given language server attaches to a buffer
      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show LSP references"
    end

    -- Used to enable autocompletion (assign to every lsp  server config)
    -- Need to assign this to all Language server configs
    local capabilities = cmp_nvim_lsp.default_capabilities()


    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do                                  -- go through signs table
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" }) -- sets the icon for the different types
    end

    -- Change diagnostic defaults
    vim.diagnostic.config({     -- The following are the same as the defaults
      virtual_text = true,      -- Show line diagnostics
      signs = true,             -- Use signs in diagnostics
      underline = true,         -- Underline line with diagnostic issue
      update_in_insert = false, -- Update live, false by default so updates only after save.
      severity_sort = false,
    })

    -- Show line diagnostics in hover window when cursor is on line with diagnostic
    vim.o.updatetime = 500
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
      callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
      end
    })



    -- Web dev
    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["eslint"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["tsserver"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)                        -- allows us to define a set of keymaps that will only apply when a given language server attaches to a buffer
        opts.buffer = bufnr
        client.resolved_capabilities.document_formatting = false -- disable formatting from tsserver

        -- set keybinds
        opts.desc = "Show LSP references"


        vim.lsp.buf.format({
          filter = client.name ~= "tsserver"
        })
      end
      ,
    })

    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["tailwindcss"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })


    -- Python
    lspconfig["pylsp"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Rust

    local util = require("lspconfig/util")
    lspconfig["rust_analyzer"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "rust" },
      root_dir = util.root_pattern("Cargo.toml"),
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
          },
        },
      },
    })

    -- Lua
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = { -- custom settings for lua
        Lua = {
          -- m,ake the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            libary = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- Java
    lspconfig["jdtls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,

    })
  end,
}
