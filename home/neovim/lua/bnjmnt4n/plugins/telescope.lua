-- Telescope
local trouble = require 'trouble.providers.telescope'

require('telescope').setup {
  defaults = {
    i = { ['<c-t>'] = trouble.open_with_trouble },
    n = { ['<c-t>'] = trouble.open_with_trouble },
  },
  extensions = {
    fzf = {
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}

require('telescope').load_extension 'fzf'
require('telescope').load_extension 'file_browser'
require('telescope').load_extension 'ui-select'
