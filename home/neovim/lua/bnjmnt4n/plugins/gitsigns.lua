-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { hl = 'GitGutterAdd', text = '+' },
    change = { hl = 'GitGutterChange', text = '~' },
    delete = { hl = 'GitGutterDelete', text = '_' },
    topdelete = { hl = 'GitGutterDelete', text = '‾' },
    changedelete = { hl = 'GitGutterChange', text = '~' },
  },

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local wk = require 'which-key'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    wk.register({
      [']c'] = { "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", 'Next hunk' },
      ['[c'] = { "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", 'Previous hunk' },
    }, {
      buffer = bufnr,
      expr = true,
    })

    -- Actions
    wk.register({
      ['<leader>'] = {
        h = {
          s = { ':Gitsigns stage_hunk<CR>', 'Stage hunk' },
          r = { ':Gitsigns reset_hunk<CR>', 'Reset hunk' },
        },
      },
    }, {
      mode = 'nv',
      buffer = bufnr,
    })
    wk.register({
      ['<leader>'] = {
        h = {
          S = { gs.stage_buffer, 'Stage buffer' },
          u = { gs.undo_stage_hunk, 'Undo stage hunk' },
          R = { gs.reset_buffer, 'Reset buffer' },
          p = { gs.preview_hunk, 'Preview hunk' },
          b = {
            function()
              gs.blame_line { full = true }
            end,
            'Blame line',
          },
          d = { gs.diffthis, 'Diff' },
          D = {
            function()
              gs.diffthis '~'
            end,
            '',
          },
        },
        t = {
          b = { gs.toggle_current_line_blame, 'Toggle current line blame' },
          d = { gs.toggle_deleted, 'Toggle deleted' },
        },
      },
    }, {
      buffer = bufnr,
    })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
}
