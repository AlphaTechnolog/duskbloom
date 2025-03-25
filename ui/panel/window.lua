local wibox = require("wibox")
local awful = require("awful")
local oop = require("framework.oop")
local panel_config = Configuration.UserLikes:get_key("panel")
local wm_config = Configuration.UserLikes:get_key("wm")
local utils = require("framework.utils")()
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- local Taglist = require("ui.panel.modules.taglist")
local Tasklist = require("ui.panel.modules.tasklist")
-- local Statusbar = require("ui.panel.modules.statusbar")

local _window = {}

local CORNER_RADIUS = 12
local HEIGHT = 45

function _window:constructor(s)
  self.s = s
  self.gaps = nil
  self.is_floating = panel_config.floating or false
  self:make_window()
end

function _window:get_gaps()
  if self.gaps ~= nil then
    return self.gaps
  end

  local gaps = panel_config.gaps or "inherit"
  if gaps == "inherit" then
    gaps = dpi(wm_config.gaps)
  elseif type(gaps) == "number" then
    gaps = dpi(gaps)
  else
    error("Invalid gaps value on the user configuration of type " .. type(gaps) .. ": " .. gaps)
  end

  -- lets cache it.
  self.gaps = gaps

  return gaps
end

function _window:get_panel_position()
  local height = dpi(HEIGHT)
  local gaps = self:get_gaps()

  local position = {
    x = self.s.geometry.x,
    y = self.s.geometry.y + self.s.geometry.height - height,
    width = self.s.geometry.width,
    height = height,
  }

  if self.is_floating then
    position.x = position.x + gaps * 2
    position.y = position.y - gaps * 2
    position.width = self.s.geometry.width - gaps * 4
  end

  return position
end

function _window:make_window()
  local position = self:get_panel_position()
  local gaps = self.gaps or error("unreachable")

  self.popup = awful.popup({
    type = "dock",
    visible = false,
    bg = beautiful.colors.transparent,
    fg = beautiful.colors.foreground,
    x = position.x,
    y = position.y,
    minimum_width = position.width,
    maximum_width = position.width,
    minimum_height = position.height,
    maximum_height = position.height,
    widget = wibox.widget({
      widget = wibox.container.background,
      bg = beautiful.colors.background,
      shape = utils:srounded(dpi(CORNER_RADIUS)),
      {
        layout = wibox.layout.flex.horizontal,
        {
          widget = wibox.container.margin,
          left = dpi(12),
          {
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(4),
            {
              widget = wibox.widget.textbox,
              markup = 'hello',
            },
            {
              widget = wibox.widget.textbox,
              markup = 'hello',
            }
          }
        },
        {
          widget = wibox.container.place,
          valign = 'center',
          halign = 'center',
          {
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(7),
            Tasklist(self.s):render(),
          }
        },
        {
          widget = wibox.container.place,
          halign = 'right',
          hexpand = true,
          {
            widget = wibox.container.margin,
            right = dpi(12),
            {
              layout = wibox.layout.fixed.horizontal,
              spacing = dpi(4),
              {
                widget = wibox.widget.textbox,
                markup = 'hello',
              },
              {
                widget = wibox.widget.textbox,
                markup = 'hello',
              }
            }
          }
        },
      }
    }),
  })

  self.popup:struts({
    bottom = self.is_floating and position.height + gaps * 2 or position.height,
  })
end

function _window:raise()
  self.popup.visible = true
end

return oop(_window)
