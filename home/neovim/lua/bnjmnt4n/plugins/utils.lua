return {
  -- Do not update lazy.nvim; this is managed by Nix.
  {
    'folke/lazy.nvim',
    dir = vim.g.lazy_path,
  },

  -- Common Lua utility shared by various plugins
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },
}
