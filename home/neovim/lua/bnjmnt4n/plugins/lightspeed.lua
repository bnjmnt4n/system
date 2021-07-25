LightspeedRepeatFt = function(reverse)
  local ls = require 'lightspeed'
  ls.ft['instant-repeat?'] = true
  ls.ft:to(reverse, ls.ft['prev-t-like?'])
end

vim.api.nvim_set_keymap('n', ';', '<cmd>lua LightspeedRepeatFt(false)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', ';', '<cmd>lua LightspeedRepeatFt(false)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',', '<cmd>lua LightspeedRepeatFt(true)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', ',', '<cmd>lua LightspeedRepeatFt(true)<CR>', { noremap = true, silent = true })
