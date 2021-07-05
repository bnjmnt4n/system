-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'c',
    'comment',
    'cpp',
    'css',
    'fish',
    'glimmer',
    'go',
    'graphql',
    'haskell',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'jsonc',
    'ledger',
    'lua',
    'nix',
    'python',
    'query',
    'regex',
    'ruby',
    'rust',
    'scss',
    'svelte',
    'toml',
    'tsx',
    'typescript',
    'vue',
    'yaml',
    'zig',
  },
  highlight = {
    enable = true,
    disable = { 'comment', 'jsdoc' },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      scope_incremental = ';',
      node_decremental = '<BS>',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['iF'] = {
          python = '(function_definition) @function',
          cpp = '(function_definition) @function',
          c = '(function_definition) @function',
          java = '(method_declaration) @function',
        },
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
        ['ac'] = '@conditional.outer',
        ['ic'] = '@conditional.inner',
        ['ae'] = '@block.outer',
        ['ie'] = '@block.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['is'] = '@statement.inner',
        ['as'] = '@statement.outer',
        ['ad'] = '@comment.outer',
        ['am'] = '@call.outer',
        ['im'] = '@call.inner',
      },
    },
  },
  context_commentstring = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  playground = {
    enable = true,
  },
}

-- Treesitter folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- TODO: better fold settings
vim.wo.foldenable = false
