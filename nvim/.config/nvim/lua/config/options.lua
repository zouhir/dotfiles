local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation (2 spaces, standard for TS/JS/HTML)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "100"

-- Split behavior
opt.splitbelow = true
opt.splitright = true

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Clipboard: use system clipboard. Over SSH, route through OSC 52 so yanks
-- land in the LOCAL clipboard (Ghostty/tmux decode the escape sequence).
opt.clipboard = "unnamedplus"
if os.getenv("SSH_CONNECTION") ~= nil or os.getenv("SSH_TTY") ~= nil then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Ghostty / true color support
opt.pumblend = 10
opt.winblend = 10

-- Update time (faster CursorHold for LSP diagnostics)
opt.updatetime = 200

-- Show substitutions live
opt.inccommand = "nosplit"
