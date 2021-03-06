-- Based on:
-- https://github.com/mjlbach/defaults.nvim/blob/f4611c06493f85450f82aded43b50a14619ae55a/init.lua
-- https://github.com/mjlbach/nix-dotfiles/blob/78c9ca9363107d4e967e5b49e19d86c75e7a3e3a/nixpkgs/configs/neovim/init.lua

-- Disable default plugins
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

-- TODO: more lazy loading
require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- Helpful keybindings
  use 'folke/which-key.nvim'

  -- TODO: fugitive vs neogit
  -- Git commands
  use 'tpope/vim-fugitive'

  -- 'gc' to comment visual regions/lines
  use 'tpope/vim-commentary'

  -- Async building & commands
  use { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }

  -- `[` and `]` keybindings
  use 'tpope/vim-unimpaired'

  -- Deal with surroundings tags/quotes/brackets
  use 'tpope/vim-surround'

  -- Common UNIX functions
  use 'tpope/vim-eunuch'

  -- Allow repeating of plugin keymaps
  use 'tpope/vim-repeat'

  -- Common Lua utilities shared by various plugins
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  -- Add git related info in the signs columns and popups
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    -- after = { 'plenary.nvim' },
    config = [[require 'bnjmnt4n.plugins.gitsigns']],
    -- event = 'BufEnter',
  }

  -- Split diff tool
  use {
    'sindrets/diffview.nvim',
    config = [[require 'bnjmnt4n.plugins.diffview']],
  }

  -- Magit in Neovim!
  use {
    'TimUntersberger/neogit',
    requires = { 'nvim-lua/plenary.nvim' },
    after = { 'plenary.nvim', 'diffview.nvim' },
    config = [[require 'bnjmnt4n.plugins.neogit']],
    cmd = { 'Neogit' },
  }

  -- Fuzzy finder
  -- TODO: lazyload?
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    -- after = { 'popup.nvim', 'plenary.nvim' },
    config = [[require 'bnjmnt4n.plugins.telescope']],
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Vim ports of Modus Themes
  use 'ishan9299/modus-theme-vim'

  -- Fancier statusline
  use 'itchyny/lightline.vim'

  -- Add indentation guides
  use 'lukas-reineke/indent-blankline.nvim'

  -- Directory viewer
  use 'justinmk/vim-dirvish'

  -- direnv support
  use 'direnv/direnv.vim'

  -- Run nvim in the browser
  use {
    'glacambre/firenvim',
    run = function()
      vim.fn['firenvim#install'](0)
    end,
  }

  -- Snippets + Autocompletion + auto-pairs
  -- TODO: load on InsertEnter?
  use 'windwp/nvim-autopairs'
  use 'L3MON4D3/LuaSnip'
  use {
    'hrsh7th/nvim-compe',
    after = { 'nvim-autopairs', 'LuaSnip' },
    config = [[require 'bnjmnt4n.plugins.compe']],
    event = 'InsertEnter *',
  }

  -- LSP
  use 'neovim/nvim-lspconfig'
  -- Nvim-based language server
  use 'jose-elias-alvarez/null-ls.nvim'
  -- Better `tsserver` integration
  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
  -- Better Rust tools
  use 'simrat39/rust-tools.nvim'
  -- Lightbulb for code actions
  use {
    'kosayoda/nvim-lightbulb',
    after = { 'gitsigns.nvim' },
    config = [[require 'bnjmnt4n.plugins.lightbulb']],
    event = 'BufEnter',
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      -- Better comment type detection
      'JoosepAlviste/nvim-ts-context-commentstring',
      -- Better auto-completion of HTML tags
      'windwp/nvim-ts-autotag',
      -- Text object mappings
      'nvim-treesitter/nvim-treesitter-textobjects',
      -- Playground
      -- TODO: make optional
      'nvim-treesitter/playground',
    },
    run = ':TSUpdate',
  }

  -- `gS` and `gJ` to switch between single/multi-line forms of code
  use 'AndrewRadev/splitjoin.vim'

  -- Language pack
  use 'sheerun/vim-polyglot'
end)

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
vim.o.completeopt = 'menuone,noselect'

-- Change split window location
vim.o.splitbelow = true
vim.o.splitright = true

-- Shorter timeout length between mapping keystrokes
vim.o.timeoutlen = 500

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme modus-operandi]]

-- Set statusbar
vim.g.lightline = {
  active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
  component_function = { gitbranch = 'fugitive#head' },
}

-- GUI font for neovide/firenvim
vim.o.guifont = 'Iosevka:h20'

-- firenvim
vim.g.firenvim_config = {
  localSettings = {
    ['.*'] = {
      takeover = 'never',
    },
  },
}

-- Indent guide
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'
-- Fixes bug where empty lines hold on to their highlighting
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
vim.wo.colorcolumn = '99999'

-- Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Add move line shortcuts
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true })

-- Disable line numbers in terminal mode
vim.cmd [[
  augroup Terminal
    autocmd!
    autocmd TermOpen * set nonu nornu
  augroup end
]]

-- Remap escape to leave terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', [[<c-\><c-n>]], { noremap = true })

-- Persist selection after indentation in visual/select modes
vim.api.nvim_set_keymap('x', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('x', '>', '>gv', { noremap = true })

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- Remap number increment to alt
vim.api.nvim_set_keymap('n', '<A-a>', '<C-a>', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-a>', '<C-a>', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-x>', '<C-x>', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-x>', '<C-x>', { noremap = true })

-- `n` always goes forward
vim.api.nvim_set_keymap('n', 'n', "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('x', 'n', "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('o', 'n', "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('n', 'N', "'nN'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('x', 'N', "'nN'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('o', 'N', "'nN'[v:searchforward]", { noremap = true, expr = true })

-- Clear white space on empty lines and end of line
vim.api.nvim_set_keymap(
  'n',
  '<F6>',
  [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>]],
  { noremap = true, silent = true }
)

-- Enter paste mode
vim.o.pastetoggle = '<F3>'

-- Use LSP for formatting
FormatRange = function()
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  vim.lsp.buf.range_formatting({}, start_pos, end_pos)
end

vim.cmd [[command! -range FormatRange execute 'lua FormatRange()']]
vim.cmd [[command! Format execute 'lua vim.lsp.buf.formatting()']]

-- Automatically `lcd` into current buffer's directory.
vim.cmd [[
  augroup BufferCD
    autocmd!
    autocmd BufEnter * silent! Glcd
  augroup end
]]

-- Quickfix list: `q` to quit
vim.cmd [[
  augroup QuickfixList
    autocmd!
    autocmd FileType qf nnoremap <buffer> q <cmd>cclose<CR>
  augroup end
]]

require 'bnjmnt4n.keybinds'
require 'bnjmnt4n.lsp'
require 'bnjmnt4n.treesitter'
