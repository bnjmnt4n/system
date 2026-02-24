return {
  -- Sets shiftwidth and tabstop automatically
  'tpope/vim-sleuth',

  -- Allow repeating of plugin keymaps
  'tpope/vim-repeat',

  -- `s` motion
  {
    'https://codeberg.org/andyg/leap.nvim',
    lazy = false,
    keys = {
      { 's', '<Plug>(leap-forward)', mode = { 'n', 'x', 'o' }, desc = 'Leap forward' },
      { 'S', '<Plug>(leap-backward)', mode = { 'n', 'x', 'o' }, desc = 'Leap backward' },
      -- TODO: conflicts with surround?
      { 'gs', '<Plug>(leap-from-window)', mode = { 'n' }, desc = 'Leap from window' },
      -- TODO: native leap tree-sitter?
      {
        'gF',
        function()
          require('bnjmnt4n.leap-treesitter').leap_treesitter()
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Leap with treesitter',
      },
    },
  },

  -- Enhanced `f`/`t` motions
  -- TODO: remove deprecated package
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
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- stylua: ignore
    keys = {
      { 'gJ', function() require('treesj').join() end, desc = 'Join node' },
      { 'gS', function() require('treesj').split() end, desc = 'Split node' },
    },
    opts = {
      use_default_keymaps = false,
    },
  },

  -- Better commentstring detection
  {
    'folke/ts-comments.nvim',
    event = { 'VeryLazy' },
    opts = {},
  },

  -- References
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    -- stylua: ignore
    keys = {
      { ']]', function() require('illuminate').goto_next_reference(false) end, desc = 'Next reference' },
      { '[[', function() require('illuminate').goto_prev_reference(false) end, desc = 'Previous reference' },
    },
    opts = {
      delay = 200,
      filetypes_denylist = {
        '',
        'bigfile',
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
    'nvim-mini/mini.ai',
    event = { 'VeryLazy' },
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
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
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },

          -- TODO: this isn't working properly.
          -- XML
          x = ai.gen_spec.treesitter({ a = '@attribute.outer', i = '@attribute.inner' }, {}),
          -- JSON
          k = ai.gen_spec.treesitter({ a = '@key.outer', i = '@key.inner' }, {}),
          v = ai.gen_spec.treesitter({ a = '@value.outer', i = '@value.inner' }, {}),
        },
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)

      local is_wk_enabled, wk = pcall(require, 'which-key')
      if not is_wk_enabled then
        return
      end

      local objects = {
        { ' ', desc = 'whitespace' },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { '(', desc = '() block' },
        { ')', desc = '() block with ws' },
        { '<', desc = '<> block' },
        { '>', desc = '<> block with ws' },
        { '?', desc = 'user prompt' },
        { 'U', desc = 'use/call without dot' },
        { '[', desc = '[] block' },
        { ']', desc = '[] block with ws' },
        { '_', desc = 'underscore' },
        { '`', desc = '` string' },
        { 'a', desc = 'argument' },
        { 'b', desc = ')]} block' },
        { 'c', desc = 'class' },
        { 'd', desc = 'digit(s)' },
        { 'e', desc = 'CamelCase / snake_case' },
        { 'f', desc = 'function' },
        { 'g', desc = 'entire file' },
        { 'i', desc = 'indent' },
        { 'k', desc = 'json key' },
        { 'o', desc = 'block, conditional, loop' },
        { 'q', desc = 'quote `"\'' },
        { 't', desc = 'tag' },
        { 'u', desc = 'use/call' },
        { '{', desc = '{} block' },
        { '}', desc = '{} with ws' },
      }

      local ret = { mode = { 'o', 'x' } }
      ---@type table<string, string>
      local mappings = vim.tbl_extend('force', {}, {
        around = 'a',
        inside = 'i',
        around_next = 'an',
        inside_next = 'in',
        around_last = 'al',
        inside_last = 'il',
      }, opts.mappings or {})
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub('^around_', ''):gsub('^inside_', '')
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == 'i' then
            desc = desc:gsub(' with ws', '')
          end
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end
      wk.add(ret, { notify = false })
    end,
  },

  -- Completion
  {
    'saghen/blink.cmp',
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'none',

        ['<c-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<cr>'] = { 'accept', 'fallback' },
        ['<c-c>'] = { 'cancel', 'fallback' },

        ['<tab>'] = {
          function(cmp)
            local has_words_before = function()
              local line, col = unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
            end

            if cmp.is_visible() then
              return cmp.select_next()
            elseif has_words_before() then
              return cmp.show()
            end
          end,
          'fallback',
        },
        ['<s-tab>'] = { 'select_prev', 'fallback' },

        ['<c-n>'] = { 'show', 'select_next', 'fallback' },
        ['<c-p>'] = { 'show', 'select_prev', 'fallback' },

        ['<c-.>'] = { 'snippet_forward', 'fallback' },
        ['<c-,>'] = { 'snippet_backward', 'fallback' },

        ['<c-d>'] = { 'scroll_documentation_up', 'fallback' },
        ['<c-f>'] = { 'scroll_documentation_down', 'fallback' },
      },
      appearance = {
        -- Sets fallback highlight groups to nvim-cmp's highlight groups.
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer' },
      },
      completion = {
        menu = {
          auto_show = false,
        },
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= 'cmdline' and not require('blink.cmp').snippet_active { direction = 1 }
            end,
            auto_insert = function(ctx)
              return ctx.mode == 'cmdline'
            end,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
        },
      },
    },
  },

  -- Auto pairs
  {
    'nvim-mini/mini.pairs',
    event = { 'InsertEnter' },
    opts = {},
  },

  -- Deal with surroundings tags/quotes/brackets
  {
    'kylechui/nvim-surround',
    event = { 'VeryLazy' },
    opts = {},
  },

  -- Remove whitespace
  {
    'lewis6991/spaceless.nvim',
    event = { 'InsertEnter' },
    opts = {},
  },
}
