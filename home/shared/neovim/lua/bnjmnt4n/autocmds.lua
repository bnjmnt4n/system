vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('bnjmnt4n/term_nonu', { clear = true }),
  desc = 'Disable line numbers in terminal mode',
  pattern = '*',
  command = 'set nonu nornu',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('bnjmnt4n/highlight_on_yank', { clear = true }),
  desc = 'Highlight yanked text',
  pattern = '*',
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('bnjmnt4n/quit_shortcuts', { clear = true }),
  desc = 'Close with <q>',
  pattern = {
    'help',
    'man',
    'qf',
    'query',
  },
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf, desc = 'Quit' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('bnjmnt4n/qf_config', { clear = true }),
  desc = 'qf: configuration',
  pattern = 'qf',
  callback = function()
    vim.b.relativenumber = false
    vim.keymap.set('n', 'x', ':quit <bar> Trouble quickfix<cr>', { buffer = true, silent = true })
  end,
})
