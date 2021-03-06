require('which-key').setup {}

-- Leader keybindings
require('which-key').register {
  ['<leader>'] = {
    ['<space>'] = { [[<cmd>lua require('telescope.builtin').find_files()<CR>]], 'Find files in folder' },
    ['.'] = {
      [[<cmd>lua require('telescope.builtin').file_browser({ cwd = vim.fn.expand('%:p:h'), hidden = true })<CR>]],
      'Find in current directory',
    },
    [','] = { [[<cmd>lua require('telescope.builtin').buffers({ sort_lastused = true })<CR>]], 'Find buffer' },
    ['?'] = { [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], 'Recent files' },
    ['/'] = { [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], 'Search in project' },

    b = {
      name = '+buffer',
      b = { [[<cmd>lua require('telescope.builtin').buffers()<CR>]], 'Find buffer' },
      i = { [[<cmd>lua require('telescope.builtin').buffers()<CR>]], 'Find buffer' },
      n = { '<cmd>bnext<CR>', 'Next buffer' },
      p = { '<cmd>bprevious<CR>', 'Previous buffer' },
      d = { '<cmd>bdelete<CR>', 'Delete buffer' },
      k = { '<cmd>bdelete<CR>', 'Delete buffer' },
      K = { '<cmd>bdelete!<CR>', 'Force delete buffer' },
    },

    c = {
      name = '+code',
      a = { [[<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>]], 'Code actions' },
      b = {
        [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
        'Document symbols',
      },
      d = { [[:cd %:p:h<CR>:pwd<CR>]], 'Change directory' },
      f = { '<cmd>Format<CR>', 'Format' },
      x = {
        [[<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<CR>]],
        'Workspace diagnostics',
      },
    },

    f = {
      name = '+file',
      f = { [[<cmd>lua require('telescope.builtin').find_files()<CR>]], 'Find files in folder' },
      r = { [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], 'Recent files' },
      s = { '<cmd>w<CR>', 'Save file' },
    },

    g = {
      name = '+git',
      g = { '<cmd>Neogit<CR>', 'Neogit' },
      c = {
        [[<cmd>lua require('telescope.builtin').git_commits()<CR>]],
        'git commits',
      },
      b = {
        [[<cmd>lua require('telescope.builtin').git_branches()<CR>]],
        'git branches',
      },
      s = {
        [[<cmd>lua require('telescope.builtin').git_status()<CR>]],
        'git status',
      },
      p = {
        [[<cmd>lua require('telescope.builtin').git_bcommits()<CR>]],
        'git buffer commits',
      },
      a = { '<cmd>Git add %:p<CR><CR>', 'git add current file' },
      d = { '<cmd>Gdiff<CR>', 'git diff' },
      e = { '<cmd>Gedit<CR>', 'git edit' },
      r = { '<cmd>Gread<CR>', 'git read' },
      w = { '<cmd>Gwrite<CR><CR>', 'git write' },
    },

    h = {
      name = '+git hunks',
    },

    l = {
      name = '+lsp',
      i = { '<cmd>LspInfo<CR>', 'LSP information' },
      r = { '<cmd>LspRestart<CR>', 'Restart LSP servers' },
      s = { '<cmd>LspStart<CR>', 'Start LSP servers' },
      t = { '<cmd>LspStop<CR>', 'Stop LSP servers' },
      w = {
        name = '+workspace',
        a = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add workspace folder' },
        r = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove workspace folder' },
        l = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'List workspace folders' },
      },
    },

    n = {
      name = '+neovim',
      u = { '<cmd>PackerUpdate<CR>', 'Update plugins' },
    },

    o = {
      name = '+open',
      p = { '<cmd>lua ProjectSearch()<CR>', 'Find project' },
      t = { '<cmd>split +term<CR>', 'Open terminal in split' },
    },

    q = {
      name = '+quickfix',
      o = { '<cmd>copen<CR>', 'Open quickfix list' },
      q = { '<cmd>cclose<CR>', 'Close quickfix list' },
    },

    s = {
      name = '+search',
      d = {
        [[<cmd>lua require('telescope.builtin').grep_string()<CR>]],
        'Find current word in project',
      },
      h = {
        [[<cmd>lua require('telescope.builtin').help_tags()<CR>]],
        'Find help',
      },
      s = {
        [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]],
        'Find in buffer',
      },
      p = {
        [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
        'Find in project',
      },
    },

    w = {
      name = '+window',
      h = { '<C-w>h', 'Move left' },
      j = { '<C-w>j', 'Move down' },
      k = { '<C-w>k', 'Move up' },
      l = { '<C-w>l', 'Move right' },
      c = { '<C-w>c', 'Close window' },
      v = { '<C-w>v', 'Create new vertical split' },
      s = { '<C-w>s', 'Create new horizontal split' },
      m = { '<C-w>_<C-w><Bar>', 'Maximize window' },
      o = { '<C-w>o', 'Close other windows window' },
      t = { '<C-w>T', 'Shift buffer to new tab' },
      n = { '<cmd>tabnew<CR>', 'Create new tab' },
    },

    z = {
      name = '+quit',
      z = { '<cmd>qa<CR>', 'Quit' },
      Z = { '<cmd>qa!<CR>', 'Force quit' },
    },
  },
}

-- System clipboard yank/paste
-- TODO: yank in visual mode
require('which-key').register {
  ['<leader>'] = {
    p = { [["+p]], 'Paste from system clipboard (p)' },
    P = { [["+P]], 'Paste from system clipboard (P)' },
    y = { [["+y]], 'Yank from system clipboard (y)' },
    Y = { [["+y$]], 'Yank from system clipboard (Y)' },
  },
}

-- Git shortcuts
require('which-key').register({
  ['<leader>g'] = {
    l = { ':silent! Glog<CR>:bot copen<CR>', 'git log' },
    m = { ':Gmove<Space>', 'git move' },
    o = { ':Git checkout<Space>', 'git checkout' },
  },
}, {
  silent = false,
})

-- Random shortcut
require('which-key').register({
  ['<leader>;'] = { ':', 'Command' },
}, {
  silent = false,
})
