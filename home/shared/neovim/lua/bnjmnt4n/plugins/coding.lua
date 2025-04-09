return {
  -- Sets shiftwidth and tabstop automatically
  {
    'tpope/vim-sleuth',
    event = 'BufReadPre',
  },

  -- Allow repeating of plugin keymaps
  {
    'tpope/vim-repeat',
    event = 'VeryLazy',
  },

  -- `[` and `]` keybindings
  {
    'tpope/vim-unimpaired',
    event = 'VeryLazy',
  },

  -- `s` motion
  {
    'ggandor/leap.nvim',
    keys = {
      { 's', '<Plug>(leap-forward)', mode = { 'n', 'x', 'o' }, desc = 'Leap forward' },
      { 'S', '<Plug>(leap-backward)', mode = { 'n' }, desc = 'Leap backward ' },
      { 'gs', '<Plug>(leap-from-window)', mode = { 'n', 'x', 'o' }, desc = 'Leap from window' },
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
    dependencies = 'nvim-treesitter/nvim-treesitter',
    -- stylua: ignore
    keys = {
      { 'gJ', function() require('treesj').join() end, desc = 'Join node' },
      { 'gS', function() require('treesj').split() end, desc = 'Split node'},
    },
    opts = {
      use_default_keymaps = false,
    },
  },

  -- 'gc' to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    dependencies = {
      -- Better comment type detection
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = {
          enable_autocmd = false,
        },
      },
    },
    keys = {
      { 'gc', mode = { 'n', 'x', 'o' } },
      { 'gb', mode = { 'n', 'x', 'o' } },
      -- Comment text object. Taken from https://github.com/numToStr/Comment.nvim/issues/22#issuecomment-1272569139
      {
        'gc',
        function()
          local utils = require 'Comment.utils'

          local row = vim.api.nvim_win_get_cursor(0)[1]

          local comment_str = require('Comment.ft').calculate {
            ctype = utils.ctype.linewise,
            range = {
              srow = row,
              scol = 0,
              erow = row,
              ecol = 0,
            },
            cmotion = utils.cmotion.line,
            cmode = utils.cmode.toggle,
          } or vim.bo.commentstring
          local l_comment_str, r_comment_str = utils.unwrap_cstr(comment_str)

          local is_commented = utils.is_commented(l_comment_str, r_comment_str, true)

          local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)
          if next(line) == nil or not is_commented(line[1]) then
            return
          end

          local comment_start, comment_end = row, row
          repeat
            comment_start = comment_start - 1
            line = vim.api.nvim_buf_get_lines(0, comment_start - 1, comment_start, false)
          until next(line) == nil or not is_commented(line)
          comment_start = comment_start + 1
          repeat
            comment_end = comment_end + 1
            line = vim.api.nvim_buf_get_lines(0, comment_end - 1, comment_end, false)
          until next(line) == nil or not is_commented(line)
          comment_end = comment_end - 1

          vim.cmd(string.format('normal! %dGV%dG', comment_start, comment_end))
        end,
        mode = 'o',
        desc = 'Comment',
      },
    },
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
    dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
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
      require('which-key').add(ret, { notify = false })
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
            local copilot = require 'copilot.suggestion'

            local has_words_before = function()
              local line, col = unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
            end

            if copilot.is_visible() then
              copilot.accept()
              return true
            elseif cmp.is_visible() then
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
          window = {
            border = 'rounded',
          },
        },
      },
    },
  },

  -- Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    keys = {
      {
        '<leader>ta',
        function()
          require('copilot.suggestion').toggle_auto_trigger()
        end,
        desc = 'Toggle AI auto-suggestions',
      },
    },
    opts = {
      panel = { enabled = false },
      suggestion = {
        auto_trigger = false,
        keymap = {
          -- Handled in <tab> keybinding in blink.cmp configuration.
          accept = false,
          accept = '<m-enter>',
          accept_word = '<m-w>',
          accept_line = '<m-l>',
          next = '<c-]>',
          prev = '<c-[>',
          dismiss = '<c-c>',
        },
      },
      filetypes = {
        markdown = true,
        ledger = false,
      },
      copilot_node_command = vim.g.node_binary_path,
    },
    config = function(_, opts)
      require('copilot').setup(opts)

      -- Hide suggestions when the completion menu is open.
      local copilot = require 'copilot.suggestion'
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          copilot.dismiss()
          vim.b.copilot_suggestion_hidden = true
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  },

  -- Auto pairs
  {
    'echasnovski/mini.pairs',
    event = 'InsertEnter',
    config = true,
  },

  -- Deal with surroundings tags/quotes/brackets
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {
      keymaps = {
        insert = false,
        insert_line = false,
        normal = 'ys',
        normal_line = 'yS',
        normal_cur = 'yss',
        normal_cur_line = 'ySS',
        visual = 'S',
        visual_line = 'gS',
        delete = 'ds',
        change = 'cs',
        change_line = 'cS',
      },
    },
  },

  -- Remove whitespace
  {
    'lewis6991/spaceless.nvim',
    event = 'InsertEnter',
    config = true,
  },
}
