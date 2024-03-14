vim.filetype.add {
  extension = {
    astro = 'astro',
  },
  filename = {
    ['.eslintrc.json'] = 'jsonc',
    ['flake.lock'] = 'json',
    ['.git/config'] = 'gitconfig',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
    ['.*/%.vscode/.*%.json'] = 'jsonc',
  },
}
