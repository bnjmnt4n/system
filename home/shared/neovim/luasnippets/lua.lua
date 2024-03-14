local manual = {
  s(
    'var',
    fmt([[{}{} = {}]], {
      c(1, { t 'local ', t '' }),
      i(2),
      i(3),
    })
  ),
  s(
    'mod',
    fmt(
      [[
      local M = {{}}

      {}

      return M
      ]],
      { i(1) }
    )
  ),
  s(
    'fn',
    fmt(
      [[
        {}function {}({})
            {}
        end
      ]],
      {
        c(1, { t 'local ', t '' }),
        i(2),
        i(3),
        i(0),
      }
    )
  ),
}

local auto = {}

return manual, auto
