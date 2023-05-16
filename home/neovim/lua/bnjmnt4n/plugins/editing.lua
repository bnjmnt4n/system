return {
  -- Language pack
  'sheerun/vim-polyglot',

  -- Allow repeating of plugin keymaps
  {
    'tpope/vim-repeat',
    event = 'VeryLazy',
  },

  -- `[` and `]` keybindings
  'tpope/vim-unimpaired',

  -- `s` motion
  {
    'ggandor/leap.nvim',
    keys = {
      { 's', '<Plug>(leap-forward-to)', mode = 'n', desc = 'Leap forward to' },
      { 'S', '<Plug>(leap-backward-to)', mode = 'n', desc = 'Leap backword to' },
      { 'z', '<Plug>(leap-forward-to)', mode = { 'x', 'o' }, desc = 'Leap forward to' },
      { 'Z', '<Plug>(leap-backward-to)', mode = { 'x', 'o' }, desc = 'Leap backword to' },
      { 'x', '<Plug>(leap-forward-till)', mode = 'x', desc = 'Leap forward till' },
      { 'x', '<Plug>(leap-backward-till)', mode = 'x', desc = 'Leap backward till' },
      { 'gs', '<Plug>(leap-from-window)', mode = { 'n', 'x', 'o' }, desc = 'Leap from window' },
    },
    config = function()
      vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = '#505050' })
      require('leap').opts.highlight_unlabeled_phase_one_targets = true
    end,
  },

  -- Enhanced `f`/`t` motions
  {
    'ggandor/flit.nvim',
    keys = function()
      local ret = {}
      for _, key in ipairs { 'f', 'F', 't', 'T' } do
        ret[#ret + 1] = { key, mode = { 'n', 'v' }, desc = key }
      end
      return ret
    end,
    opts = {
      labeled_modes = 'nv',
    },
  },

  -- Improved `%` matching
  {
    'andymass/vim-matchup',
    event = { 'BufReadPost', 'BufNewFile' },
  },

  -- `gS` and `gJ` to switch between single/multi-line forms of code
  {
    'AndrewRadev/splitjoin.vim',
    event = 'VeryLazy',
  },

  -- Better comment type detection
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
  },
  -- 'gc' to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    opts = function()
      return {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },

  -- References
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    -- stylua: ignore
    keys = {
      { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next reference", },
      { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Previous reference" },
    },
    opts = {
      delay = 200,
      filetypes_denylist = {
        '',
        'dirvish',
        'fugitive',
        'help',
        'TelescopePrompt',
        'NeogitStatus',
      },
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          -- Delete `]]` and `[[` keymaps set by ftplugins.
          local buffer = vim.api.nvim_get_current_buf()
          pcall(vim.keymap.del, 'n', ']]', { buffer = buffer })
          pcall(vim.keymap.del, 'n', '[[', { buffer = buffer })
        end,
      })
    end,
  },

  -- Improved text-objects
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = function()
      local ai = require 'mini.ai'
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
        },
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)
      -- register all text objects with which-key
      local i = {
        [' '] = 'Whitespace',
        ['"'] = 'Balanced "',
        ["'"] = "Balanced '",
        ['`'] = 'Balanced `',
        ['('] = 'Balanced (',
        [')'] = 'Balanced ) including white-space',
        ['>'] = 'Balanced > including white-space',
        ['<lt>'] = 'Balanced <',
        [']'] = 'Balanced ] including white-space',
        ['['] = 'Balanced [',
        ['}'] = 'Balanced } including white-space',
        ['{'] = 'Balanced {',
        ['?'] = 'User Prompt',
        _ = 'Underscore',
        a = 'Argument',
        b = 'Balanced ), ], }',
        c = 'Class',
        f = 'Function',
        o = 'Block, conditional, loop',
        q = 'Quote `, ", \'',
        t = 'Tag',
      }
      local a = vim.deepcopy(i)
      for k, v in pairs(a) do
        a[k] = v:gsub(' including.*', '')
      end

      local ic = vim.deepcopy(i)
      local ac = vim.deepcopy(a)
      for key, name in pairs { n = 'Next', l = 'Last' } do
        i[key] = vim.tbl_extend('force', { name = 'Inside ' .. name .. ' textobject' }, ic)
        a[key] = vim.tbl_extend('force', { name = 'Around ' .. name .. ' textobject' }, ac)
      end
      require('which-key').register {
        mode = { 'o', 'x' },
        i = i,
        a = a,
      }
    end,
  },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    dependencies = {
      {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
    opts = function()
      local types = require 'luasnip.util.types'

      return {
        history = true,
        update_events = 'TextChanged,TextChangedI',
        delete_check_events = 'InsertLeave',
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { 'choiceNode', 'Comment' } },
            },
          },
        },
        ext_base_prio = 300,
        ext_prio_increase = 1,
        enable_autosnippets = vim.g.slow_device ~= 1,
      }
    end,
  },

  -- nvim-cmp
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },
    opts = function()
      local cmp = require 'cmp'

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
      end

      return {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        completion = {
          autocomplete = vim.g.slow_device ~= 1 and { require('cmp.types').cmp.TriggerEvent.TextChanged },
          keyword_length = 2,
        },
        mapping = cmp.mapping.preset.insert {
          ['<c-d>'] = cmp.mapping.scroll_docs(-4),
          ['<c-f>'] = cmp.mapping.scroll_docs(4),
          ['<c-space>'] = cmp.mapping.complete(),
          ['<cr>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require('luasnip').expand_or_locally_jumpable() then
              require('luasnip').expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<s-tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require('luasnip').jumpable(-1) then
              require('luasnip').jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'luasnip' },
        },
      }
    end,
  },

  -- Auto pairs
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    config = function()
      require('mini.pairs').setup()
    end,
  },

  -- Deal with surroundings tags/quotes/brackets
  {
    'echasnovski/mini.surround',
    keys = function(_, keys)
      local plugin = require('lazy.core.config').spec.plugins['mini.surround']
      local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
      local mappings = {
        { opts.mappings.add, desc = 'Add surrounding' },
        { opts.mappings.delete, desc = 'Delete surrounding' },
        { opts.mappings.find, desc = 'Find right surrounding' },
        { opts.mappings.find_left, desc = 'Find left surrounding' },
        { opts.mappings.highlight, desc = 'Highlight surrounding' },
        { opts.mappings.replace, desc = 'Replace surrounding' },
        { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
        {
          'S',
          ":<c-u>lua MiniSurround.add('visual')<cr>",
          mode = 'x',
          desc = 'Add surrounding',
        },
        { 'yss', 'ys_', { remap = true } },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = 'ys', -- Add surrounding
        delete = 'ds', -- Delete surrounding
        find = 'gzf', -- Find surrounding (to the right)
        find_left = 'gzF', -- Find surrounding (to the left)
        highlight = 'gzh', -- Highlight surrounding
        replace = 'cs', -- Replace surrounding
        update_n_lines = 'gzn', -- Update `n_lines`
        -- Do not use extended mappings
        suffix_last = '',
        suffix_next = '',
      },
      search_method = 'cover_or_next',
    },
    config = function(_, opts)
      require('mini.surround').setup(opts)
      vim.keymap.del('x', opts.mappings.add)
      -- Make special mapping for "add surrounding for line"
    end,
  },

  -- Remove whitespace
  {
    'lewis6991/spaceless.nvim',
    event = 'VeryLazy',
    config = true,
  },
}
