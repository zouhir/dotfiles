local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Set filetype for Preact/TSX files
autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.tsx", "*.jsx" },
  callback = function()
    vim.bo.filetype = "typescriptreact"
  end,
})

-- Use 2-space indent for web files
autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact", "html", "css", "json", "yaml" },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- Use 4-space indent for Rust
autocmd("FileType", {
  pattern = { "rust" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end,
})

-- Close some filetypes with just 'q'
autocmd("FileType", {
  pattern = { "help", "qf", "man", "checkhealth" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true })
  end,
})
