local wibox = require("wibox")
local awful = require("awful")
local hoverable = require("ui.guards.hoverable")
local utils = require("framework.utils")()
local oop = require("framework.oop")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local _layoutbox = {}

function _layoutbox:constructor(s)
  self.s = s
end

function _layoutbox:render()
  local layoutbox = hoverable(wibox.widget({
    widget = wibox.container.background,
    bg = beautiful.colors.background,
    shape = utils:srounded(dpi(7)),
    {
      widget = wibox.container.margin,
      margins = dpi(6),
      {
        widget = awful.widget.layoutbox,
        screen = self.s,
        forced_width = dpi(18),
        forced_height = dpi(18),
      },
    },

    buttons = {
      awful.button({}, 1, function()
        awful.layout.inc(1)
      end),
      awful.button({}, 3, function()
        awful.layout.inc(-1)
      end),
      awful.button({}, 4, function()
        awful.layout.inc(1)
      end),
      awful.button({}, 5, function()
        awful.layout.inc(-1)
      end),
    },
  }))

  layoutbox:setup_hover({
    colors = {
      normal = beautiful.colors.background,
      hovered = beautiful.colors.light_background_8,
    },
  })

  return layoutbox
end

return oop(_layoutbox)
