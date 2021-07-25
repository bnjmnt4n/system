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

-- Find and switch to projects in `~/repos`
ProjectSearch = function()
  require('telescope.builtin').file_browser {
    previewer = false,
    layout_strategy = 'vertical',
    cwd = '~/repos',
    attach_mappings = function(prompt_bufnr, map)
      local chdir = function()
        local entry = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        vim.cmd(':chdir ' .. entry.value)
        vim.cmd ':edit .'
      end

      map('i', '<CR>', chdir)
      map('n', '<CR>', chdir)

      return true
    end,
  }
end
