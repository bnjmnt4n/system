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
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > 5000
        end,
      },
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
          border = 'rounded',
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

  -- TODO: configure this
  -- Syntax-aware text objects and motions
  {
    'ziontee113/syntax-tree-surfer',
    cmd = {
      'STSSwapPrevVisual',
      'STSSwapNextVisual',
      'STSSelectPrevSiblingNode',
      'STSSelectNextSiblingNode',
      'STSSelectParentNode',
      'STSSelectChildNode',
      'STSSwapOrHold',
    },
    keys = function()
      local function dot_repeatable(op)
        require 'syntax-tree-surfer'
        return function()
          vim.opt.opfunc = op
          return 'g@l'
        end
      end

      -- stylua: ignore
      return {
        { '<M-Up>',    dot_repeatable 'v:lua.STSSwapUpNormal_Dot',              desc = 'Swap parent node with previous parent',     expr = true },
        { '<M-Down>',  dot_repeatable 'v:lua.STSSwapDownNormal_Dot',            desc = 'Swap parent node with sibling parent node', expr = true },
        { '<M-Left>',  dot_repeatable 'v:lua.STSSwapCurrentNodePrevNormal_Dot', desc = 'Swap with previous node',                   expr = true },
        { '<M-Right>', dot_repeatable 'v:lua.STSSwapCurrentNodeNextNormal_Dot', desc = 'Swap with next node',                       expr = true },
        {
          'gO',
          function()
            require('syntax-tree-surfer').go_to_top_node_and_execute_commands(false, {
              'normal! O',
              'normal! O',
              'startinsert',
            })
          end,
          desc = 'Insert above top-level node',
        },
        {
          'go',
          function()
            require('syntax-tree-surfer').go_to_top_node_and_execute_commands(true, {
              'normal! o',
              'normal! o',
              'startinsert',
            })
          end,
          desc = 'Insert below top-level node',
        },
        -- { 'gh',        '<cmd>STSSwapOrHold<cr>',            desc = 'Hold or swap with held node' },

        -- TODO: figure out issues.
        { '<M-Up>',    '<cmd>STSSwapPrevVisual<cr>',        mode = 'x', desc = 'Swap with previous node', },
        { '<M-Down>',  '<cmd>STSSwapNextVisual<cr>',        mode = 'x', desc = 'Swap with next node' },
        { '<M-Left>',  '<cmd>STSSwapPrevVisual<cr>',        mode = 'x', desc = 'Swap with previous node' },
        { '<M-Right>', '<cmd>STSSwapNextVisual<cr>',        mode = 'x', desc = 'Swap with next node' },
        { '<C-Up>',    '<cmd>STSSelectPrevSiblingNode<cr>', mode = 'x', desc = 'Select previous sibling' },
        { '<C-Down>',  '<cmd>STSSelectNextSiblingNode<cr>', mode = 'x', desc = 'Select next sibling' },
        { '<C-Left>',  '<cmd>STSSelectPrevSiblingNode<cr>', mode = 'x', desc = 'Select previous sibling' },
        { '<C-Right>', '<cmd>STSSelectNextSiblingNode<cr>', mode = 'x', desc = 'Select next sibling' },
        { '<S-Cr>',    '<cmd>STSSelectChildNode<cr>',       mode = 'x', desc = 'Select child node' },
        { 'gh',        '<cmd>STSSwapOrHold<cr>',            mode = 'x', desc = 'Hold or swap with held node' },
      }
    end,
    config = true,
  },
}
