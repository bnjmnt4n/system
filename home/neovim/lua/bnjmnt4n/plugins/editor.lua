return {
  -- Directory viewer
  'justinmk/vim-dirvish',

  -- Git commands
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    keys = {
      { '<leader>gG', '<cmd>Git<cr>', desc = 'Fugitive' },
      { '<leader>ga', '<cmd>Git add %:p<cr><cr>', desc = 'git add current file' },
      { '<leader>gd', '<cmd>Gdiffsplit<cr>', desc = 'git diff' },
      { '<leader>ge', '<cmd>Gedit<cr>', desc = 'git edit' },
      { '<leader>gr', '<cmd>Gread<cr>', desc = 'git read' },
      { '<leader>gw', '<cmd>Gwrite<cr><cr>', desc = 'git write' },
      { '<leader>gl', ':silent! Gclog<cr>:bot copen<cr>', desc = 'git log', silent = false },
      { '<leader>gm', ':GMove<space>', desc = 'git move', silent = false },
      { '<leader>go', ':Git checkout<space>', desc = 'git checkout', silent = false },
    },
  },

  -- Git links
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    keys = {
      { '<leader>gy', '<cmd>GitLink<cr>', desc = 'Copy link to clipboard', mode = { 'n', 'v' } },
      { '<leader>gY', '<cmd>GitLink!<cr>', desc = 'Open link in browser', mode = { 'n', 'v' } },
    },
    opts = {
      message = false,
    },
  },

  -- Symbol outlines
  {
    'stevearc/aerial.nvim',
    event = 'VeryLazy',
    opts = {
      attach_mode = 'global',
      backends = { 'lsp', 'treesitter', 'markdown', 'man' },
      show_guides = true,
      guides = {
        mid_item = '├╴',
        last_item = '└╴',
        nested_top = '│ ',
        whitespace = '  ',
      },
    },
    keys = {
      { '<leader>os', '<cmd>AerialToggle<cr>', desc = 'Open symbols' },
    },
  },

  -- Code formatting
  {
    'stevearc/conform.nvim',
    event = { 'LspAttach', 'BufWritePre' },
    cmd = 'ConformInfo',
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = 'Format',
      },
      {
        '<leader>tf',
        function()
          local Util = require 'lazy.core.util'
          local disabled = not (vim.g.disable_autoformat == true)
          vim.g.disable_autoformat = disabled
          if disabled then
            Util.info('Disabled autoformat', { title = 'Autoformat' })
          else
            Util.info('Enabled autoformat', { title = 'Autoformat' })
          end
        end,
        desc = 'Toggle autoformat',
      },
      {
        '<leader>tf',
        function()
          local Util = require 'lazy.core.util'
          local disabled = not (vim.b.disable_autoformat == true)
          vim.b.disable_autoformat = disabled
          if disabled then
            Util.info('Disabled autoformat (buffer)', { title = 'Autoformat' })
          else
            Util.info('Enabled autoformat (buffer)', { title = 'Autoformat' })
          end
        end,
        desc = 'Toggle autoformat (buffer)',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { { 'prettierd', 'prettier' } },
        javascriptreact = { { 'prettierd', 'prettier' } },
        typescript = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
      },
      format_on_save = function(bufnr)
        local extra_lang_args = {
          javascript = { lsp_fallback = 'always', name = 'eslint' },
          typescript = { lsp_fallback = 'always', name = 'eslint' },
          javascriptreact = { lsp_fallback = 'always', name = 'eslint' },
          typescriptreact = { lsp_fallback = 'always', name = 'eslint' },
        }

        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        local default_args = {
          timeout_ms = 500,
          lsp_fallback = true,
        }
        local extra_args = extra_lang_args[vim.bo[bufnr].filetype] or {}
        return vim.tbl_deep_extend('force', default_args, extra_args)
      end,
    },
    init = function()
      -- Use conform for gq.
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      -- :Format user command.
      vim.api.nvim_create_user_command('Format', function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
          }
        end
        require('conform').format { async = true, lsp_fallback = true, range = range }
      end, { range = true, desc = 'Format' })
    end,
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        dir = vim.g.telescope_fzf_native_path,
      },
    },
    -- stylua: ignore
    keys = {
      {
        '<leader><space>',
        function() require('telescope.builtin').find_files() end,
        desc = 'Find files in folder'
      },
      {
        '<leader>.',
        function() require('telescope').extensions.file_browser.file_browser { cwd = vim.fn.expand '%:p:h', hidden = true } end,
        desc = 'Find in current directory',
      },
      {
        '<leader>,',
        function() require('telescope.builtin').buffers { sort_lastused = true } end,
        desc = 'Find buffer',
      },
      { '<leader>?',  function() require('telescope.builtin').oldfiles() end, desc = 'Recent files' },
      {
        '<leader>/',
        function() require('telescope.builtin').live_grep() end,
        desc = 'Search in project'
      },
      {
        "<leader>'",
        function() require('telescope.builtin').resume() end,
        desc = 'Resume previous search'
      },
      { '<leader>bi', function() require('telescope.builtin').buffers() end,  desc = 'Find buffer' },

      {
        '<leader>cb',
        function() require('telescope.builtin').lsp_document_symbols() end,
        desc = 'Document symbols'
      },
      {
        '<leader>cx',
        function() require('telescope.builtin').lsp_workspace_diagnostics() end,
        desc = 'Workspace diagnostics'
      },
      {
        '<leader>ff',
        function() require('telescope.builtin').find_files() end,
        desc =
        'Find files in folder'
      },
      { '<leader>fr', function() require('telescope.builtin').oldfiles() end,     desc = 'Recent files' },
      { '<leader>gc', function() require('telescope.builtin').git_commits() end,  desc = 'git commits' },
      { '<leader>gb', function() require('telescope.builtin').git_branches() end, desc = 'git branches' },
      { '<leader>gs', function() require('telescope.builtin').git_status() end,   desc = 'git status' },
      {
        '<leader>gp',
        function() require('telescope.builtin').git_bcommits() end,
        desc =
        'git buffer commits'
      },
      {
        '<leader>sd',
        function() require('telescope.builtin').grep_string() end,
        desc =
        'Find current word in project'
      },
      { '<leader>sh', function() require('telescope.builtin').help_tags() end, desc = 'Find help' },
      {
        '<leader>ss',
        function() require('telescope.builtin').current_buffer_fuzzy_find() end,
        desc =
        'Find in buffer'
      },
      {
        '<leader>sp',
        function() require('telescope.builtin').live_grep() end,
        desc =
        'Find in project'
      },
    },
    opts = function()
      return {
        -- stylua: ignore
        defaults = {
          mappings = {
            i = {
              ['<c-t>'] = function(...) return require('trouble.providers.telescope').open_with_trouble(...) end,
            },
            n = {
              ['<c-t>'] = function(...) return require('trouble.providers.telescope').open_with_trouble(...) end,
              ['q'] = function(...) return require('telescope.actions').close(...) end,
            },
          },
        },
        extensions = {
          fzf = {
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      }
    end,
    config = function(_, opts)
      require('telescope').setup(opts)
      require('telescope').load_extension 'fzf'
      require('telescope').load_extension 'file_browser'
      require('telescope').load_extension 'ui-select'
    end,
  },

  -- Buffer deletion
  {
    'echasnovski/mini.bufremove',
    -- stylua: ignore
    keys = {
      { '<leader>bd', function() require('mini.bufremove').delete(0, false) end, desc = 'Delete buffer' },
      { '<leader>bk', function() require('mini.bufremove').delete(0, false) end, desc = 'Delete buffer' },
      { '<leader>bD', function() require('mini.bufremove').delete(0, true) end,  desc = 'Delete buffer (force)' },
      { '<leader>bK', function() require('mini.bufremove').delete(0, true) end,  desc = 'Delete buffer (force)' },
    },
  },

  -- Mass editing of the quickfix list
  {
    'Olical/vim-enmasse',
    cmd = 'EnMasse',
    keys = {
      { '<leader>oe', '<cmd>EnMasse<cr>', desc = 'Edit quickfix list' },
    },
  },

  -- Gitsigns
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▎' },
        topdelete = { text = '󱨉' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signcolumn = true,
      numhl = true,
      current_line_blame = true,

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Next hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Previous hunk' })
        map('n', ']h', gs.next_hunk, { desc = 'Next hunk' })
        map('n', '[h', gs.prev_hunk, { desc = 'Previous hunk' })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage hunk' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = true }
        end, { desc = 'Blame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'Diff this' })
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = 'Diff this ~' })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle current line blame' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>', { desc = 'Hunk' })
      end,
    },
  },

  -- Git client
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    dependencies = 'sindrets/diffview.nvim',
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit' },
    },
    opts = {
      disable_commit_confirmation = true,
      integrations = {
        diffview = true,
      },
    },
  },

  -- Split diff tool
  {
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
    },
    opts = {
      use_icons = true,
    },
  },

  -- Git conflict markers
  {
    'akinsho/git-conflict.nvim',
    event = 'BufReadPost',
    opts = {
      default_mappings = {
        ours = '<leader>hco',
        theirs = '<leader>hct',
        none = '<leader>hcn',
        both = '<leader>hcb',
        next = ']x',
        prev = '[x',
      },
    },
  },

  -- Pretty lists
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble', 'TroubleToggle' },
    -- stylua: ignore
    keys = {
      { '<leader>xx', '<cmd>Trouble<cr>',                                                              desc = 'Trouble' },
      { '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>',                                        desc = 'Trouble Workspace Diagnostics' },
      { '<leader>xd', '<cmd>Trouble document_diagnostics<cr>',                                         desc = 'Trouble Document Diagnostics' },
      { '<leader>xl', '<cmd>Trouble loclist<cr>',                                                      desc = 'Trouble Loclist' },
      { '<leader>xq', '<cmd>Trouble quickfix<cr>',                                                     desc = 'Trouble Quickfix' },
      { '<leader>xn', function() require("trouble").next({ skip_groups = true, jump = true }) end,     desc = 'Next' },
      { '<leader>xp', function() require("trouble").previous({ skip_groups = true, jump = true }) end, desc = 'Previous' },
    },
    config = true,
  },

  -- TODO comments
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPost', 'BufNewFile' },
    -- stylua: ignore
    keys = {
      { '<leader>xt', '<cmd>TodoTrouble<cr>',                              desc = 'Touble Todos' },
      { '<leader>xT', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>',      desc = 'Trouble Todo/Fix/Fixme' },
      { '<leader>st', '<cmd>TodoTelescope<cr>',                            desc = 'Find todos' },
      { ']t',         function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
      { '[t',         function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
    },
    config = true,
  },

  -- Convenient access to nvim terminal
  {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = {
      { '<m-`>', '<cmd>ToggleTerm<cr>', desc = 'Toggle terminal' },
      { '<leader>ot', '<cmd>ToggleTerm<cr>', desc = 'Toggle terminal' },
    },
    opts = {},
  },

  -- Async building & commands
  {
    'tpope/vim-dispatch',
    cmd = { 'Dispatch', 'Make', 'Focus', 'Start' },
  },

  -- Common UNIX functions
  {
    'tpope/vim-eunuch',
    event = 'VeryLazy',
  },
}
