-- Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Expand tabs to spaces
vim.o.expandtab = true

-- Set highlight on search
vim.o.hlsearch = false

-- Use relative line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching unless using /C or capital letters in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes:1'

-- Ignore .DS_Store files when expanding
vim.opt.wildignore:append { '.DS_Store' }

-- Set completeopt to have a better completion experience
-- menuone: popup even when there's only one match
-- noselect: Do not select, force user to select one from the menu
vim.o.completeopt = 'menuone,noselect'

-- Change split window location
vim.o.splitbelow = true
vim.o.splitright = true

-- Persist text on screen line when splitting
vim.o.splitkeep = 'screen'

-- Folding
vim.o.foldcolumn = 'auto:1'
vim.o.foldlevelstart = 99
vim.opt.fillchars = {
  foldopen = '',
  foldsep = ' ',
  foldclose = '',
}

-- Border for floating windows
vim.o.winborder = 'rounded'
