-- auto-pairs
require('nvim-autopairs').setup {
  disable_filetype = { 'TelescopePrompt', 'vim' },
}

require('nvim-autopairs.completion.compe').setup {
  map_cr = true,
  map_complete = false,
}
