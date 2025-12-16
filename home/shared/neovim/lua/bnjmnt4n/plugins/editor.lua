return {
  -- File explorer
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    },
    opts = {
      keymaps = {
        ['<C-h>'] = false,
        ['<C-l>'] = false,
        ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
        gR = 'actions.refresh',
      },
      view_options = {
        show_hidden = true,
      },
    },
  },

  -- Git links
  {
    'linrongbin16/gitlinker.nvim',
    cmd = { 'GitLink' },
    keys = {
      { '<leader>gy', '<cmd>GitLink<cr>', desc = 'Copy file link to clipboard', mode = { 'n', 'v' } },
      { '<leader>gY', '<cmd>GitLink!<cr>', desc = 'Open file link in browser', mode = { 'n', 'v' } },
      { '<leader>gb', '<cmd>GitLink blame<cr>', desc = 'Copy blame link to clipboard', mode = { 'n', 'v' } },
      { '<leader>gB', '<cmd>GitLink! blame<cr>', desc = 'Open blame link in browser', mode = { 'n', 'v' } },
    },
    opts = {
      message = false,
    },
  },

  -- Symbol outlines
  {
    'stevearc/aerial.nvim',
    cmd = { 'AerialToggle' },
    keys = {
      { '<leader>os', '<cmd>AerialToggle<cr>', desc = 'Toggle symbols' },
    },
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
  },

  -- Code formatting
  {
    'stevearc/conform.nvim',
    event = { 'LspAttach', 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        '<cmd>Format<cr>',
        -- function()
        --   require('conform').format { async = true, lsp_fallback = true }
        -- end,
        mode = '',
        desc = 'Format',
      },
      {
        '<leader>tF',
        function()
          local disabled = not (vim.g.disable_autoformat == true)
          vim.g.disable_autoformat = disabled
          if disabled then
            vim.notify 'Disabled autoformat'
          else
            vim.notify 'Enabled autoformat'
          end
        end,
        desc = 'Toggle autoformat',
      },
      {
        '<leader>tf',
        function()
          local disabled = not (vim.b.disable_autoformat == true)
          vim.b.disable_autoformat = disabled
          if disabled then
            vim.notify 'Disabled autoformat (buffer)'
          else
            vim.notify 'Enabled autoformat (buffer)'
          end
        end,
        desc = 'Toggle autoformat (buffer)',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        c = {},
        cpp = {},
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      },
      format_on_save = function(bufnr)
        local extra_lang_args = {
          c = { lsp_fallback = 'always', name = 'clangd' },
          cpp = { lsp_fallback = 'always', name = 'clangd' },
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
    cmd = { 'Telescope' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-ui-select.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        dir = vim.g.telescope_fzf_native_path,
      },
    },
    -- stylua: ignore
    keys = {
      { '<leader><space>', function() require('telescope.builtin').find_files() end, desc = 'Find files in folder' },
      {
        '<leader>.',
        function() require('telescope.builtin').find_files { cwd = vim.fn.expand '%:p:h' } end,
        desc = "Find in current file's directory",
      },
      { '<leader>,', function() require('telescope.builtin').buffers { sort_lastused = true } end, desc = 'Find buffer' },
      { '<leader>?', function() require('telescope.builtin').oldfiles() end, desc = 'Recent files' },
      { '<leader>/', function() require('telescope.builtin').live_grep() end, desc = 'Search in project' },
      { "<leader>'", function() require('telescope.builtin').resume() end, desc = 'Resume previous search' },
      { '<leader>bi', function() require('telescope.builtin').buffers() end, desc = 'Find buffer' },
      { '<leader>cb', function() require('telescope.builtin').lsp_document_symbols() end, desc = 'Document symbols' },
      { '<leader>dd', function() require('telescope.builtin').diagnostics() end, desc = 'Diagnostics' },
      { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find files' },
      { '<leader>fr', function() require('telescope.builtin').oldfiles() end, desc = 'Recent files' },
      { '<leader>gp', function() require('telescope.builtin').git_bcommits() end, desc = 'git buffer commits' },
      { '<leader>gs', function() require('telescope.builtin').git_status() end, desc = 'git status' },
      { '<leader>sd', function() require('telescope.builtin').grep_string() end, desc = 'Find current word in project' },
      { '<leader>sh', function() require('telescope.builtin').help_tags() end, desc = 'Find help' },
      { '<leader>ss', function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Find in buffer' },
      { '<leader>sp', function() require('telescope.builtin').live_grep() end, desc = 'Find in project' },
    },
    opts = function()
      return {
        -- stylua: ignore
        defaults = {
          mappings = {
            n = {
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
      require('telescope').load_extension 'ui-select'
    end,
  },

  -- Buffer deletion
  {
    'nvim-mini/mini.bufremove',
    -- stylua: ignore
    keys = {
      { '<leader>bd', function() require('mini.bufremove').delete(0, false) end, desc = 'Delete buffer' },
      { '<leader>bk', function() require('mini.bufremove').delete(0, false) end, desc = 'Delete buffer' },
      { '<leader>bD', function() require('mini.bufremove').delete(0, true) end,  desc = 'Delete buffer (force)' },
      { '<leader>bK', function() require('mini.bufremove').delete(0, true) end,  desc = 'Delete buffer (force)' },
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
      signs_staged_enable = false,
      numhl = true,
      current_line_blame = true,

      on_attach = function(bufnr)
        local gs = require 'gitsigns'

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
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    cmd = { 'Neogit' },
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit' },
    },
    opts = {
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
    event = { 'BufReadPost' },
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

  -- TODO comments
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'TodoTelescope', 'TodoQuickFix', 'TodoLocList' },
    event = { 'BufReadPost', 'BufNewFile' },
    -- stylua: ignore
    keys = {
      { '<leader>st', '<cmd>TodoTelescope<cr>',                            desc = 'Find todos' },
      { ']w',         function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
      { '[w',         function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
    },
    opts = {},
  },

  -- Convenient access to nvim terminal
  {
    'akinsho/toggleterm.nvim',
    cmd = { 'ToggleTerm' },
    keys = {
      { '<m-`>', '<cmd>ToggleTerm<cr>', desc = 'Open terminal' },
      { '<leader>ot', '<cmd>ToggleTerm<cr>', desc = 'Open terminal' },
    },
    opts = {},
  },

  -- Async building & commands
  {
    'tpope/vim-dispatch',
    cmd = { 'Make', 'Copen', 'Dispatch', 'FocusDispatch', 'Start', 'Spawn' },
  },

  -- Common UNIX functions
  {
    'tpope/vim-eunuch',
    event = { 'VeryLazy' },
    keys = {
      { '<leader>fD', '<cmd>Delete!<cr>', desc = 'Delete file' },
    },
  },
}
