-- Treesitter
return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPre',
    dir = vim.g.nvim_treesitter_path,
    dependencies = {
      -- Better auto-completion of HTML tags
      'windwp/nvim-ts-autotag',
      -- Text object mappings
      'nvim-treesitter/nvim-treesitter-textobjects',
      -- Display code context
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          enable = true,
          max_lines = 3,
          mode = 'cursor',
        },
        keys = {
          { '<leader>tc', '<cmd>TSContextToggle<cr>', desc = 'Toggle treesitter context' },
        },
      },
    },
    opts = {
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<cr>',
          node_incremental = '<cr>',
          scope_incremental = ';',
          node_decremental = '<bs>',
        },
      },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = false,
        },
        swap = {
          enable = true,
          swap_next = {
            [']z'] = '@parameter.inner',
          },
          swap_previous = {
            ['[z'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
          },
        },
        lsp_interop = {
          enable = true,
          peek_definition_code = {
            ['<leader>df'] = '@function.outer',
            ['<leader>dF'] = '@class.outer',
          },
        },
      },
      matchup = { enable = true },
      autotag = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
