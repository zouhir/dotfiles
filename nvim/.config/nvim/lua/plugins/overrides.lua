return {
  -- Theme: TokyoNight Night (matches ghostty/starship/delta)
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
    },
  },

  -- Treesitter: add HTML, CSS, Preact/TSX language parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "json",
        "rust",
        "toml",
        "markdown",
        "markdown_inline",
        "fish",
        "lua",
        "vim",
        "vimdoc",
        "query",
      })
    end,
  },

  -- Mason: ensure LSP servers, formatters, linters are installed
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        -- TypeScript / Preact
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
        -- HTML / CSS
        "html-lsp",
        "css-lsp",
        "emmet-ls",
        -- Rust (rust-analyzer is handled by rustaceanvim)
        "codelldb",   -- Rust debugger
        -- Misc
        "json-lsp",
        "taplo",      -- TOML
        "stylua",     -- Lua formatter
      })
    end,
  },

  -- LSP: additional server configs
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Emmet for HTML/CSS snippet expansion
        emmet_ls = {
          filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
        },
        -- CSS LSP
        cssls = {},
        -- HTML LSP
        html = {
          filetypes = { "html" },
        },
        -- TypeScript / Preact
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      },
    },
  },

  -- Conform: formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        rust = { "rustfmt" },
        lua = { "stylua" },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
    },
  },

  -- Crates.nvim: completion source for Cargo.toml
  {
    "Saecki/crates.nvim",
    opts = {
      completion = {
        crates = { enabled = true },
      },
    },
  },

  -- Rustaceanvim: best-in-class Rust support (replaces rust-tools)
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    opts = {
      server = {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
            inlayHints = {
              bindingModeHints = { enable = true },
              closureCaptureHints = { enable = true },
              lifetimeElisionHints = { enable = "always" },
            },
          },
        },
      },
    },
  },

  -- Mini.pairs: auto-close brackets, quotes
  {
    "nvim-mini/mini.pairs",
    opts = {},
  },

  -- Nvim-ts-autotag: auto close/rename HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "typescript", "typescriptreact", "javascript", "javascriptreact", "xml" },
    opts = {},
  },

  -- Neo-tree: show hidden/dotfiles
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
}
