-- Based on:
-- https://github.com/mjlbach/defaults.nvim/blob/f4611c06493f85450f82aded43b50a14619ae55a/init.lua
-- https://github.com/mjlbach/nix-dotfiles/blob/78c9ca9363107d4e967e5b49e19d86c75e7a3e3a/nixpkgs/configs/neovim/init.lua

-- TODO: more lazy loading
require('packer').startup {
  function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'

    -- Helpful keybindings
    use {
      'folke/which-key.nvim',
      config = [[require 'bnjmnt4n.keybinds']],
    }

    -- TODO: fugitive vs neogit
    -- Git commands
    use 'tpope/vim-fugitive'

    -- 'gc' to comment visual regions/lines
    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup {
          pre_hook = function(ctx)
            local U = require 'Comment.utils'

            local location = nil
            if ctx.ctype == U.ctype.block then
              location = require('ts_context_commentstring.utils').get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
              location = require('ts_context_commentstring.utils').get_visual_start_location()
            end

            return require('ts_context_commentstring.internal').calculate_commentstring {
              key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
              location = location,
            }
          end,
        }
      end,
    }

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

    -- Vim ports of Modus Themes
    use 'ishan9299/modus-theme-vim'

    -- Fancier statusline
    use 'itchyny/lightline.vim'

    -- Add indentation guides
    use 'lukas-reineke/indent-blankline.nvim'

    -- Directory viewer
    use 'justinmk/vim-dirvish'

    -- Common Lua utility shared by various plugins
    use 'nvim-lua/plenary.nvim'

    -- Add git related info in the signs columns and popups
    use {
      'lewis6991/gitsigns.nvim',
      event = 'BufReadPre',
      wants = { 'plenary.nvim' },
      requires = { 'nvim-lua/plenary.nvim' },
      config = [[require 'bnjmnt4n.plugins.gitsigns']],
    }

    -- Split diff tool
    use {
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
      config = [[require 'bnjmnt4n.plugins.diffview']],
    }

    -- Magit in Neovim!
    use {
      'TimUntersberger/neogit',
      cmd = { 'Neogit' },
      wants = { 'plenary.nvim', 'diffview.nvim' },
      requires = { 'nvim-lua/plenary.nvim', 'diffview.nvim' },
      config = [[require 'bnjmnt4n.plugins.neogit']],
    }

    use {
      'folke/trouble.nvim',
      event = 'BufReadPre',
      cmd = { 'Trouble', 'TroubleToggle' },
      module = 'trouble',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = [[require 'bnjmnt4n.plugins.trouble']],
    }

    -- Fuzzy finder
    use {
      'nvim-telescope/telescope.nvim',
      cmd = { 'Telescope' },
      module = 'telescope',
      wants = { 'plenary.nvim', 'trouble.nvim' },
      requires = { 'nvim-lua/plenary.nvim', 'folke/trouble.nvim' },
    }
    use {
      'nvim-telescope/telescope-file-browser.nvim',
      after = { 'telescope.nvim' },
    }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      after = { 'telescope.nvim', 'telescope-file-browser.nvim' },
      config = [[require 'bnjmnt4n.plugins.telescope']],
    }

    -- TODO comments
    use {
      'folke/todo-comments.nvim',
      event = 'BufReadPost',
      cmd = { 'TodoTrouble', 'TodoTelescope' },
      wants = { 'plenary.nvim' },
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('todo-comments').setup {}
      end,
    }

    -- Snippets + Autocompletion + auto-pairs
    use {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter *',
      requires = {
        -- 'L3MON4D3/LuaSnip',
        'hrsh7th/cmp-nvim-lsp',
        -- TODO: simplify?
        {
          'hrsh7th/cmp-nvim-lua',
          event = 'InsertEnter *',
          wants = { 'nvim-cmp' },
        },
        {
          'hrsh7th/cmp-buffer',
          event = 'InsertEnter *',
          wants = { 'nvim-cmp' },
        },
        {
          'hrsh7th/cmp-path',
          event = 'InsertEnter *',
          wants = { 'nvim-cmp' },
        },
        {
          'saadparwaiz1/cmp_luasnip',
          event = 'InsertEnter *',
          wants = { 'nvim-cmp' },
        },
      },
      config = [[require 'bnjmnt4n.plugins.cmp']],
    }
    use {
      'L3MON4D3/LuaSnip',
      after = { 'nvim-cmp' },
      config = [[require 'bnjmnt4n.plugins.luasnip']],
    }
    use {
      'windwp/nvim-autopairs',
      after = { 'nvim-cmp' },
      config = [[require 'bnjmnt4n.plugins.autopairs']],
    }

    -- LSP
    use 'neovim/nvim-lspconfig'
    -- Nvim-based language server
    use {
      'jose-elias-alvarez/null-ls.nvim',
      wants = { 'plenary.nvim', 'nvim-lspconfig' },
      requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    }
    -- Better `tsserver` integration
    use 'jose-elias-alvarez/nvim-lsp-ts-utils'
    -- Better Rust tools
    use 'simrat39/rust-tools.nvim'
    -- Java LSP
    use 'mfussenegger/nvim-jdtls'
    -- Lightbulb for code actions
    use {
      'kosayoda/nvim-lightbulb',
      event = 'BufEnter',
      disable = vim.g.slow_device == 1,
      config = [[require 'bnjmnt4n.plugins.lightbulb']],
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
        {
          'nvim-treesitter/playground',
          cmd = { 'TSPlaygroundToggle' },
        },
      },
      config = [[require 'bnjmnt4n.treesitter']],
    }

    -- `gS` and `gJ` to switch between single/multi-line forms of code
    use 'AndrewRadev/splitjoin.vim'

    -- TODO
    use { 'mhinz/vim-sayonara', cmd = { 'Sayonara' } }

    -- Mass editing of the quickfix list
    use { 'Olical/vim-enmasse', cmd = { 'EnMasse' } }

    -- Convenient access to nvim terminal
    use { 'akinsho/toggleterm.nvim', cmd = { 'ToggleTerm' } }

    -- -- Org-mode
    -- -- TODO: setup
    -- use {
    --   'kristijanhusak/orgmode.nvim',
    --   config = function()
    --     -- require('orgmode').setup {
    --     --   org_agenda_files = { '~/org/agenda' },
    --     -- }
    --   end,
    -- }

    -- More convenient find commands
    use {
      'ggandor/lightspeed.nvim',
      event = 'BufReadPost',
      config = [[require 'bnjmnt4n.plugins.lightspeed']],
    }

    -- TODO
    use {
      'andymass/vim-matchup',
      event = 'CursorMoved',
    }

    -- Language pack
    use 'sheerun/vim-polyglot'
  end,

  config = {
    snapshot_path = require('packer.util').join_paths(vim.fn.stdpath 'config', 'plugin', 'packer_snapshots'),
  },
}

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

