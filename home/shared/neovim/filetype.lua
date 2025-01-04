vim.filetype.add {
  extension = {
    astro = 'astro',
    jjdescription = 'jjdescription',
  },
  filename = {
    ['.eslintrc.json'] = 'jsonc',
    ['flake.lock'] = 'json',
    ['.git/config'] = 'gitconfig',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
    ['.*/%.vscode/.*%.json'] = 'jsonc',
    -- Borrowed from LazyVim. Mark huge files to disable features later.
    ['.*'] = function(path, bufnr)
      return vim.bo[bufnr]
          and vim.bo[bufnr].filetype ~= 'bigfile'
          and path
          and vim.fn.getfsize(path) > (1024 * 500) -- 500 KB
          and 'bigfile'
        or nil
    end,
  },
}
