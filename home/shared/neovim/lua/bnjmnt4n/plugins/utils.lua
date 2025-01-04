return {
  {
    'folke/lazy.nvim',
    commit = vim.g.lazy_rev,
    dir = vim.g.lazy_path,
    -- Do not update lazy.nvim; this is managed by Nix.
    pin = true,
  },

  -- Common Lua utility shared by various plugins
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },
}
