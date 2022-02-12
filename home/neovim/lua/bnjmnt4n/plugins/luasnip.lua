local ls = require 'luasnip'

local types = require 'luasnip.util.types'

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

ls.config.set_config {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  delete_check_events = 'InsertLeave',
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { 'choiceNode', 'Comment' } },
      },
    },
  },
  ext_base_prio = 300,
  ext_prio_increase = 1,
  enable_autosnippets = true, -- vim.g.slow_device ~= 1,
}

ls.snippets = {
  all = {},
}

ls.autosnippets = {
  typescriptreact = {
    ls.parser.parse_snippet('imp', 'import { $0 } from "$1";'),
    ls.parser.parse_snippet(
      'comp',
      'type $1Props = {\n};\n\nexport function $1({ $2 }: $1Props) {\n  return (\n    <$3>\n      $0\n    </$3>\n  );\n}\n'
    ),
    ls.parser.parse_snippet('fn', 'function $1($2: $3) {\n  $0\n}\n'),
    ls.parser.parse_snippet('efn', 'export function $1($2: $3) {\n  $0\n}\n'),
    ls.parser.parse_snippet('story', 'export function $1({ }: $2) {\n  $0\n}\n'),
    ls.parser.parse_snippet('usest', 'const [$1, set$1] = useState($0);'),
  },
  typescript = {
    ls.parser.parse_snippet('imp', 'import { $0 } from "$1";'),
    ls.parser.parse_snippet('fn', 'function $1($2: $3) {\n  $0\n}\n'),
    ls.parser.parse_snippet('efn', 'export function $1($2: $3) {\n  $0\n}\n'),
    ls.parser.parse_snippet('usest', 'const [$1, set$1] = useState($0);'),
  },
  javascript = {
    ls.parser.parse_snippet('imp', 'import { $0 } from "$1";'),
    ls.parser.parse_snippet('fn', 'function $1($2: $3) {\n  $0\n}\n'),
    ls.parser.parse_snippet('efn', 'export function $1($2: $3) {\n  $0\n}\n'),
    ls.parser.parse_snippet('usest', 'const [$1, set$1] = useState($0);'),
  },
}
