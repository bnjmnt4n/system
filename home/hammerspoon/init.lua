local hotkey = require 'hs.hotkey'
local utils = require 'utils'

local hyper = { 'ctrl', 'alt', 'cmd', 'shift' }
hotkey.bind(hyper, ';', hs.reload)
hs.logger.defaultLogLevel = 'verbose'
hs.window.animationDuration = 0

-- Application shortcuts

utils.bindHotkeys(hyper, {
  b = { 'org.mozilla.firefox', '@firefox@' },
  f = { 'com.apple.finder', 'Finder' },
  m = { 'com.spotify.client', '@spotify@' },
  t = { 'com.github.wez.wezterm', '@wezterm@' },
  ['return'] = { 'com.github.wez.wezterm', '@wezterm@' },
}, function(app)
  utils.cycleApplicationWindows(app[1], app[2])
end)

-- Window management

local window_sizes = {
  left_half = { 0, 0, 0.5, 1 },
  right_half = { 0.5, 0, 0.5, 1 },
  top_half = { 0, 0, 1, 0.5 },
  bottom_half = { 0, 0.5, 1, 0.5 },
  top_left = { 0, 0, 0.5, 0.5 },
  top_right = { 0.5, 0, 0.5, 0.5 },
  bottom_left = { 0, 0.5, 0.5, 0.5 },
  bottom_right = { 0.5, 0.5, 0.5, 0.5 },
  left_third = { 0, 0, 0.33, 1 },
  center_third = { 0.33, 0, 0.34, 1 },
  right_third = { 0.67, 0, 0.33, 1 },
  first_two_thirds = { 0, 0, 0.67, 1 },
  last_two_thirds = { 0.33, 0, 0.67, 1 },
  maximize = { 0, 0, 1, 1 },
}

utils.bindHotkeys({ 'ctrl', 'alt' }, {
  Left = 'left_half',
  Right = 'right_half',
  Up = 'top_half',
  Down = 'bottom_half',
  u = 'top_left',
  i = 'top_right',
  j = 'bottom_left',
  k = 'bottom_right',
  d = 'left_third',
  f = 'center_third',
  g = 'right_third',
  e = 'first_two_thirds',
  t = 'last_two_thirds',
  ['return'] = 'maximize',
}, function(key)
  local win = hs.window.focusedWindow()
  if win == nil then
    return
  end
  win:moveToUnit(window_sizes[key])
end)

-- -- TODO: Figure out animation.
-- utils.bindHotkeys({ 'ctrl', 'alt', 'shift' }, {
--   Left = 'Tile Window to Left of Screen',
--   Right = 'Tile Window to Right of Screen',
-- }, function(menuItem)
--   hs.window.focusedWindow():application():selectMenuItem(menuItem)
-- end)

hotkey.bind({ 'ctrl', 'alt' }, 'c', function()
  local win = hs.window.focusedWindow()
  if win == nil then
    return
  end
  win:centerOnScreen()
end)

-- Increase window size
hotkey.bind({ 'ctrl', 'alt' }, '=', function()
  local win = hs.window.focusedWindow()
  if win == nil then
    return
  end
  local cw = utils.getWindowRect(win)
  local move_to_rect = {}
  move_to_rect[1] = math.max(cw[1] - 0.02, 0)
  move_to_rect[2] = math.max(cw[2] - 0.02, 0)
  move_to_rect[3] = math.min(cw[3] + 0.04, 1 - move_to_rect[1])
  move_to_rect[4] = math.min(cw[4] + 0.04, 1 - move_to_rect[2])
  win:move(move_to_rect)
end)

-- Decrease window size
hotkey.bind({ 'ctrl', 'alt' }, '-', function()
  local win = hs.window.focusedWindow()
  if win == nil then
    return
  end
  local cw = utils.getWindowRect(win)
  local move_to_rect = {}
  move_to_rect[3] = math.max(cw[3] - 0.04, 0.1)
  move_to_rect[4] = cw[4] > 0.95 and 1 or math.max(cw[4] - 0.04, 0.1) -- some windows (MacVim) don't size to 1
  move_to_rect[1] = math.min(cw[1] + 0.02, 1 - move_to_rect[3])
  move_to_rect[2] = cw[2] == 0 and 0 or math.min(cw[2] + 0.02, 1 - move_to_rect[4])
  win:move(move_to_rect)
end)

utils.bindHotkeys({ 'ctrl', 'alt', 'shift' }, {
  Left = 'moveOneScreenWest',
  Right = 'moveOneScreenEast',
  Up = 'moveOneScreenNorth',
  Down = 'moveOneScreenSouth',
}, function(fnKey)
  local win = hs.window.focusedWindow()
  if win == nil then
    return
  end
  win[fnKey](win)
  win:moveToUnit(window_sizes.maximize)
end)

require 'hs.ipc'

hs.alert.show 'Config loaded'
