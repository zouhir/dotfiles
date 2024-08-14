return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
				 -- Go
        "go",

        -- C, C++
				"c",
        "cpp",

				-- Python
        "python",

        -- Web development
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",

        -- Additional web-related frameworks
        "vue",
        "svelte",
				"astro",

        -- Markup and config
        "yaml",
        "toml",
				"xml",
        "markdown",
				"markdown_inline",

        -- Query languages
        "sql",

        -- Build tools and package managers
        "dockerfile",
        "make",

				-- Build and package management
        "cmake",
        "ninja",

				-- Shell and command-line languages
        "bash",
        "fish",
				"vim",
				"vimdoc",
				"lua",
        "awk",
        "regex",

				-- Version control
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",

      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
