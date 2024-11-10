return {
  -- Modus theme
  {
    'miikanissi/modus-themes.nvim',
    priority = 1000,
    opts = {
      on_highlights = function(highlights, colors)
        -- Signs
        highlights.SignColumn = { fg = colors.fg_dim, bg = colors.bg_dim }
        highlights.FoldColumn = { fg = colors.fg_dim, bg = colors.bg_dim }
        highlights.LightBulbNumber = { fg = colors.gold, bg = colors.bg_dim }
        highlights.GitSignsAdd = { fg = colors.fg_added, bg = colors.bg_dim }
        highlights.GitSignsChange = { fg = colors.fg_changed, bg = colors.bg_dim }
        highlights.GitSignsDelete = { fg = colors.fg_removed, bg = colors.bg_dim }
        highlights.GitSignsAddNr = { fg = colors.fg_added, bg = colors.bg_dim }
        highlights.GitSignsChangeNr = { fg = colors.fg_changed, bg = colors.bg_dim }
        highlights.GitSignsDeleteNr = { fg = colors.fg_removed, bg = colors.bg_dim }
        highlights.DiagnosticSignError = { fg = colors.error, bg = colors.bg_dim }
        highlights.DiagnosticSignWarn = { fg = colors.warning, bg = colors.bg_dim }
        highlights.DiagnosticSignInfo = { fg = colors.info, bg = colors.bg_dim }
        highlights.DiagnosticSignHint = { fg = colors.hint, bg = colors.bg_dim }
        highlights.TroubleIndent = { fg = colors.fg_active, bg = colors.bg_active }

        -- Statusline colors
        -- TODO: tweak?
        highlights.StatuslineDiffAdd = { fg = colors.fg_added, bg = colors.bg_status_line }
        highlights.StatuslineDiffChange = { fg = colors.fg_changed, bg = colors.bg_status_line }
        highlights.StatuslineDiffDelete = { fg = colors.fg_removed, bg = colors.bg_status_line }

        -- Leap
        highlights.LeapLabel = { fg = colors.magenta_cooler, bold = true }

        -- Conflict markers
        highlights.GitConflictCurrentLabel = { bg = colors.bg_green_intense }
        highlights.GitConflictCurrent = { bg = colors.bg_green_subtle }
        highlights.GitConflictIncomingLabel = { bg = colors.bg_blue_intense }
        highlights.GitConflictIncoming = { bg = colors.bg_blue_subtle }
      end,
    },
    config = function(_, opts)
      require('modus-themes').setup(opts)
      vim.cmd.colorscheme 'modus'
    end,
  },

  -- Terminal background color sync
  'typicode/bg.nvim',

  -- Dark mode detection
  {
    'cormacrelf/dark-notify',
    config = function()
      require('dark_notify').run()
    end,
    enabled = vim.g.is_mac,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        disabled_filetypes = { statusline = { 'lazy' } },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'b:gitsigns_head', icon = '' } },
        lualine_c = {
          'filename',
          {
            'diff',
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
            diff_color = {
              added = 'StatuslineDiffAdd',
              modified = 'StatuslineDiffChange',
              removed = 'StatuslineDiffDelete',
            },
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
    config = function(_, opts)
      opts.options.theme = require 'lualine.themes.modus'
      require('lualine').setup(opts)
    end,
  },

  -- Statuscolumn
  {
    'luukvbaal/statuscol.nvim',
    event = 'VeryLazy',
    opts = function()
      local builtin = require 'statuscol.builtin'
      return {
        relculright = true,
        segments = {
          {
            sign = {
              namespace = { 'diagnostic/signs' },
              maxwidth = 1,
              colwidth = 1,
              wrap = true,
            },
            click = 'v:lua.ScSa',
          },
          {
            text = { builtin.foldfunc },
            click = 'v:lua.ScFa',
            sign = {
              wrap = false,
            },
          },
          {
            sign = {
              name = { '.*' },
              maxwidth = 1,
              colwidth = 1,
            },
            click = 'v:lua.ScSa',
          },
          {
            text = { builtin.lnumfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScLa',
          },
          {
            sign = {
              namespace = { 'gitsign' },
              maxwidth = 1,
              colwidth = 1,
              wrap = true,
            },
            click = 'v:lua.ScSa',
          },
        },
        ft_ignore = {
          'help',
          'qf',
          'vim',
          'fugitive',
          'Trouble',
          'lazy',
          'toggleterm',
          'aerial',
          'NeogitStatus',
          'NeogitCommitView',
        },
        clickhandlers = {
          FoldOther = false,
        },
      }
    end,
  },

  -- Add indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    main = 'ibl',
    opts = {
      indent = { char = '┊' },
      scope = {
        show_start = false,
        char = '│',
      },
    },
  },

  -- Prettier quickfix list
  {
    'yorickpeterse/nvim-pqf',
    ft = 'qf',
    opts = {
      show_multiple_lines = true,
      max_filename_length = 30,
    },
  },

  -- Menu for keybindings
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 400
    end,
    config = function()
      local wk = require 'which-key'
      wk.setup {}
      wk.add {
        {
          mode = { 'n', 'v' },
          { 'g', group = 'goto' },
          { '[', group = 'prev' },
          { ']', group = 'next' },
          { '<leader><tab>', group = 'tab' },
          { '<leader>b', group = 'buffer' },
          { '<leader>c', group = 'code' },
          { '<leader>d', group = 'definition' },
          { '<leader>f', group = 'file' },
          { '<leader>g', group = 'git' },
          { '<leader>h', group = 'hunk' },
          { '<leader>l', group = 'lsp' },
          { '<leader>lw', group = 'workspace' },
          { '<leader>n', group = 'neovim' },
          { '<leader>o', group = 'open' },
          { '<leader>q', group = 'quit' },
          { '<leader>s', group = 'search' },
          { '<leader>t', group = 'toggle' },
          { '<leader>w', group = 'window' },
          { '<leader>x', group = 'trouble' },
        },
      }
    end,
  },

  -- Icons
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
}
