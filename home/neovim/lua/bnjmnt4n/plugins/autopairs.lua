-- nvim-autopairs
require('nvim-autopairs').setup {
  disable_filetype = { 'TelescopePrompt', 'vim' },
}

require('nvim-autopairs.completion.cmp').setup {
  map_cr = true,
  -- Insert `(` after completing a function or method item
  map_complete = true,
  -- Automatically select the first item
  auto_select = true,
}
