-- Treesitter
return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      -- Better auto-completion of HTML tags
      'windwp/nvim-ts-autotag',
      -- Text object mappings
      'nvim-treesitter/nvim-treesitter-textobjects',
      -- Display code context
      'nvim-treesitter/nvim-treesitter-context',
    },
    opts = {
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          scope_incremental = ';',
          node_decremental = '<BS>',
        },
      },
      indent = {
        enable = true,
      },
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
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      autotag = {
        enable = true,
      },
      playground = {
        enable = true,
      },
    },
    config = function(_, opts)
      -- Treesitter
      require('nvim-treesitter.configs').setup(opts)

      -- Treesitter folding
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
      -- TODO: better fold settings
      vim.wo.foldenable = false
    end,
  },
  {
    -- Playground
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle' },
    keys = { '<leader>tp', '<cmd>TSPlaygroundToggle<cr>', desc = 'Toggle treesitter playground' },
  },
}
