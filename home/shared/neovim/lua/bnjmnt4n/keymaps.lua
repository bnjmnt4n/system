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
map('n', '<a-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<a-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<a-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<a-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<a-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<a-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Switch buffers
map('n', '<s-h>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<s-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- Move to window using the <ctrl> hjkl keys
map('n', '<c-h>', '<c-w>h', { desc = 'Go to left window' })
map('n', '<c-j>', '<c-w>j', { desc = 'Go to lower window' })
map('n', '<c-k>', '<c-w>k', { desc = 'Go to upper window' })
map('n', '<c-l>', '<c-w>l', { desc = 'Go to right window' })

-- Resize window using <ctrl> arrow keys
map('n', '<c-up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<c-down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<c-left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<c-right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

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
map('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- Execute last macro
map('n', 'Q', '@@')

-- Save file
map({ 'i', 'v', 'n', 's' }, '<c-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Persist selection after indentation in visual/select modes
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Remap escape to leave terminal mode
map('t', '<esc>', [[<c-\><c-n>]], { desc = 'Escape terminal mode' })

-- Y yank until the end of line
map('n', 'Y', 'y$', { desc = 'Yank to end of line' })

-- System clipboard yank/paste
map('n', '<leader>p', [["+p]], { desc = 'Paste from system clipboard (p)' })
map('n', '<leader>P', [["+P]], { desc = 'Paste from system clipboard (P)' })
map('n', '<leader>y', [["+y]], { desc = 'Yank to system clipboard (y)' })
map('n', '<leader>Y', [["+y$]], { desc = 'Yank to system clipboard (Y)' })
map('v', '<leader>Y', [["+y]], { desc = 'Yank from system clipboard (y)' })

-- Remap number increment to alt
map('n', '<a-a>', '<c-a>')
map('v', '<a-a>', '<c-a>')
map('n', '<a-x>', '<c-x>')
map('v', '<a-x>', '<c-x>')

-- Leader shortcuts

-- Buffers
map('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bp', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to other buffer' })

-- Code
map('n', '<leader>cd', [[:cd %:p:h<cr>:pwd<cr>]], { desc = 'Change directory' })

-- Files
map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New file' })
map('n', '<leader>fD', '<cmd>Delete!<cr>', { desc = 'Delete file' })
map('n', '<leader>fs', '<cmd>w<cr>', { desc = 'Save file' })

-- Neovim
map('n', '<leader>nl', '<cmd>:Lazy<cr>', { desc = 'Lazy' })

-- Open
map('n', '<leader>ol', '<cmd>lopen<cr>', { desc = 'Open location list' })
map('n', '<leader>oq', '<cmd>copen<cr>', { desc = 'Open quickfix list' })

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

map('n', '<leader>tH', function()
  local inlay_hints_enabled = vim.lsp.inlay_hint.is_enabled()
  inlay_hints_enabled = not inlay_hints_enabled
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
  local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
  enabled = not enabled
  vim.lsp.inlay_hint.enable(enabled, { bufnr = 0 })

  if enabled then
    vim.notify 'Enabled inlay hints (buffer)'
  else
    vim.notify 'Disabled inlay hints (buffer)'
  end
end, { desc = 'Toggle inlay hints (buffer)' })

map('n', '<leader>tg', function()
  ---@diagnostic disable-next-line: undefined-field
  local diagnostic_lines_enabled = vim.diagnostic.config().virtual_lines
  diagnostic_lines_enabled = not diagnostic_lines_enabled
  vim.diagnostic.config {
    virtual_lines = diagnostic_lines_enabled,
    virtual_text = not diagnostic_lines_enabled,
  }
  if diagnostic_lines_enabled then
    vim.notify 'Enabled diagnostic lines'
  else
    vim.notify 'Disabled diagnostic lines'
  end
end, { desc = 'Toggle diagnostic lines' })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map('n', '<leader>to', function()
  toggle('conceallevel', false, { 0, conceallevel })
end, { desc = 'Toggle conceal' })

-- Inspect highlights/treesitter nodes
lmap('n', '<leader>ti', vim.show_pos, { desc = 'Inspect position' })
lmap('n', '<leader>op', vim.treesitter.inspect_tree, { desc = 'Inspect tree' })

-- Quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })
map('n', '<leader>qQ', '<cmd>qa!<cr>', { desc = 'Force quit all' })

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
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>c', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })

-- LSP
lmap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })
lmap('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'Set location list' })

local function jump(opts)
  ---@diagnostic disable-next-line: undefined-field
  local diagnostic_lines_enabled = vim.diagnostic.config().virtual_lines
  opts = opts or {}
  opts.float = not diagnostic_lines_enabled
  vim.diagnostic.jump(opts)
end

lmap('n', '[d', function()
  jump { count = -vim.v.count1 }
end, { desc = 'Previous diagnostic' })
lmap('n', ']d', function()
  jump { count = vim.v.count1 }
end, { desc = 'Next diagnostic' })
lmap('n', ']D', function()
  jump { count = math.huge, wrap = false }
end, { desc = 'Last diagnostic' })
lmap('n', '[D', function()
  jump { count = -math.huge, wrap = false }
end, { desc = 'First diagnostic' })

-- Delete old keymaps
vim.keymap.del('n', 'grn')
vim.keymap.del({ 'n', 'x' }, 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del({ 'i', 's' }, '<c-s>')

lmap('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
lmap('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
lmap('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
lmap('n', '<leader>dt', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
lmap({ 'i', 's' }, '<c-k>', function()
  if require('blink.cmp.completion.windows.menu').win:is_open() then
    require('blink.cmp').hide()
  end
  vim.lsp.buf.signature_help {
    border = 'rounded',
    focusable = false,
  }
end, { desc = 'Signature help' })

-- Shortcut
lmap('n', '<leader>;', ':', { desc = 'Command' })
