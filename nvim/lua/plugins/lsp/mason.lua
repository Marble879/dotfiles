return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim"
  },
  config = function()
    -- side note: config function runs whenever mason loads.
    -- since we dont do lazy loading, mason will load whenever nvim starts.

    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        }
      }
    })

    mason_lspconfig.setup({ -- Note: This should always be after calling mason.setup()
      -- list of servers for mason to install
      ensure_installed = {
        "tsserver",
        "html",
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
      },
      -- auto-install configured servers (with lspconfig)
      -- i.e. If we configured a server that isn't isntalled/listed
      -- then mason will also install it!
      automatic_installation = true, -- no the same as ensure_installed
    })

    -- Keeps tools up to date
    mason_tool_installer.setup({
      ensure_installed = {
        "prettier",
        "stylua",
        "isort",
        "black",
        "pylint",
        "eslint_d",
        "rustfmt"
      },
    })
  end,
}