-- Shorter timeout length between mapping keystrokes
vim.o.timeoutlen = 500

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme modus-operandi]]

-- Set statusbar
vim.g.lightline = {
  active = { left = {
    { 'mode', 'paste' },
    { 'gitbranch', 'readonly', 'filename', 'modified' },
  } },
  component_function = { gitbranch = 'fugitive#head' },
}

-- GUI font for neovide
vim.o.guifont = 'Iosevka:h20'

-- Indent guide
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}
vim.g.indent_blankline_char_highlight = 'LineNr'
-- Fixes bug where empty lines hold on to their highlighting
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
vim.wo.colorcolumn = '99999'

-- Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Add move line shortcuts
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi')
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")

-- Disable line numbers in terminal mode
local terminal_group = vim.api.nvim_create_augroup('Terminal', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  command = 'set nonu nornu',
  group = terminal_group,
  pattern = '*',
})

-- Remap escape to leave terminal mode
vim.keymap.set('t', '<Esc>', [[<c-\><c-n>]])

-- Persist selection after indentation in visual/select modes
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Y yank until the end of line
vim.keymap.set('n', 'Y', 'y$')

-- Remap number increment to alt
vim.keymap.set('n', '<A-a>', '<C-a>')
vim.keymap.set('v', '<A-a>', '<C-a>')
vim.keymap.set('n', '<A-x>', '<C-x>')
vim.keymap.set('v', '<A-x>', '<C-x>')

-- `n` always goes forward
vim.keymap.set('n', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('n', 'N', "'nN'[v:searchforward]", { expr = true })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true })

-- Clear white space on empty lines and end of line
vim.keymap.set(
  'n',
  '<F6>',
  [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>]],
  { silent = true }
)

-- Enter paste mode
vim.o.pastetoggle = '<F3>'

-- Use LSP for formatting
FormatRange = function()
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  vim.lsp.buf.range_formatting({}, start_pos, end_pos)
end

-- TODO: switch to new API as well
vim.cmd [[command! -range FormatRange execute 'lua FormatRange()']]
vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})

-- Quickfix list: `q` to quit
local quickfixlist_group = vim.api.nvim_create_augroup('QuickfixList', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  command = 'nnoremap <buffer> q :lclose <bar> cclose <CR>',
  group = quickfixlist_group,
  pattern = 'qf',
})

require 'bnjmnt4n.lsp'
