local M = {}

-- TODO: Limit the depth of the AST nodes to be selected?
local function get_ast_nodes()
  local winnr = vim.api.nvim_get_current_win()
  local wininfo = vim.fn.getwininfo(winnr)[1]

  local nodes = {} ---@type TSNode[]

  ---@param node TSNode
  local function is_node_visible(node)
    local startline, _, _, _ = node:range()
    return startline + 1 >= wininfo.topline and startline + 1 <= wininfo.botline
  end

  ---@param node TSNode
  ---@param include_parent boolean?
  local function add_node(node, include_parent)
    include_parent = include_parent ~= false
    local startline, _, endline, _ = node:range()

    -- No need to add node and any child nodes if the whole node is not visible.
    if startline + 1 > wininfo.botline or endline + 1 < wininfo.topline then
      return
    end

    -- Add node as target if its startline is visible.
    if include_parent and startline + 1 >= wininfo.topline and startline + 1 <= wininfo.botline then
      -- Exclude `content` node types, since these are typically the contents of string literals.
      local type = node:type()
      if type ~= 'content' and not type:match '_content$' then
        table.insert(nodes, node)
      end
    end

    -- Recursively add named child nodes.
    for index = 0, node:named_child_count() - 1 do
      local child = node:named_child(index)
      if child then
        add_node(child)
      end
    end
  end

  do
    -- Get current TS node.
    local node = vim.treesitter.get_node()
    if not node then
      return
    end

    -- Add child nodes as targets.
    add_node(node, false)

    -- Add sibling nodes and their children, and recursively obtain parent nodes.
    while node do
      local prev = node:prev_named_sibling()
      while prev do
        add_node(prev)
        prev = is_node_visible(prev) and prev:prev_named_sibling() or nil
      end

      table.insert(nodes, node)

      local next = node:next_named_sibling()
      while next do
        add_node(next)
        next = is_node_visible(next) and next:next_named_sibling() or nil
      end

      node = node:parent()
    end
  end

  -- Create Leap targets from TS nodes.
  local targets = {}
  for _, node in ipairs(nodes) do
    local startline, startcol, endline, endcol = node:range()
    local startpos = { startline + 1, startcol + 1 }
    local endpos = { endline + 1, endcol + 1 }

    -- Add start of node only.
    if startline + 1 >= wininfo.topline and startline + 1 <= wininfo.botline then
      table.insert(targets, { pos = startpos, altpos = endpos })
    end

    -- Add end of node?
    -- if endline + 1 >= wininfo.topline and endline + 1 <= wininfo.botline then
    --   table.insert(targets, { pos = endpos, altpos = startpos })
    -- end
  end
  if #targets >= 1 then
    return targets
  end
end

-- TODO: account for range?
local function select_range(target)
  local mode = vim.api.nvim_get_mode().mode

  -- Force going back from Normal to Visual mode (implies mode = v | V | ).
  if not mode:match 'n?o' then
    vim.cmd('normal! ' .. mode)
  end

  vim.fn.cursor(unpack(target.pos))
  local v = mode:match 'V' and 'V' or mode:match '' and '' or 'v'
  vim.cmd('normal! ' .. v)
  vim.fn.cursor(unpack(target.altpos))
end

function M.leap_treesitter()
  require('leap').leap {
    target_windows = { vim.api.nvim_get_current_win() },
    targets = get_ast_nodes(),
    action = vim.api.nvim_get_mode().mode ~= 'n' and select_range,
  }
end

return M
