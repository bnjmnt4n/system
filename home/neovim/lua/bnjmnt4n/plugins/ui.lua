return {
  -- Vim ports of Modus Themes
  {
    'ishan9299/modus-theme-vim',
    config = function()
      vim.cmd [[colorscheme modus-operandi]]
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        theme = 'onelight',
        disabled_filetypes = { statusline = { 'lazy' } },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'b:gitsigns_head', icon = '' } },
        lualine_c = {
          'filename',
          {
            'diff',
            function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          'diagnostics',
        },
        lualine_x = {
          'encoding',
          {
            'fileformat',
            icons_enabled = true,
            symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' },
          },
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },

  -- Add indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
    config = function(_, opts)
      require('indent_blankline').setup(opts)
      vim.g.indent_blankline_char_highlight = 'LineNr'
      -- Fixes bug where empty lines hold on to their highlighting
      -- https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
      vim.wo.colorcolumn = '99999'
    end,
  },

  -- Menu for keybindings
  {
    'folke/which-key.nvim',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 400

      local wk = require 'which-key'
      wk.setup {}
      wk.register {
        mode = { 'n', 'v' },
        g = { name = '+goto' },
        [']'] = { name = '+next' },
        ['['] = { name = '+prev' },
        ['<leader>b'] = { name = '+buffer' },
        ['<leader>c'] = { name = '+code' },
        ['<leader>f'] = { name = '+file' },
        ['<leader>g'] = { name = '+git' },
        ['<leader>h'] = { name = '+git hunks' },
        ['<leader>l'] = { name = '+lsp' },
        ['<leader>lw'] = { name = '+workspace' },
        ['<leader>n'] = { name = '+neovim' },
        ['<leader>o'] = { name = '+open' },
        ['<leader>q'] = { name = '+quit' },
        ['<leader>s'] = { name = '+search' },
        ['<leader>t'] = { name = '+toggle' },
        ['<leader>w'] = { name = '+window' },
        ['<leader>x'] = { name = '+trouble' },
      }
    end,
  },

  -- Lightbulb for code actions
  {
    'kosayoda/nvim-lightbulb',
    event = 'BufEnter',
    cond = vim.g.slow_device ~= 1,
    opts = {
      autocmd = {
        enabled = true,
      },
    },
  },

  -- Zen mode
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = {
      { '<leader>tz', '<cmd>ZenMode<cr>', desc = 'Toggle zen mode' },
    },
    config = true,
  },

  -- Focus on specific lines of code
  {
    'folke/twilight.nvim',
    cmd = 'Twilight',
    keys = {
      { '<leader>tt', '<cmd>Twilight<cr>', desc = 'Toggle twilight mode' },
    },
    opts = {
      context = 15,
    },
  },

  -- Icons
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
}
