-- https://github.com/dnaaun/dotfiles/blob/f6f0e8e79b82ad203b5129b76ee5b84d66d8d02d/.config/nvim/luasnippets/typescriptreact.lua#L53
-- https://github.com/schardev/dotfiles/blob/5289e12aa63bb895c5eee55f4eecfaa8e11bc135/config/nvim/snippets/luasnippets/javascriptreact.lua#L4
-- https://github.com/rafamadriz/friendly-snippets/wiki/Javascript,-Typescript,-Javascriptreact,-Typescriptreact#la-let-assignment-awaited

local function get_probable_react_comp_name()
  local dir_name = vim.fn.expand('%'):match '([^/]+)/[^/]+$'
  local file_name = vim.fn.expand '%:t'

  if vim.fn.match(file_name, '\\(index\\|stories\\)\\..*tsx\\?') == 0 then
    return dir_name
  else
    return vim.fn.substitute(file_name, '\\..*$', '', 'g')
  end
end

local manual = {
  s({ trig = 'uc', name = 'use client directive' }, { t '"use client";' }),
  s({ trig = 'use', name = 'use server directive' }, { t '"use server";' }),
  s({ trig = 'imr', name = 'import react' }, t "import React from 'react';"),
  s({ trig = 'cn', name = 'classname prop' }, {
    fmt('className={}', {
      c(1, {
        sn(nil, { t '"', i(1, ''), t '"' }),
        sn(nil, { t '{', i(1, ''), t '}' }),
      }),
    }),
  }),
  s(
    { trig = 'p', name = 'prop={prop}' },
    fmt('{}={{{}}}', {
      i(1, 'prop'),
      rep(1),
    })
  ),

  -- React components
  s(
    'rc',
    fmt(
      [[
        function {}({}) {{
          return (
            {}
          );
        }}
      ]],
      {
        d(1, function()
          return sn(nil, {
            i(1, get_probable_react_comp_name()),
          })
        end),
        i(2, 'props'),
        i(3, 'children'),
      }
    )
  ),

  s(
    'trc',
    fmt(
      [[
        type {ComponentName}Props = {{
          {}
        }};

        function {}({}: {ComponentName}Props) {{
          return (
            {}
          );
        }}
      ]],
      {
        i(2),
        d(1, function()
          return sn(nil, {
            i(1, get_probable_react_comp_name()),
          })
        end),
        i(3, 'props'),
        i(4, 'children'),
        ComponentName = l(l._1, 1),
      }
    )
  ),
  s(
    'frc',
    fmt(
      [[
        import React from 'react';

        type {ComponentName}Props = {{
          {}
        }};

        export function {}({}: {ComponentName}Props) {{
          return (
            {}
          );
        }}
      ]],
      {
        i(2),
        d(1, function()
          return sn(nil, {
            i(1, get_probable_react_comp_name()),
          })
        end),
        i(3, 'props'),
        i(4, 'children'),
        ComponentName = l(l._1, 1),
      }
    )
  ),

  -- Hooks
  s(
    'us',
    fmt(
      [[
        const [{}, set{State}] = useState({});
      ]],
      {
        i(1, 'state'),
        i(2, 'initialState'),
        State = l(l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1),
      }
    )
  ),

  s(
    'ur',
    fmt(
      [[
        const {}Ref = useRef({});
      ]],
      { i(1), i(2), Type = i 'a' }
    )
  ),
  s(
    'um',
    fmt(
      [[
        const {} = useMemo(() => {}, [{}]);
      ]],
      { i(1), i(2), i(3, 'deps') }
    )
  ),

  s(
    'ue',
    fmt(
      [[
        useEffect(() => {{
          {}
        }}{});
      ]],
      {
        i(1),
        c(2, {
          sn(nil, { t ', [', i(1, 'deps'), t ']' }),
          t '',
        }),
      }
    )
  ),

  s(
    'ule',
    fmt(
      [[
        useLayoutEffect(() => {{
          {}
        }}{});
      ]],
      {
        i(1),
        c(2, {
          sn(nil, { t ', [', i(1, 'deps'), t ']' }),
          t '',
        }),
      }
    )
  ),
}

local auto = {}

return manual, auto
