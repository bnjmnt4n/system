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
    config = function()
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

      -- Register all text objects with which-key.
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
        k = 'JSON key',
        o = 'Block, conditional, loop',
        q = 'Quote `, ", \'',
        t = 'Tag',
        v = 'JSON value',
        x = 'XML attribute',
      }
      local a = vim.deepcopy(i)
      for k, v in pairs(a) do
        a[k] = v:gsub(' including.*', '')
      end
      local ic = vim.deepcopy(i)
      local ac = vim.deepcopy(a)
      for key, name in pairs { n = 'Next', l = 'Last' } do
        ---@type table<string, string|table<string,string>>
        i[key] = vim.tbl_extend('force', { name = 'Inside ' .. name .. ' textobject' }, ic)
        ---@type table<string, string|table<string,string>>
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
    opts = function()
      local types = require 'luasnip.util.types'

      return {
        link_children = true,
        update_events = { 'TextChanged', 'TextChangedI' },
        delete_check_events = 'InsertLeave',
        ext_opts = {
          -- Display a bullet for choice nodes.
          [types.choiceNode] = {
            passive = {
              virt_text = { { '•', 'Comment' } },
              virt_text_pos = 'inline',
            },
          },
          -- Display a cursor-like placeholder in unvisited nodes of the snippet.
          [types.insertNode] = {
            unvisited = {
              virt_text = { { '|', 'Conceal' } },
              virt_text_pos = 'inline',
            },
          },
          [types.exitNode] = {
            unvisited = {
              virt_text = { { '|', 'Conceal' } },
              virt_text_pos = 'inline',
            },
          },
        },
        ext_base_prio = 300,
        ext_prio_increase = 1,
      }
    end,
    config = function(_, opts)
      local luasnip = require 'luasnip'
      luasnip.setup(opts)
      luasnip.filetype_extend('javascriptreact', { 'javascript' })
      luasnip.filetype_extend('typescript', { 'javascript' })
      luasnip.filetype_extend('typescriptreact', { 'javascript', 'javascriptreact' })
      require('luasnip.loaders.from_lua').lazy_load()

      vim.keymap.set({ 'i', 's' }, '<c-k>', function()
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { desc = 'Expand or jump to next placeholder' })
      vim.keymap.set({ 'i', 's' }, '<c-j>', function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { desc = 'Jump to previous placeholder' })
      -- -- Use <C-c> to select a choice in a snippet.
      -- vim.keymap.set({ 'i', 's' }, '<c-c>', function()
      --   if luasnip.choice_active() then
      --     require 'luasnip.extras.select_choice'()
      --   end
      -- end, { desc = 'Select choice' })
      vim.keymap.set({ 'i', 's' }, '<c-e>', function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, { desc = 'Change choice' })
      vim.keymap.set('s', '<bs>', '<c-o>s', { desc = 'Remove placeholder' })

      vim.api.nvim_create_autocmd('ModeChanged', {
        group = vim.api.nvim_create_augroup('bnjmnt4n/unlink_snippet', { clear = true }),
        desc = 'Cancel the snippet session when leaving insert mode',
        pattern = { 's:n', 'i:*' },
        callback = function(args)
          if
            luasnip.session
            and luasnip.session.current_nodes[args.buf]
            and not luasnip.session.jump_active
            and not luasnip.choice_active()
          then
            luasnip.unlink_current()
          end
        end,
      })
    end,
  },

  -- nvim-cmp
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },
    opts = function()
      local cmp = require 'cmp'

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
      end

      local winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None'
      return {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            border = 'rounded',
            winhighlight = winhighlight,
          },
          documentation = {
            border = 'rounded',
            winhighlight = winhighlight,
          },
        },
        completion = {
          autocomplete = false,
        },
        mapping = cmp.mapping.preset.insert {
          ['<c-d>'] = cmp.mapping.scroll_docs(-4),
          ['<c-f>'] = cmp.mapping.scroll_docs(4),
          ['<c-space>'] = cmp.mapping.complete(),
          ['<cr>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<c-c>'] = cmp.mapping.close(),
          ['<tab>'] = cmp.mapping(function(fallback)
            local copilot = require 'copilot.suggestion'

            if copilot.is_visible() then
              copilot.accept()
            elseif cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<s-tab>'] = cmp.mapping.select_prev_item(),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        },
      }
    end,
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
        auto_trigger = true,
        keymap = {
          -- Handled in <tab> keybinding in nvim-cmp configuration.
          accept = false,
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
    -- Based on https://github.com/MariaSolOs/dotfiles/blob/5d961a1751fbd8f50b0cef4d51e9df3eb8a32687/.config/nvim/lua/plugins/copilot.lua.
    config = function(_, opts)
      local cmp = require 'cmp'
      local copilot = require 'copilot.suggestion'
      local luasnip = require 'luasnip'

      require('copilot').setup(opts)

      ---@param trigger boolean
      local function set_trigger(trigger)
        if not trigger and copilot.is_visible() then
          copilot.dismiss()
        end
        vim.b.copilot_suggestion_auto_trigger = trigger
        vim.b.copilot_suggestion_hidden = not trigger
      end

      -- Hide suggestions when the completion menu is open.
      cmp.event:on('menu_opened', function()
        set_trigger(false)
      end)
      cmp.event:on('menu_closed', function()
        set_trigger(not luasnip.expand_or_locally_jumpable())
      end)

      vim.api.nvim_create_autocmd('User', {
        desc = 'Disable Copilot inside snippets',
        pattern = { 'LuasnipInsertNodeEnter', 'LuasnipInsertNodeLeave' },
        callback = function()
          set_trigger(not luasnip.expand_or_locally_jumpable())
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
