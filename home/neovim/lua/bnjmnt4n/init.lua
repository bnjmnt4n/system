-- Based on:
-- - https://github.com/LazyVim/LazyVim
-- - https://github.com/MariaSolOs/dotfiles
-- and probably many others.

vim.g.lazy_path = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
vim.opt.rtp:prepend(vim.g.lazy_path)

require 'bnjmnt4n.settings'
require 'bnjmnt4n.keymaps'
require 'bnjmnt4n.autocmds'
require 'bnjmnt4n.lsp'

-- Load plugins
require('lazy').setup('bnjmnt4n.plugins', {
  ui = { border = 'rounded' },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'netrw',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
