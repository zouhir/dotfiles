return {
  { "folke/tokyonight.nvim", opts = { style = "night" } },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css", "fish" } },
  },

  -- HTML and CSS have no LazyVim extra.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        html = {},
        emmet_ls = {
          filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
      },
    },
  },
}
