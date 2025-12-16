local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function lmap(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Move lines
map('n', '<a-j>', '<cmd>move .+1<cr>==', { desc = 'Move down' })
map('n', '<a-k>', '<cmd>move .-2<cr>==', { desc = 'Move up' })
map('i', '<a-j>', '<esc><cmd>move .+1<cr>==gi', { desc = 'Move down' })
map('i', '<a-k>', '<esc><cmd>move .-2<cr>==gi', { desc = 'Move up' })
map('v', '<a-j>', ":move '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<a-k>', ":move '<-2<cr>gv=gv", { desc = 'Move up' })

-- Switch buffers
map('n', '<s-h>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<s-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- Move to window using the <ctrl> hjkl keys
map('n', '<c-h>', '<c-w>h', { desc = 'Go to left window' })
map('n', '<c-j>', '<c-w>j', { desc = 'Go to lower window' })
map('n', '<c-k>', '<c-w>k', { desc = 'Go to upper window' })
map('n', '<c-l>', '<c-w>l', { desc = 'Go to right window' })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>nohlsearch<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Clear search, diff update and redraw (taken from runtime/lua/_editor.lua)
map(
  'n',
  '<leader>tr',
  '<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>',
  { desc = 'Redraw / clear hlsearch / diff update' }
)

map('n', 'gw', '*N')
map('x', 'gw', '*N')

-- `n` always goes forward
map({ 'n', 'x', 'o' }, 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map({ 'n', 'x', 'o' }, 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Previous search result' })

-- Use gK for keywordprg, since K gets mapped to 'hover' in LSP buffers
map('n', 'gK', 'K')

-- Format whole buffer with formatprg without changing cursor position
map('n', 'gq<cr>', 'mzgggqG`z')

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- Execute last macro
map('n', 'Q', '@@')

-- Persist selection after indentation in visual/select modes
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Y yank until the end of line
map('n', 'Y', 'y$', { desc = 'Yank to end of line' })

-- Remap number increment to alt
map('n', '<a-a>', '<c-a>')
map('v', '<a-a>', '<c-a>')
map('n', '<a-x>', '<c-x>')
map('v', '<a-x>', '<c-x>')

-- Remap escape to leave terminal mode
map('t', '<esc>', [[<c-\><c-n>]], { desc = 'Escape terminal mode' })

-- Leader shortcuts

-- Shortcut
lmap('n', '<leader>;', ':', { desc = 'Command' })

-- System clipboard yank/paste
map('n', '<leader>p', [["+p]], { desc = 'Paste from system clipboard (p)' })
map('n', '<leader>P', [["+P]], { desc = 'Paste from system clipboard (P)' })
map({ 'n', 'v' }, '<leader>y', [['"+y']], { expr = true, desc = 'Yank to system clipboard (y)' })
map({ 'n', 'v' }, '<leader>Y', [["+y$]], { desc = 'Yank to system clipboard (Y)' })

-- Buffers
map('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bp', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<leader>bb', '<cmd>edit #<cr>', { desc = 'Switch to other buffer' })

-- Files
map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New file' })
map('n', '<leader>fs', '<cmd>write<cr>', { desc = 'Save file' })

-- Open quickfix/loclists
map(
  'n',
  '<leader>ol',
  [[empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<cr>' : ':lclose<cr>']],
  { expr = true, desc = 'Toggle location list' }
)
map(
  'n',
  '<leader>oq',
  [[empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<cr>' : ':cclose<cr>']],
  { expr = true, desc = 'Toggle quickfix list' }
)

-- Inspect highlights/treesitter nodes
lmap('n', '<leader>ti', vim.show_pos, { desc = 'Inspect position' })
lmap('n', '<leader>op', vim.treesitter.inspect_tree, { desc = 'Inspect tree' })

-- Quit
map('n', '<leader>qq', '<cmd>quitall<cr>', { desc = 'Quit all' })
map('n', '<leader>qQ', '<cmd>quitall!<cr>', { desc = 'Force quit all' })

-- Windows
map('n', '<leader>wh', '<c-w>h', { desc = 'Go to left window' })
map('n', '<leader>wj', '<c-w>j', { desc = 'Go to lower window' })
map('n', '<leader>wk', '<c-w>k', { desc = 'Go to upper window' })
map('n', '<leader>wl', '<c-w>l', { desc = 'Go to right window' })
map('n', '<leader>ww', '<c-w>p', { desc = 'Other window' })
map('n', '<leader>wc', '<c-w>c', { desc = 'Close window' })
map('n', '<leader>wd', '<c-w>c', { desc = 'Close window' })
map('n', '<leader>wv', '<c-w>v', { desc = 'Split window right' })
map('n', '<leader>ws', '<c-w>s', { desc = 'Split window below' })
map('n', '<leader>wm', '<c-w>_<c-w><bar>', { desc = 'Maximize window' })
map('n', '<leader>wo', '<c-w>o', { desc = 'Close other windows' })
map('n', '<leader>wt', '<c-w>T', { desc = 'Shift buffer to new tab' })

-- Tabs
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First tab' })
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last tab' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New tab' })
map('n', '<leader><tab>c', '<cmd>tabclose<cr>', { desc = 'Close tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close tab' })

-- Diagnostics
lmap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })
lmap('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Set location list' })
lmap('n', '<leader>dq', vim.diagnostic.setqflist, { desc = 'Set quickfix list' })

-- LSP
lmap('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
lmap('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
lmap('n', '<leader>ci', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
lmap('n', '<leader>ct', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
-- Delete old `gr` keymaps
vim.keymap.del({ 'n', 'v' }, 'gra')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'grt')

-- lmap({ 'i', 's' }, '<c-s>', function()
--   if require('blink.cmp.completion.windows.menu').win:is_open() then
--     require('blink.cmp').hide()
--   end
--   vim.lsp.buf.signature_help {
--     focusable = false,
--   }
-- end, { desc = 'Signature help' })

vim.keymap.del('i', '<c-s>')

-- Toggle

local function toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return vim.notify('Set ' .. option .. ' to ' .. vim.opt_local[option]:get())
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      vim.notify('Enabled ' .. option)
    else
      vim.notify('Disabled ' .. option)
    end
  end
end

-- stylua: ignore start
map('n', '<leader>ts', function() toggle 'spell' end, { desc = 'Toggle spelling' })
map('n', '<leader>tw', function() toggle 'wrap' end, { desc = 'Toggle word wrap' })
map('n', '<leader>tl', function() toggle 'number' end, { desc = 'Toggle line numbers' })
-- stylua: ignore end

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map('n', '<leader>to', function()
  toggle('conceallevel', false, { 0, conceallevel })
end, { desc = 'Toggle conceal' })

map('n', '<leader>tH', function()
  local inlay_hints_enabled = not vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(inlay_hints_enabled)
  if inlay_hints_enabled then
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      local filetype = vim.bo[bufnr].filetype
      if vim.api.nvim_buf_is_loaded(bufnr) then
        if require('bnjmnt4n.lsp').inlay_hint_disabled_filetypes[filetype] then
          vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end
      end
    end
    vim.notify 'Enabled inlay hints'
  else
    vim.notify 'Disabled inlay hints'
  end
end, { desc = 'Toggle inlay hints' })

map('n', '<leader>th', function()
  local enabled = not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
  vim.lsp.inlay_hint.enable(enabled, { bufnr = 0 })

  if enabled then
    vim.notify 'Enabled inlay hints (buffer)'
  else
    vim.notify 'Disabled inlay hints (buffer)'
  end
end, { desc = 'Toggle inlay hints (buffer)' })

local function toggle_diagnostic(name, values)
  return function()
    local config = vim.diagnostic.config() or {}
    local enabled = false
    for _, diag in ipairs(values) do
      enabled = enabled or config[diag]
    end
    enabled = not enabled

    local updated_config = {}
    for _, diag in ipairs(values) do
      updated_config[diag] = enabled
    end
    vim.diagnostic.config(updated_config)
    if enabled then
      vim.notify('Enabled diagnostic ' .. name)
    else
      vim.notify('Disabled diagnostic ' .. name)
    end
  end
end

map(
  'n',
  '<leader>tG',
  toggle_diagnostic('indicators', { 'underline', 'virtual_lines', 'virtual_text' }),
  { desc = 'Toggle diagnostic indicators' }
)
map('n', '<leader>tgu', toggle_diagnostic('underline', { 'underline' }), { desc = 'Toggle diagnostic underline' })
map(
  'n',
  '<leader>tgl',
  toggle_diagnostic('virtual lines', { 'virtual_lines' }),
  { desc = 'Toggle diagnostic virtual lines' }
)
map(
  'n',
  '<leader>tgt',
  toggle_diagnostic('virtual text', { 'virtual_text' }),
  { desc = 'Toggle diagnostic virtual text' }
)

map('n', '<leader>tu', function()
  if not vim.g.loaded_undotree_plugin then
    vim.cmd.packadd 'nvim.undotree'
  end
  vim.cmd.Undotree()
end, { desc = 'Toggle undotree' })
