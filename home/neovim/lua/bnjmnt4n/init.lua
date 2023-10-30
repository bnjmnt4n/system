-- Based on:
-- https://github.com/LazyVim/LazyVim
-- https://github.com/mjlbach/defaults.nvim/blob/f4611c06493f85450f82aded43b50a14619ae55a/init.lua
-- https://github.com/mjlbach/nix-dotfiles/blob/78c9ca9363107d4e967e5b49e19d86c75e7a3e3a/nixpkgs/configs/neovim/init.lua

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
vim.opt.rtp:prepend(lazypath)

-- Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load plugins
require('lazy').setup('bnjmnt4n.plugins', {
  performance = {
    reset_packpath = false,
    rtp = {
      reset = true,
    },
  },
})

-- Expand tabs to spaces
vim.o.expandtab = true

-- Incremental live completion
vim.o.inccommand = 'nosplit'

-- Set highlight on search
vim.o.hlsearch = false

-- Incremental search
vim.o.incsearch = true

-- Use relative line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Do not save when switching buffers
vim.o.hidden = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

-- Change split window location
vim.o.splitbelow = true
vim.o.splitright = true

-- Set colorscheme
vim.o.termguicolors = true

-- GUI font for neovide
vim.o.guifont = 'Iosevka:h20'

-- Disable line numbers in terminal mode
local terminal_group = vim.api.nvim_create_augroup('Terminal', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  command = 'set nonu nornu',
  group = terminal_group,
  pattern = '*',
})

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Help: `q` to quit
local help_group = vim.api.nvim_create_augroup('Help', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = help_group,
  pattern = 'help',
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true, silent = true })
  end,
})

-- Quickfix list: `q` to quit, `x` to open Trouble
local quickfixlist_group = vim.api.nvim_create_augroup('QuickfixList', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = quickfixlist_group,
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', 'q', ':lclose <bar> cclose<cr>', { buffer = true, silent = true })
    vim.keymap.set('n', 'x', ':lclose <bar> cclose <bar> Trouble quickfix<cr>', { buffer = true, silent = true })
  end,
})

require 'bnjmnt4n.keymaps'
