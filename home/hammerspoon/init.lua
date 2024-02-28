local hotkey = require 'hs.hotkey'
local utils = require 'utils'

local hyper = { 'ctrl', 'alt', 'cmd', 'shift' }
hotkey.bind(hyper, ';', hs.reload)
hs.logger.defaultLogLevel = 'verbose'
hs.window.animationDuration = 0

-- Application shortcuts

utils.bindHotkeys(hyper, {
  b = { 'org.mozilla.firefox', '@firefox@' },
  c = { 'dev.zed.Zed-Preview', '@zed@' },
  f = { 'com.apple.finder', 'Finder' },
  m = { 'com.spotify.client', '@spotify@' },
  t = { 'com.github.wez.wezterm', '@wezterm@' },
  ['return'] = { 'com.github.wez.wezterm', '@wezterm@' },
}, function(app)
  utils.cycleApplicationWindows(app[1], app[2])
end)

require 'hs.ipc'

hs.alert.show 'Config loaded'
