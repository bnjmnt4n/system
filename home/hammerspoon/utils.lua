local function bindHotkeys(modifier, mapping, callback)
  for key, value in pairs(mapping) do
    hs.hotkey.bind(modifier, key, function()
      callback(value)
    end)
  end
end

-- Based on https://github.com/Hammerspoon/Spoons/blob/master/Source/WindowHalfsAndThirds.spoon/init.lua#L77.
local function round(x, places)
  local places = places or 0
  local x = x * 10 ^ places
  return (x + 0.5 - (x + 0.5) % 1) / 10 ^ places
end

local function getWindowRect(win)
  local ur, r = win:screen():toUnitRect(win:frame()), round
  return { r(ur.x, 2), r(ur.y, 2), r(ur.w, 2), r(ur.h, 2) }
end

local function cycleApplicationWindows(bundleID, path)
  local running = hs.application.applicationsForBundleID(bundleID)

  if #running == 0 then
    if path ~= nil then
      hs.application.launchOrFocus(path)
    else
      hs.application.launchOrFocusByBundleID(bundleID)
    end
  else
    local app = running[1]
    local focusedWindow = hs.window.focusedWindow()

    -- TODO: tweak behavior?
    if focusedWindow and focusedWindow:application():bundleID() == bundleID then
      local focusCurrentWindow = false
      for _, window in pairs(app:allWindows()) do
        if focusCurrentWindow then
          window:focus()
          return
        elseif window == focusedWindow then
          focusCurrentWindow = true
        end
      end
      if focusCurrentWindow then
        app:hide()
      end
    else
      app:activate()
    end
  end
end

return {
  bindHotkeys = bindHotkeys,
  getWindowRect = getWindowRect,
  cycleApplicationWindows = cycleApplicationWindows,
}
