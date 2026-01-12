-- Treesitter
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    dir = vim.g.nvim_treesitter_path,
    dependencies = {
      -- Better auto-completion of HTML tags
      { 'windwp/nvim-ts-autotag', opts = {} },
      -- Text object mappings
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        keys = {
          -- Swap
          {
            ']z',
            function()
              require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
            end,
            desc = 'Swap next parameter',
          },
          {
            '[z',
            function()
              require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner'
            end,
            desc = 'Swap previous parameter',
          },
          -- Move
          {
            ']m',
            function()
              require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
            end,
            mode = { 'n', 'x', 'o' },
          },
          {
            ']M',
            function()
              require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
            end,
            mode = { 'n', 'x', 'o' },
          },
          {
            '[m',
            function()
              require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
            end,
            mode = { 'n', 'x', 'o' },
          },
          {
            '[M',
            function()
              require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
            end,
            mode = { 'n', 'x', 'o' },
          },
        },
        opts = {
          move = {
            set_jumps = true,
          },
        },
      },
      -- Display code context
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          enable = true,
          max_lines = 3,
          mode = 'cursor',
        },
        keys = {
          { '<leader>tc', '<cmd>TSContext toggle<cr>', desc = 'Toggle treesitter context' },
          {
            '[C',
            function()
              require('treesitter-context').go_to_context(vim.v.count1)
            end,
            desc = 'Parent context',
          },
        },
      },
    },
  },
}
