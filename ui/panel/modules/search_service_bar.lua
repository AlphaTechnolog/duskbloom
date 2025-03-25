local wibox = require("wibox")
local hoverable = require("ui.guards.hoverable")
local utils = require("framework.utils")()
local oop = require("framework.oop")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local SearchServiceBar = {}

function SearchServiceBar:constructor(s)
  self.s = s
end

function SearchServiceBar:render()
  local container = hoverable(wibox.widget({
    widget = wibox.container.background,
    shape = utils:srounded(dpi(12)),
    bg = beautiful.colors.light_background_6,
    fg = beautiful.colors.light_hovered_black_15,
    {
      widget = wibox.container.margin,
      margins = utils:xmargins(0, 0, 12, 85),
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(2),
        {
          widget = wibox.widget.textbox,
          font = beautiful.fonts:choose("icons", 14),
          valign = "center",
          align = "left",
          markup = utils:colorize_markup(beautiful.colors.accent, ""),
        },
        {
          widget = wibox.widget.textbox,
          markup = "Search",
          valign = "center",
          align = "left",
        },
      },
    },
  }))

  container:setup_hover({
    colors = {
      normal = beautiful.colors.light_background_6,
      hovered = beautiful.colors.light_background_12,
    },
  })

  return container
end

return oop(SearchServiceBar)
