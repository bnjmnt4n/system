return {
  -- Modus theme
  {
    'miikanissi/modus-themes.nvim',
    priority = 1000,
    opts = {
      styles = {
        comments = { italic = false },
      },
      on_highlights = function(highlights, colors)
        -- Signs
        highlights.LineNr = { fg = colors.fg_main, bg = colors.bg_dim }
        highlights.LineNrAbove = { fg = colors.fg_dim, bg = colors.bg_dim }
        highlights.LineNrBelow = { fg = colors.fg_dim, bg = colors.bg_dim }
        highlights.SignColumn = { fg = colors.fg_dim, bg = colors.bg_dim }
        highlights.FoldColumn = { fg = colors.fg_dim, bg = colors.bg_dim }
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

        highlights.FloatBorder = highlights.NormalFloat
        highlights.FloatTitle = highlights.NormalFloat

        -- Statusline colors
        -- -- TODO: tweak?
        -- highlights.StatuslineDiffAdd = { fg = colors.fg_added, bg = colors.bg_status_line }
        -- highlights.StatuslineDiffChange = { fg = colors.fg_changed, bg = colors.bg_status_line }
        -- highlights.StatuslineDiffDelete = { fg = colors.fg_removed, bg = colors.bg_status_line }
        highlights.StatuslineText = { fg = colors.fg_status_line_active, bg = colors.bg_status_line_active }

        -- Leap
        highlights.LeapLabel = { fg = colors.magenta_cooler, bold = true }

        -- Conflict markers
        highlights.GitConflictCurrentLabel = { bg = colors.bg_green_intense }
        highlights.GitConflictCurrent = { bg = colors.bg_green_subtle }
        highlights.GitConflictIncomingLabel = { bg = colors.bg_blue_intense }
        highlights.GitConflictIncoming = { bg = colors.bg_blue_subtle }

        -- quicker line number
        highlights.QuickFixLineNr = { fg = colors.fg_main }

        -- Custom minimal styles

        -- Use default foreground color for all keywords
        local default_highlight = { fg = colors.fg_main }
        highlights.Statement = default_highlight -- (preferred) any statement.
        highlights.Conditional = default_highlight -- `if`, `then`, `else`, `endif`, `switch`, etc.
        highlights.Repeat = default_highlight -- `for`, `do`, `while`, etc.
        highlights.Label = default_highlight -- `case`, `default`, etc.
        highlights.Keyword = default_highlight -- Any other keyword.
        highlights.Exception = default_highlight -- `try`, `catch`, `throw`, etc.
        highlights.StorageClass = default_highlight -- `static`, `register`, `volatile`, etc.
        highlights.Structure = default_highlight -- `struct`, `union`, `enum`, etc.
        highlights.Include = default_highlight
        highlights.Operator = default_highlight -- `sizeof`, `+`, `*`, etc.
        highlights.SpecialChar = default_highlight
        highlights['@keyword.function'] = { link = '@keyword' } -- Keywords that define a function (e.g. `func` in Go, `def` in Python).
        highlights['@keyword.import'] = { link = '@keyword' } -- Keywords for including imports (e.g. `import`, `from` in Python).
        highlights['@keyword.conditional.ternary'] = { link = 'Operator' } -- Ternary operators (e.g. `?`, `:`).

        -- Remove default bold for booleans
        highlights.Boolean = { fg = highlights.Boolean.fg } -- Boolean constant (e.g. `TRUE`, `false`).

        -- Use dim foreground color for punctuation
        local punctuation_highlight = { fg = colors.fg_dim }
        highlights.Delimiter = punctuation_highlight -- Character that needs attention (e.g. `.`).
        highlights['@punctuation.bracket'] = punctuation_highlight -- Brackets and parens (e.g. `()`, `{}`, `[]`).
        highlights['@punctuation.special'] = punctuation_highlight
        highlights['@constructor.lua'] = punctuation_highlight

        highlights['@tag.attribute.tsx'] = default_highlight
        highlights['@tag.delimiter.tsx'] = punctuation_highlight
        highlights['@tag.builtin.tsx'] = { fg = colors.cyan_cooler }

        -- Use brighter color for comments
        highlights['@comment'] = { link = '@string.documentation' } -- Line and block comments.
        highlights['@keyword.jsdoc'] = { link = '@comment' }
        highlights['@keyword.luadoc'] = { link = '@comment' }

        -- Use default foreground color for identifiers, except for declarations
        highlights.Identifier = default_highlight
        highlights.Function = default_highlight
        highlights.Type = default_highlight
        highlights['@constant.builtin'] = default_highlight
        highlights['@lsp.type.parameter'] = default_highlight
        highlights['@lsp.type.type'] = default_highlight
        highlights['@lsp.type.interface'] = default_highlight
        highlights['@lsp.type.typeParameter'] = default_highlight
        highlights['@lsp.typemod.type.defaultLibrary'] = default_highlight
        highlights['@lsp.typemod.typeAlias.defaultLibrary'] = default_highlight

        -- Use custom colors for declarations
        local variable_declaration_highlight = { fg = colors.cyan, bg = colors.bg_cyan_nuanced }
        local function_declaration_highlight = { fg = colors.magenta, bg = colors.bg_magenta_nuanced }
        local type_declaration_highlight = { fg = colors.cyan_cooler, bg = colors.bg_cyan_nuanced }
        highlights['@variable.parameter'] = variable_declaration_highlight
        highlights['@lsp.typemod.variable.declaration'] = variable_declaration_highlight
        highlights['@lsp.typemod.parameter.declaration'] = variable_declaration_highlight
        highlights['@lsp.typemod.class.declaration'] = variable_declaration_highlight
        highlights['@lsp.typemod.function.declaration'] = function_declaration_highlight
        highlights['@lsp.typemod.member.declaration'] = function_declaration_highlight
        highlights.TypeDef = type_declaration_highlight
        highlights['@lsp.typemod.type.declaration'] = type_declaration_highlight
        highlights['@lsp.typemod.interface.declaration'] = type_declaration_highlight
        highlights['@lsp.typemod.typeParameter.declaration'] = type_declaration_highlight

        highlights['@function'] = function_declaration_highlight
        highlights['@function.method'] = function_declaration_highlight
        highlights['@function.builtin'] = { link = 'Function' }
        highlights['@function.call'] = { link = 'Function' }
        highlights['@function.method.call'] = { link = 'Function' }
        highlights['@lsp.type.method'] = { link = 'Function' }
        highlights['@lsp.type.function'] = { link = 'Function' }
      end,
    },
    config = function(_, opts)
      require('modus-themes').setup(opts)
      vim.cmd.colorscheme 'modus'

      vim.api.nvim_create_autocmd('OptionSet', {
        group = vim.api.nvim_create_augroup('bnjmnt4n/background', { clear = true }),
        pattern = 'background',
        desc = 'Reset theme',
        command = 'colorscheme modus',
      })
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'miikanissi/modus-themes.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      options = {
        disabled_filetypes = { statusline = { 'lazy' } },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {},
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
            -- diff_color = {
            --   added = 'StatuslineDiffAdd',
            --   modified = 'StatuslineDiffChange',
            --   removed = 'StatuslineDiffDelete',
            -- },
          },
          { 'diagnostics' },
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
    event = { 'BufReadPre', 'BufNewFile' },
    opts = function()
      local builtin = require 'statuscol.builtin'
      return {
        relculright = true,
        segments = {
          {
            sign = {
              namespace = { 'diagnostic' },
              maxwidth = 1,
              colwidth = 1,
              wrap = true,
            },
            click = 'v:lua.ScSa',
          },
          {
            text = { builtin.foldfunc },
            click = 'v:lua.ScFa',
          },
          {
            sign = {
              name = { '.*' },
              maxwidth = 1,
              colwidth = 1,
              foldclosed = true,
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
          'man',
          'vim',
          'aerial',
          'lazy',
          'toggleterm',
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
    'stevearc/quicker.nvim',
    ft = 'qf',
    ---@module 'quicker'
    ---@type quicker.SetupOptions
    opts = {
      opts = {
        number = true,
        relativenumber = false,
      },
      constrain_cursor = true,
      trim_leading_whitespace = false,
      max_filename_width = function()
        return math.min(40, math.floor(vim.o.columns / 2))
      end,
      type_icons = {
        E = '▎',
        W = '▎',
        I = '▎',
        N = '▎',
        H = '▎',
      },
      -- stylua: ignore
      keys = {
        { '>', function() require('quicker').expand() end, desc = 'Expand quickfix context' },
        { '<', function() require('quicker').collapse() end, desc = 'Collapse quickfix context' },
      },
    },
  },

  -- Menu for keybindings
  {
    'folke/which-key.nvim',
    event = { 'VeryLazy' },
    opts = {
      preset = 'helix',
      delay = 800,
      spec = {
        {
          mode = { 'n', 'v' },
          { 'g', group = 'goto' },
          { '[', group = 'prev' },
          { ']', group = 'next' },
          { '<leader><tab>', group = 'tab' },
          { '<leader>b', group = 'buffer' },
          { '<leader>c', group = 'code' },
          { '<leader>d', group = 'diagnostics' },
          { '<leader>f', group = 'file' },
          { '<leader>g', group = 'git' },
          { '<leader>h', group = 'hunk' },
          { '<leader>l', group = 'lsp' },
          { '<leader>lw', group = 'workspace' },
          { '<leader>n', group = 'neovim' },
          { '<leader>o', group = 'open' },
          { '<leader>q', group = 'quit' },
          { '<leader>r', group = 'run' },
          { '<leader>s', group = 'search' },
          { '<leader>t', group = 'toggle' },
          { '<leader>tg', group = 'diagnostics' },
          { '<leader>w', group = 'window' },
        },
      },
    },
  },

  -- Icons
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    opts = {},
  },
}
