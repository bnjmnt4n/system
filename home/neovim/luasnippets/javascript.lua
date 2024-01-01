local manual = {
  -- Imports
  s(
    { trig = 'imp', name = 'import' },
    fmt("import {} from '{}';", {
      c(2, {
        r(nil, 'user_text', i(1, '*')),
        sn(nil, { t '{', r(1, 'user_text'), t '}' }),
      }),
      i(1),
    })
  ),

  -- Variables

  -- Control flow
  s(
    { trig = 'if', name = 'if statement' },
    fmt(
      [[
        if ({}) {{
          {}
        }}
      ]],
      { i(1, 'condition'), i(2) }
    )
  ),
  s(
    { trig = 'el', name = 'else statement' },
    fmt(
      [[
        else {{
          {}
        }}
      ]],
      { i(1) }
    )
  ),
  s(
    { trig = 'elif', name = 'else if statement' },
    fmt(
      [[
        else if ({}) {{
          {}
        }}
      ]],
      { i(1, 'condition'), i(2) }
    )
  ),

  -- Functions
  s(
    { trig = 'fn', name = 'function declaration' },
    fmt(
      [[
        function {}({}) {{
          {}
        }}
      ]],
      { i(1), i(2), i(3) }
    )
  ),
  s(
    { trig = 'afn', name = 'async function declaration' },
    fmt(
      [[
        async function {}({}) {{
          {}
        }}
      ]],
      { i(1), i(2), i(3) }
    )
  ),

  -- Arrow functions??
  -- s(
  --   'af',
  --   fmt(
  --     [[
  --       {}{}{}({}) => {{
  --         {}
  --       }}
  --     ]],
  --     {
  --       -- To choose if its anonymous or save it in a variable
  --       c(1, { t 'const ', t '', t 'async ' }),
  --       -- Dynamic, if it is const then ask for the name
  --       d(2, function(func_type)
  --         if func_type[1][1]:match 'const' then
  --           return sn(nil, {
  --             i(1),
  --             t ' = ',
  --           })
  --         end
  --         return sn(nil, t '')
  --       end, {
  --         1,
  --       }),
  --       -- Even if const check if want it async
  --       d(3, function(func_type)
  --         if func_type[1][1]:match 'const' then
  --           return sn(nil, c(1, { t '', t 'async ' }))
  --         end
  --         return sn(nil, t '')
  --       end, {
  --         1,
  --       }),
  --       -- Parameters
  --       i(4),
  --       i(0),
  --     }
  --   )
  -- ),

  -- Utility
  s({ trig = 'log', name = 'console.log' }, fmt('console.log({}); ', { i(1) })),

  -- Testing
  s(
    'describe',
    fmt(
      [[
        describe('{}', () => {{
          {}
        }});
      ]],
      { i(1), i(2) }
    )
  ),
  s(
    'it',
    fmt(
      [[
        it('should {}', async () => {{
          {}
        }});
      ]],
      { i(1), i(2) }
    )
  ),
}

local auto = {}

return manual, auto
